CREATE TABLE IF NOT EXISTS 
guid_to_user ( -- provides a lookup table for logged-in users to the associated user id.
  guid VARCHAR(36), -- mysql generates 36 letter guid's.
  user_id INT
);
