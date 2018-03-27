USE referral;

-- A
-- | |
-- B C
-- | |
-- D E
--   |
--   F
--   | | |
--   G H  I
--     |
--     J

INSERT INTO user
  (id, name, email, password, referral_code, is_referred)
VALUES
  (1, 'A', 'a@example.com', '$2a$08$3BxHbhf0LX..5gMuzhP9nehnbeeKKTQ7qzu5byemoeJFD6blEtLWa', 'UFYUDYFHGD', 1),
  (2, 'B', 'b@example.com', '$2a$08$3BxHbhf0LX..5gMuzhP9nehnbeeKKTQ7qzu5byemoeJFD6blEtLWa', 'JDVUYSVUYD', 1),
  (3, 'C', 'c@example.com', '$2a$08$3BxHbhf0LX..5gMuzhP9nehnbeeKKTQ7qzu5byemoeJFD6blEtLWa', 'WIUEYIWUEI', 1),
  (4, 'D', 'd@example.com', '$2a$08$3BxHbhf0LX..5gMuzhP9nehnbeeKKTQ7qzu5byemoeJFD6blEtLWa', 'CMHVHVJDHV', 1),
  (5, 'E', 'e@example.com', '$2a$08$3BxHbhf0LX..5gMuzhP9nehnbeeKKTQ7qzu5byemoeJFD6blEtLWa', 'OIWEYOIWWI', 1),
  (6, 'F', 'f@example.com', '$2a$08$3BxHbhf0LX..5gMuzhP9nehnbeeKKTQ7qzu5byemoeJFD6blEtLWa', 'WPEUIWEOIE', 1),
  (7, 'G', 'g@example.com', '$2a$08$3BxHbhf0LX..5gMuzhP9nehnbeeKKTQ7qzu5byemoeJFD6blEtLWa', 'SKJSBKDKDK', 1),
  (8, 'H', 'h@example.com', '$2a$08$3BxHbhf0LX..5gMuzhP9nehnbeeKKTQ7qzu5byemoeJFD6blEtLWa', 'WKNLWKNWDN', 1),
  (9, 'I', 'i@example.com', '$2a$08$3BxHbhf0LX..5gMuzhP9nehnbeeKKTQ7qzu5byemoeJFD6blEtLWa', 'KJBDKJBDEK', 1),
  (10, 'J', 'j@example.com', '$2a$08$3BxHbhf0LX..5gMuzhP9nehnbeeKKTQ7qzu5byemoeJFD6blEtLWa', 'EIHDJEJEBJ', 1);

INSERT INTO user_node
  (id, immediate_parent_ref_id)
VALUES
  (1, NULL),
  (2, 1),
  (3, 1),
  (4, 2),
  (5, 3),
  (6, 5),
  (7, 6),
  (8, 6),
  (9, 6),
  (10, 8);
