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
    user_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    username NVARCHAR(50) UNIQUE,
    email NVARCHAR(200) UNIQUE, 
    password VARCHAR(64),
    points INT UNSIGNED DEFAULT 100, 
    language INT UNSIGNED NULL DEFAULT 1, -- 1 is English.
    is_logged_in BOOL, 
    date_created DATETIME,
    salt VARCHAR(50), -- used when hashing password
    last_time_logged_in DATETIME,
    last_activity_time DATETIME,
    timeout_seconds INT NOT NULL DEFAULT 1800, -- 30 minutes in seconds
    last_ip_logged_in VARCHAR(40),
    rank INT UNSIGNED NOT NULL DEFAULT 50, -- how they are ranked (like, in stars)
    is_admin BOOL NOT NULL DEFAULT FALSE
  );

---DELIMITER---

-- create the system user and admin users
INSERT INTO user (username, email, password, language, rank, is_admin)
VALUES 
('xenos_system',NULL,NULL,1,100, true),
('admin_bk','byron@renomad.com','password',1,100, true),
('admin_ds','dan@renomad.com','password',1,100, true)


---DELIMITER---

-- this guy is an enum only.  Don't expect to put this value
-- directly into the output.  Rather, we use the number to determine
-- which localized value to get.  That is, it will make it easier for
-- use when we need to translate languages.

CREATE TABLE IF NOT EXISTS
request_status (
  request_status_id INT NOT NULL PRIMARY KEY, -- this value maps to localization values
  request_status_value VARCHAR(20)
);


---DELIMITER---

-- now we put our enums into the request_status table.
-- these are intentionally in all-caps to emphasize they are not
-- supposed to go straight to the client.  They must be localized first.
INSERT INTO request_status (request_status_id, request_status_value)
VALUES(76,'OPEN'),(77,'CLOSED'),(78,'TAKEN');

---DELIMITER---

-- create_request_table

CREATE TABLE IF NOT EXISTS 
request ( 
  request_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  datetime DATETIME,
  description NVARCHAR(10000),
  points INT UNSIGNED,
  status INT,
  title NVARCHAR(255),
  requesting_user_id INT UNSIGNED NOT NULL,
  handling_user_id INT UNSIGNED,
  FOREIGN KEY FK_requesting_user_user_id (requesting_user_id) 
    REFERENCES user (user_id) 
    ON DELETE CASCADE,
  FOREIGN KEY FK_status_request_status_id (status)
    REFERENCES request_status (request_status_id)
    ON DELETE CASCADE
);


---DELIMITER---


-- create a table of known languages

CREATE TABLE IF NOT EXISTS 
languages ( 
  language_id INT NOT NULL PRIMARY KEY,
  language_name NVARCHAR(30),
  locale_id VARCHAR(8) -- this is the character identifier for a language, like 'en-us'
)

---DELIMITER---
-- add to a table of known languages

INSERT INTO languages (language_id, language_name, locale_id)
VALUES
(1,'English', 'en'),
(2,'French',  'fr'),
(3,'Spanish', 'es'),
(4,'Chinese', 'zh'),
(5,'Hebrew',  'he')

---DELIMITER---
-- create a lookup table for words and 
-- phrases to their localized counterparts, e.g. French, English, etc.

CREATE TABLE IF NOT EXISTS 
localization_lookup ( 
  local_id INT,
  language INT, 
  text NVARCHAR(1000),
  PRIMARY KEY (local_id, language)
)

---DELIMITER---
-- create the tables to store categories and assign them to requests.

CREATE TABLE IF NOT EXISTS 
request_category ( 
  category_id INT UNSIGNED NOT NULL PRIMARY KEY, -- a localization value
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
  request_id INT UNSIGNED NOT NULL,
  request_category_id INT UNSIGNED NOT NULL,
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
  request_id INT UNSIGNED NOT NULL,
  message NVARCHAR(10000),
  timestamp datetime,
  user_id INT UNSIGNED NOT NULL,
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
  action_id INT UNSIGNED NOT NULL PRIMARY KEY,
  action VARCHAR(255)
)

---DELIMITER---

INSERT INTO audit_actions (action_id,action)
VALUES
(1,'User created a request'),
(2,'User deleted a request'),
(3,'User handled a request'),
(4,'New user was registered'),
(5,'cookie authentication failed')


---DELIMITER---

-- This table will store notes about some audits when that is
-- necessary.  Like for example, when we delete requests, they are
-- actually deleted from the database, permanently.  So we can store
-- some data about them here just before we delete them, for posterity.

CREATE TABLE IF NOT EXISTS
audit_notes (
  notes_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  notes NVARCHAR(100)
)

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
  audit_action_id INT UNSIGNED NOT NULL, -- an enum of actions
  user_id INT UNSIGNED ,  -- the user who caused the action
  target_id INT UNSIGNED, -- this is the thing manipulated, e.g. the request.
  notes_id INT UNSIGNED -- some notes about the action, see audit_notes
)


