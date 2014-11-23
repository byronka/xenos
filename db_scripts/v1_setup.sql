-- Note that these scripts will be run in the order written

-- as a necessary
-- separator between SQL scripts, we use the delimiter keyword, having three
-- dashes in front and back, that you see below. 

---DELIMITER---

-- add a procedure for setting version
CREATE PROCEDURE set_version
(IN version INT) 
BEGIN 
	UPDATE config set config_value = version
	WHERE config_item = 'db_version';
END

---DELIMITER---
CALL set_version(1);
---DELIMITER---

-- create the user table

CREATE TABLE IF NOT EXISTS 
  user (
    user_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    first_name NVARCHAR(100),
    last_name NVARCHAR(100),
    email NVARCHAR(200),
    password NVARCHAR(100)
  );

---DELIMITER---


-- add_security_cols_to_usertable.sql

ALTER TABLE user 
ADD COLUMN (
  is_logged_in BOOL, 
  last_time_logged_in DATETIME,
  last_ip_logged_in VARCHAR(40)
)

---DELIMITER---
-- create_guidtable.sql

CREATE TABLE IF NOT EXISTS 
guid_to_user ( -- provides a lookup table for logged-in users to the associated user id.
  guid VARCHAR(36), -- mysql generates 36 letter guid's.
  user_id INT NOT NULL,
  FOREIGN KEY FK_user_id_user_id (user_id) 
    REFERENCES user (user_id) 
    ON DELETE CASCADE
);

---DELIMITER---
-- add_register_user_cookie_proc

CREATE PROCEDURE register_user_cookie
(IN user_id_param INT) 
BEGIN 
DELETE FROM guid_to_user WHERE user_id = user_id_param; 
INSERT guid_to_user (guid, user_id) VALUES (UUID(),user_id_param);  
END

---DELIMITER---
-- create_request_table

CREATE TABLE IF NOT EXISTS 
request ( 
  request_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  datetime DATETIME,
  description NVARCHAR(1000),
  points INT,
  status VARCHAR(100),
  title NVARCHAR(255),
  requesting_user INT NOT NULL,
  FOREIGN KEY FK_requesting_user_user_id (requesting_user) 
    REFERENCES user (user_id) 
    ON DELETE CASCADE
);
