-- Do not check foreign key constraints
-- http://www.cloudconnected.fr/2009/05/26/trees-in-sql-an-approach-based-on-materialized-paths-and-normalization-for-mysql/

SET FOREIGN_KEY_CHECKS=0;

DROP DATABASE IF EXISTS referral;
CREATE DATABASE referral;
USE referral;

DROP TABLE IF EXISTS user;
CREATE TABLE user (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  email VARCHAR(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  password BINARY(60) NULL,
  referral_code CHAR(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  is_referred TINYINT NOT NULL DEFAULT 1,

  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  deleted_at TIMESTAMP NULL,
  PRIMARY KEY (id),
  UNIQUE(referral_code),
  UNIQUE(email)
);

DROP TABLE IF EXISTS user_node;
CREATE TABLE user_node (
  id INT UNSIGNED NOT NULL,
  immediate_parent_ref_id INT UNSIGNED NULL,

  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  deleted_at TIMESTAMP NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (id) REFERENCES user(id),
  FOREIGN KEY (immediate_parent_ref_id) REFERENCES user(id)
);

DROP TABLE IF EXISTS referral_tree;
CREATE TABLE referral_tree (
  parent_ref_id INT UNSIGNED NOT NULL,
  child_ref_id INT UNSIGNED NOT NULL,
  depth INT UNSIGNED NOT NULL DEFAULT 0,

  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  deleted_at TIMESTAMP NULL,
  PRIMARY KEY (parent_ref_id, child_ref_id),
  FOREIGN KEY (parent_ref_id) REFERENCES user(id),
  FOREIGN KEY (child_ref_id) REFERENCES user(id)
);

DELIMITER //
CREATE TRIGGER tr_construct_tree
AFTER INSERT ON user_node
FOR EACH ROW BEGIN
    INSERT INTO referral_tree (parent_ref_id, child_ref_id, depth)
    VALUES (NEW.id, NEW.id, 0);

    INSERT INTO referral_tree (parent_ref_id, child_ref_id, depth)
        SELECT parent_ref_id, NEW.id, depth + 1
        FROM referral_tree
        WHERE child_ref_id = NEW.immediate_parent_ref_id;
END;//
DELIMITER ;

DELIMITER //
CREATE TRIGGER tr_update_tree
AFTER UPDATE ON user_node
FOR EACH ROW BEGIN
    IF NEW.immediate_parent_ref_id != OLD.immediate_parent_ref_id OR NEW.immediate_parent_ref_id IS NULL OR OLD.immediate_parent_ref_id IS NULL THEN
        IF OLD.immediate_parent_ref_id IS NOT NULL THEN
            DELETE t2
            FROM referral_tree t1
            JOIN referral_tree t2 ON t1.child_ref_id = t2.child_ref_id
            WHERE t1.parent_ref_id = OLD.id
            AND t2.depth > t1.depth;
        END IF;

        IF NEW.immediate_parent_ref_id IS NOT NULL THEN
            INSERT INTO referral_tree (parent_ref_id, child_ref_id, depth)
                SELECT t1.parent_ref_id, t2.child_ref_id, t1.depth + t2.depth + 1
                FROM referral_tree t1, referral_tree t2
                WHERE t1.child_ref_id = NEW.immediate_parent_ref_id
                AND t2.parent_ref_id = OLD.id;
        END IF;
    END IF;
END;//
DELIMITER ;
