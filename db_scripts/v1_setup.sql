-- Note that these scripts will be run in the order written

-- as a necessary
-- separator between SQL scripts, we use the delimiter keyword, having three
-- dashes in front and back, that you see below. 

---DELIMITER---

-- add a procedure for setting version
-- the version should be incremented every time 
-- a release is sent to production.

CREATE PROCEDURE set_version
(IN version INT) 
BEGIN 
  UPDATE config set config_value = version
  WHERE config_item = 'db_version';
END

---DELIMITER---
-- Here we set the version of the database.  
-- This needs to get incremented each release.

CALL set_version(1);

---DELIMITER---

-- create the user table

CREATE TABLE IF NOT EXISTS 
  user (
    user_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    username NVARCHAR(50) UNIQUE,
    email NVARCHAR(200) UNIQUE, 
    password NVARCHAR(100),
    points int unsigned,
    language int unsigned NULL,
    is_logged_in BOOL, 
    last_time_logged_in DATETIME,
    last_ip_logged_in VARCHAR(40),
    rank INT NOT NULL DEFAULT 50
  );

---DELIMITER---

-- create a trigger to cause an error condition if someone tries
-- adding a username that is a string that equates to an email.
-- we want uniqueness of usernames, emails, and also usernames are
-- not allowed to match existing emails in other users.

CREATE TRIGGER trg_error_if_username_matches_other_user_email 
BEFORE INSERT ON user
FOR EACH ROW
BEGIN
    DECLARE msg VARCHAR(255);
    SET @username_exists_as_email := 
      (
        SELECT COUNT(*) 
        FROM user 
        WHERE NEW.username = user.email
      );
    
    IF (@username_exists_as_email > 0) THEN
        SET msg = CONCAT('username matches existing email during insert: ', NEW.username );
        signal sqlstate '45000' set message_text = msg;
    END IF;

END

---DELIMITER---

-- this guy is an enum only.  Don't expect to put this value
-- directly into the output.  Rather, we use the number to determine
-- which localized value to get.  That is, it will make it easier for
-- use when we need to translate languages.

CREATE TABLE IF NOT EXISTS
request_status (
  request_status_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  request_status_value VARCHAR(20)
);


---DELIMITER---

-- now we put our enums into the request_status table.
-- these are intentionally in all-caps to emphasize they are not
-- supposed to go straight to the client.  They must be localized first.
INSERT INTO request_status (request_status_value)
VALUES('OPEN'),('CLOSED'),('TAKEN');

---DELIMITER---

-- create_request_table

CREATE TABLE IF NOT EXISTS 
request ( 
  request_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  datetime DATETIME,
  description NVARCHAR(10000),
  points INT UNSIGNED,
  status INT,
  title NVARCHAR(255),
  requesting_user_id INT NOT NULL,
  FOREIGN KEY FK_requesting_user_user_id (requesting_user_id) 
    REFERENCES user (user_id) 
    ON DELETE CASCADE,
  FOREIGN KEY FK_status_request_status_id (status)
    REFERENCES request_status (request_status_id)
    ON DELETE CASCADE
);


---DELIMITER---

-- create a trigger to cause an error condition if someone tries
-- inserting a request with a user who does not have enough points
-- to make the request.

CREATE TRIGGER trg_error_if_user_lacks_points_for_rqst 
BEFORE INSERT ON request
FOR EACH ROW
BEGIN
    DECLARE msg VARCHAR(255);
    SET @user_points := 
      (
        SELECT points 
        FROM user 
        WHERE NEW.requesting_user_id = user.user_id
      );
    
    IF (@user_points < NEW.points) THEN
        SET msg = CONCAT('user lacks points to make this request: ', 
          NEW.requesting_user_id );
        signal sqlstate '45001' set message_text = msg;
    END IF;

END


---DELIMITER---


-- create a table of known languages

CREATE TABLE IF NOT EXISTS 
languages ( 
  language_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  language_name NVARCHAR(30)
)

---DELIMITER---
-- add to a table of known languages

INSERT INTO languages (language_name)
VALUES('English'),('French'),('Spanish')

---DELIMITER---
-- create a lookup table for words and 
-- phrases to their localized counterparts, e.g. French, English, etc.

CREATE TABLE IF NOT EXISTS 
localization_lookup ( 
  local_id INT NOT NULL PRIMARY KEY,
  English NVARCHAR(1000),
  French NVARCHAR(1000),
  Spanish NVARCHAR(1000)
)

---DELIMITER---
-- create the tables to store categories and assign them to requests.

CREATE TABLE IF NOT EXISTS 
request_category ( 
  category_id INT NOT NULL PRIMARY KEY, -- a localization value
  request_category_value VARCHAR(20)
)

---DELIMITER---
-- now we put our enums into the request_category table.
-- these are intentionally in all-caps to emphasize they are not
-- supposed to go straight to the client.  They must be localized first.
-- this should be easy to expand later.

INSERT INTO request_category (category_id, request_category_value)
VALUES
(71, 'MATH'),
(72,'PHYSICS'),
(73,'ECONOMICS'),
(74,'HISTORY'),
(75,'ENGLISH');

---DELIMITER---
-- here, we set up a table to correlate categories to a given
-- request.

CREATE TABLE IF NOT EXISTS 
request_to_category ( 
  request_id INT NOT NULL,
  request_category_id INT NOT NULL,
  FOREIGN KEY FK_request_id (request_id) 
    REFERENCES request (request_id) 
    ON DELETE CASCADE,
  FOREIGN KEY 
    FK_request_category_id (request_category_id)
    REFERENCES request_category (category_id)
    ON DELETE CASCADE
)

---DELIMITER---
-- create a table of meesages for requests

CREATE TABLE IF NOT EXISTS 
request_message ( 
  request_id INT NOT NULL,
  message NVARCHAR(10000),
  timestamp datetime,
  user_id INT NOT NULL,
  FOREIGN KEY FK_request_id (request_id)
  REFERENCES request (request_id)
  ON DELETE CASCADE,
  FOREIGN KEY FK_user_id (user_id)
  REFERENCES user (user_id)
  ON DELETE CASCADE
)



---DELIMITER---

-- create some audit actions.  these are the things we are going to 
-- track the users doing.

CREATE TABLE IF NOT EXISTS
audit_actions (
  action_id INT NOT NULL PRIMARY KEY,
  action VARCHAR(255)
)

---DELIMITER---

INSERT INTO audit_actions (action_id,action)
VALUES
(1,'User created a request'),
(2,'User deleted a request'),
(3,'User handled a request')


---DELIMITER---

-- the audit table will store the various actions taken by users.  
-- for example,
-- if a user deletes a request, then a row will be added here with
-- that user's id, the request's id as "target_id", and the
-- id of the action that took place, with a timestamp.

-- there is no purpose to having an id that I can think, so I'll just
-- set this to be keyed by timestamp.

-- Given that this is just the timestamp plus 3 ints, the total size
-- should be tiny.

CREATE TABLE IF NOT EXISTS
audit (
  datetime DATETIME NOT NULL,
  audit_action_id TINYINT UNSIGNED NOT NULL,
  user_id INT, 
  target_id INT, -- this is the thing manipulated, e.g. the request.
  notes NVARCHAR(50) -- we'll store some relevant info here
)
