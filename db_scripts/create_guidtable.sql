CREATE TABLE IF NOT EXISTS 
guid_to_user ( -- provides a lookup table for logged-in users to the associated user id.
  guid VARCHAR(36), -- mysql generates 36 letter guid's.
  user_id INT NOT NULL,
  FOREIGN KEY FK_user_id_user_id (user_id) 
    REFERENCES user (user_id) 
    ON DELETE CASCADE
);
