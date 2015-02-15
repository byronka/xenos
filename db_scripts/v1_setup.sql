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

INSERT INTO config (config_item, config_value)
VALUES ('cookie_passphrase', UUID());


---DELIMITER---

-- create the user table

CREATE TABLE  
  user (
    user_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    username NVARCHAR(50) UNIQUE,
    email NVARCHAR(200) UNIQUE, 
    password VARCHAR(64),
    points INT NOT NULL DEFAULT 0,
    language INT UNSIGNED NULL, 
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

CREATE TABLE 
requestoffer_status (
  requestoffer_status_id INT NOT NULL PRIMARY KEY, -- this value maps to localization values
  requestoffer_status_value VARCHAR(20)
);


---DELIMITER---

-- now we put our enums into the requestoffer_status table.
-- these are intentionally in all-caps to emphasize they are not
-- supposed to go straight to the client.  They must be localized first.
INSERT INTO requestoffer_status (requestoffer_status_id, requestoffer_status_value)
VALUES(76,'OPEN'),(77,'CLOSED'),(78,'TAKEN'),(109,'DRAFT');

---DELIMITER---

-- create_requestoffer_table

CREATE TABLE  
requestoffer ( 
  requestoffer_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  datetime DATETIME,
  description NVARCHAR(200),
  points INT UNSIGNED,
  status INT,
  requestoffering_user_id INT UNSIGNED NOT NULL,
  handling_user_id INT UNSIGNED,
  is_satisfied BOOL,
  FOREIGN KEY FK_requestoffering_user_user_id (requestoffering_user_id) 
    REFERENCES user (user_id) 
    ON DELETE CASCADE,
  FOREIGN KEY FK_status_requestoffer_status_id (status)
    REFERENCES requestoffer_status (requestoffer_status_id)
    ON DELETE CASCADE
);


---DELIMITER---

CREATE TABLE  
requestoffer_service_request_status ( 
  status_id INT UNSIGNED NOT NULL PRIMARY KEY,
  description VARCHAR(20)
)

---DELIMITER---

INSERT INTO requestoffer_service_request_status 
(status_id, description)
VALUES 
(106, 'new'), -- these id's are based on their localization values
(107, 'accepted'), -- see v1_language_data.sql
(108, 'rejected') -- this will make it easier to get their localized values

---DELIMITER---

-- a table that stores data about users wanting to service a particular
-- requestoffer.  When they offer to handle one, it goes into this table.
-- It is expected that the data here is constantly in flux.

CREATE TABLE  
requestoffer_service_request ( 
  requestoffer_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  date_created DATETIME, -- when a user made the offer to handle
  date_modified DATETIME, -- when the user takes an action on it
  status INT,
  PRIMARY KEY (requestoffer_id, user_id),
  FOREIGN KEY FK_requestoffer_id (requestoffer_id)
  REFERENCES requestoffer (requestoffer_id)
  ON DELETE CASCADE,
  FOREIGN KEY FK_user_id (user_id)
  REFERENCES user (user_id)
  ON DELETE CASCADE
)

---DELIMITER---


-- create a table of known languages

CREATE TABLE  
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

CREATE TABLE  
localization_lookup ( 
  local_id INT,
  language INT, 
  text NVARCHAR(1000),
  PRIMARY KEY (local_id, language)
)

---DELIMITER---
-- create the tables to store categories and assign them to requestoffers.

CREATE TABLE  
requestoffer_category ( 
  category_id INT UNSIGNED NOT NULL PRIMARY KEY, -- a localization value
  requestoffer_category_value VARCHAR(20)
)

---DELIMITER---
-- now we put our enums into the requestoffer_category table.
-- these are intentionally in all-caps to emphasize they are not
-- supposed to go straight to the client.  They must be localized first.
-- this should be easy to expand later.

INSERT INTO requestoffer_category (category_id, requestoffer_category_value)
VALUES
(71, 'MATH'),
(72,'PHYSICS'),
(73,'ECONOMICS'),
(74,'HISTORY'),
(75,'ENGLISH');

---DELIMITER---
-- here, we set up a table to correlate categories to a given
-- requestoffer.

CREATE TABLE  
requestoffer_to_category ( 
  requestoffer_id INT UNSIGNED NOT NULL,
  requestoffer_category_id INT UNSIGNED NOT NULL,
  FOREIGN KEY FK_requestoffer_id (requestoffer_id) 
    REFERENCES requestoffer (requestoffer_id) 
    ON DELETE CASCADE,
  FOREIGN KEY 
    FK_requestoffer_category_id (requestoffer_category_id)
    REFERENCES requestoffer_category (category_id)
    ON DELETE CASCADE
)

---DELIMITER---
-- create a table of meesages for requestoffers

CREATE TABLE  
requestoffer_message ( 
  requestoffer_id INT UNSIGNED NOT NULL,
  message NVARCHAR(200),
  timestamp datetime,
  from_user_id INT UNSIGNED NOT NULL, -- person sending the message
  to_user_id INT UNSIGNED NOT NULL,   -- person receiving the message
  FOREIGN KEY FK_requestoffer_id (requestoffer_id)
  REFERENCES requestoffer (requestoffer_id)
  ON DELETE CASCADE,
  FOREIGN KEY FK_from_user_id (from_user_id)
  REFERENCES user (user_id)
  ON DELETE CASCADE,
  FOREIGN KEY FK_to_user_id (to_user_id)
  REFERENCES user (user_id)
  ON DELETE CASCADE
)



---DELIMITER---

-- create some audit actions.  these are the things we are going to 
-- track the users doing.

CREATE TABLE 
audit_actions (
  action_id INT UNSIGNED NOT NULL PRIMARY KEY,
  action VARCHAR(255)
)

---DELIMITER---

INSERT INTO audit_actions (action_id,action)
VALUES
(1,'User created a requestoffer'),
(2,'User deleted a requestoffer'),
(3,'User handled a requestoffer'),
(4,'New user was registered'),
(5,'cookie authentication failed'),
(6,'user closed their own requestoffer - satisfied'),
(7,'user offered to take requestoffer'),
(8,'location was deleted, since there were no related users or requestoffers'),
(9,'user published a requestoffer (set its status to OPEN)'),
(10,'user closed their own requestoffer - unsatisfied'),
(11,'user received a favor point from completing requestoffer'),
(12,'user lost a favor point from creating a requestoffer')


---DELIMITER---

-- This table will store notes about some audits when that is
-- necessary.  Like for example, when we delete requestoffers, they are
-- actually deleted from the database, permanently.  So we can store
-- some data about them here just before we delete them, for posterity.

CREATE TABLE 
audit_notes (
  notes_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  notes NVARCHAR(100)
)

---DELIMITER---

-- the audit table will store the various actions taken by users.  
-- for example,
-- if a user deletes a requestoffer, then a row will be added here with
-- that user's id, the requestoffer's id as "target_id", and the
-- id of the action that took place, with a timestamp.

-- there is no purpose to having an id that I can think, so I'll just
-- set this to be keyed by timestamp.

-- Given that this is just the timestamp plus 3 ints, the total size
-- should be tiny.
   
CREATE TABLE 
audit (
  datetime DATETIME NOT NULL,
  audit_action_id INT UNSIGNED NOT NULL, -- an enum of actions
  user_id INT UNSIGNED ,  -- the user who caused the action
  target_id INT UNSIGNED, -- this is the thing manipulated, e.g. the requestoffer.
  notes_id INT UNSIGNED -- some notes about the action, see audit_notes
)


---DELIMITER---

-- creates a table to store locations, which we can use for searching and mapping
CREATE TABLE
location (
  location_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  address_line_1 NVARCHAR(255),
  address_line_2 NVARCHAR(255),
  city NVARCHAR(255),
  state NVARCHAR(255),
  country NVARCHAR(255),
  postal_code VARCHAR(30) -- most important value - see http://en.wikipedia.org/wiki/Postal_code for more info!
)

---DELIMITER---

-- here we create two correlation tables, from location to user and location to requestoffer.
-- locations can be tied to a user if the user says, "remember this location", and tied to a
-- requestoffer if that location is used in that requestoffer.
-- there should be an event running that checks for locations that are not tied to 
-- either a user or requestoffer and purges them, and audits the purge.

CREATE TABLE
location_to_user (
  location_id INT UNSIGNED, 
  user_id INT UNSIGNED, 
  FOREIGN KEY FK_user (user_id)
  REFERENCES user (user_id)
  ON DELETE CASCADE,
  FOREIGN KEY FK_location (location_id)
  REFERENCES location (location_id)
  ON DELETE CASCADE
)

---DELIMITER---

CREATE TABLE
location_to_requestoffer (
  location_id INT UNSIGNED,
  requestoffer_id INT UNSIGNED,
  FOREIGN KEY FK_requestoffer (requestoffer_id)
  REFERENCES requestoffer (requestoffer_id)
  ON DELETE CASCADE,
  FOREIGN KEY FK_location (location_id)
  REFERENCES location (location_id)
  ON DELETE CASCADE
)
