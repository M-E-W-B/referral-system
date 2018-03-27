-- Create a user
INSERT INTO user
  (id, name, email, password, referral_code, is_referred)
VALUES
  (11, 'K', 'k@example.com', '$2a$08$3BxHbhf0LX..5gMuzhP9nehnbeeKKTQ7qzu5byemoeJFD6blEtLWa', 'UJGDJEJEBJ', 0);

-- Get a user by id
SELECT
  id, name, email, password, referral_code, is_referred
FROM user
WHERE id = 11 AND deleted_at IS NULL;

-- Update a user
UPDATE user
SET is_referred = 1
WHERE id = 11 AND deleted_at IS NULL;

-- Delete a user
UPDATE user
SET deleted_at = NOW()
WHERE id = 11;

-- List all users
SELECT
  id, name, email, password, referral_code, is_referred
FROM user
WHERE deleted_at IS NULL;

-- List all users along with filters
SELECT
  id, name, email, password, referral_code, is_referred
FROM user
WHERE
  name LIKE '%A%' AND email LIKE '%a@%' AND deleted_at IS NULL;

-- List all users along with search
SELECT
  id, name, email, password, referral_code, is_referred
FROM user
WHERE
  LOWER(CONCAT(name, email)) LIKE '%ff%' AND deleted_at IS NULL;


-- List all the parents of a node
SELECT
  parent_ref_id, child_ref_id, depth
FROM referral_tree
WHERE child_ref_id = 8
ORDER BY depth DESC;

-- List all the children of a node
SELECT
  parent_ref_id, child_ref_id, depth
FROM referral_tree
WHERE parent_ref_id = 5
ORDER BY depth;
