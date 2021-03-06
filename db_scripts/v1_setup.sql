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
    points INT NOT NULL DEFAULT 0, -- legal tender of our system
    language INT UNSIGNED NULL,  -- let them choose their language 
    is_logged_in BOOL,  -- when they log in.  event exists to clear this.
    date_created DATETIME,
    salt VARCHAR(50), -- used when hashing password
    last_time_logged_in DATETIME,
    last_activity_time DATETIME,
    timeout_seconds INT NOT NULL DEFAULT 604800, -- 7*24*60*60 - a week in seconds
    last_ip_logged_in VARCHAR(40),
    rank_average FLOAT, -- average # good rankings in last 6 months
    rank_ladder INT NOT NULL DEFAULT 0, -- represents most recent activity
    is_admin BOOL NOT NULL DEFAULT FALSE,
    inviter INT UNSIGNED, -- the user who invited this user into the system
    country_id INT UNSIGNED,
    postal_code_id INT UNSIGNED -- useful for when they want to see distances to each requestoffer
  );

---DELIMITER---

CREATE TABLE
  user_description (
    user_id INT UNSIGNED NOT NULL,
    text NVARCHAR(500),
    FOREIGN KEY FK_user_description_user_id (user_id) 
      REFERENCES user (user_id)
  );

---DELIMITER---


-- create the system user and admin users
INSERT INTO user (username, email, password, salt, language, rank_average, is_admin)
VALUES 
('xenos_system',NULL,NULL,NULL,1,1.0, true),
('byron','byron@renomad.com','AC31960F3FD5CBFCA9A76B6082D276D4BE65AED73C11150E5FC5891257C7F0AC','3181459404718211989', 1,1.0, true)


---DELIMITER---

-- this guy is an enum only.  Don't expect to put this value
-- directly into the output.  Rather, we use the number to determine
-- which localized value to get.  That is, it will make it easier for
-- use when we need to translate languages.

CREATE TABLE 
requestoffer_status (
  requestoffer_status_id INT UNSIGNED NOT NULL PRIMARY KEY, -- this value maps to localization values
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
  datetime DATETIME,  -- when this requestoffer was created
  description NVARCHAR(200),
  points INT,
  requestoffering_user_id INT UNSIGNED NOT NULL,
  handling_user_id INT UNSIGNED,
  category INT UNSIGNED,
  country_id INT,
  postal_code_id INT,
  FOREIGN KEY FK_requestoffering_user_user_id (requestoffering_user_id) 
    REFERENCES user (user_id) 
);


---DELIMITER---

-- a separate table to track the status of a requestoffer
-- so we can store a date associated with the last change of status.

CREATE TABLE
requestoffer_state (
  requestoffer_id INT UNSIGNED NOT NULL PRIMARY KEY,
  status INT UNSIGNED NOT NULL,
  datetime DATETIME,
  FOREIGN KEY FK_requestoffer_id_rs (requestoffer_id)
    REFERENCES requestoffer (requestoffer_id)
    ON DELETE CASCADE,
  FOREIGN KEY FK_status_rs (status)
    REFERENCES requestoffer_status (requestoffer_status_id)
)

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

-- Once a rsr goes to status 107 or 108, it's not moving any more.

CREATE TABLE  
requestoffer_service_request ( 
  service_request_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  requestoffer_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL, -- the user making an offer
  date_created DATETIME, -- when a user made the offer to handle
  date_modified DATETIME, -- when the user takes an action on it
  status INT,
  FOREIGN KEY FK_requestoffer_id_rsr (requestoffer_id)
  REFERENCES requestoffer (requestoffer_id)
  ON DELETE CASCADE,
  FOREIGN KEY FK_user_id_rsr (user_id)
  REFERENCES user (user_id)
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
(143,'BABYSITTING'),
(144,'DOG-WALKING'),
(145,'TAXI'),
(199,'MISCELLANY'),
(200,'HOMEWORK');

---DELIMITER---
-- create a table of meesages for requestoffers
-- it is expected that these be written by users, to other users.
-- messages sent by the system will be in table user_message

CREATE TABLE  
requestoffer_message ( 
  requestoffer_id INT UNSIGNED NOT NULL,
  message NVARCHAR(200),
  timestamp datetime,
  from_user_id INT UNSIGNED NOT NULL, -- person sending the message
  to_user_id INT UNSIGNED NOT NULL,   -- person receiving the message
  FOREIGN KEY FK_requestoffer_id_rm (requestoffer_id)
  REFERENCES requestoffer (requestoffer_id)
  ON DELETE CASCADE,
  FOREIGN KEY FK_from_user_id (from_user_id)
  REFERENCES user (user_id),
  FOREIGN KEY FK_to_user_id_rm (to_user_id)
  REFERENCES user (user_id)
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

-- user registration, login, security - 100s

(101,'New user was registered'),
(102,'User logged in'),
(103,'User logged out'),
(104,'Failed login for user'),
(105,'User changed their password'),
(106,'Cookie authentication failed'),
(107,'Failed decrypting cookie'),
(108,'User came in from a different ip'),
(109,'User generated an invite code'),
(110,'User tried an invalid invite code'),
(111,'User edited their description'),

-- requestoffers - 200s

(201,'User1 created a requestoffer'),
(202,'User1 published a requestoffer (set its status to OPEN)'),
(203,'User1 marked their requestoffer complete (user2 is handling user)'),
(204,'User1 marked a requestoffer canceled (user2 is other user)'),
(205,'User1 deleted a requestoffer'),
(206,'User1 reverted User2''s requestoffer to draft status'),
(207,'User1 accepted user2''s offer to handle a requestoffer'),
(208,'User1 rejected user2''s offer to handle a requestoffer'),
(209,'User1 offered to take user2''s requestoffer'),
(210,'User1 removed User2 from a requestoffer by a cancel action'),
(211,'Rejecting user2''s offer to handle requestoffer due to revert of requestoffer'),

-- rank and points - 300s

(301,'System took a point from user2 for publishing a requestoffer'),
(302,'User1 gave user2 a point'),
(303,'System returned a point to user2 for reverting a requestoffer to draft'),
(304,'User1 raised user2''s rank (extra_id is the urdp_id)'),
(305,'User1 lowered user2''s rank (extra_id is the urdp_id)'),
(306,'User1 is going into ACTIVE on user_rank_data_point (extra_id is urdp_id)'),
(307,'User1 is going into COMPLETE_FEEDBACK_POSSIBLE on user_rank_data_point (extra_id is urdp_id)'),
(308,'User1 is going into COMPLETE on user_rank_data_point (extra_id is urdp_id)'),
(309,'System adjusted rank on a user due to one or more user rank data points going outside 6 month window'),
(310,'System is automatically setting a user rank data point outside of the rolling window'),

-- misc - 400s

(401,'User1 changed location. requestoffer is new country_id, extra is new postal code id'),
(402,'EMPTY402'),
(403,'EMPTY403'),
(404,'EMPTY404'),
(405,'EMPTY405'),
(406,'user1 leaves user2''s group (extra is group id)'),
(407,'user1 creates group (extra is group id)'),
(408,'user1 sends group invite to user2 (extra is group id)'),
(409,'user1 accepts user2''s invite to group (extra is group id)'),
(410,'user1 rejects user2''s invite to group (extra is group id)'),
(411,'user1 edits group name (extra is group id)'),
(412,'user1 edits user group description (extra is group id)'),
(413,'user1 retracts their group invitation to user2 (group is extra)'),
(414,'user1 removed user2 from their grouop (group is extra)'),
(415,'user1 edits their group description (extra is group id)');



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
   
CREATE TABLE 
audit (
  datetime DATETIME NOT NULL,
  audit_action_id INT UNSIGNED NOT NULL, -- an enum of actions
  user1_id INT UNSIGNED ,  -- typically the acting user
  user2_id INT UNSIGNED ,  -- typically the passive / target user
  requestoffer_id INT UNSIGNED, -- the requestoffer, when applicable
  extra_id INT UNSIGNED, -- when referring to something not a requestoffer, e.g. group
  notes_id INT UNSIGNED -- some notes about the action, see audit_notes
)


---DELIMITER---


-- we will encapsulate the states that a servicer may be in

CREATE TABLE
requestoffer_user_statuses (
  state_id INT UNSIGNED NOT NULL PRIMARY KEY,
  state VARCHAR(30)
)

---DELIMITER---

-- by having a state of "feedback possible", we have an explicit time
-- period where we are querying the user for feedback on the other user.
-- once that period is up, it goes into complete and it's no longer
-- possible to enter feedback.

INSERT INTO requestoffer_user_statuses(state_id, state)
VALUES 
(1, 'ACTIVE'), -- <-- we go here when users start servicing a RO
(2, 'COMPLETE_FEEDBACK_POSSIBLE'), -- <-- right after a RO gets completed or canceled
(3, 'COMPLETE') -- <-- no longer possible to leave feedback.

---DELIMITER---

-- This table holds information related to the outcome of a 
-- requestoffer.  Whether it's the owner or handler, it's all
-- the same as far as this table is concerned - it only knows
-- that a particular user was associated with a requestoffer, and 
-- how they were ranked by the other party.

CREATE TABLE
user_rank_data_point (
  urdp_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  date_entered DATETIME,
  judge_user_id INT UNSIGNED, -- the user doing the judging
  judged_user_id INT UNSIGNED, -- the user being judged
  requestoffer_id INT UNSIGNED,
  meritorious BOOL,
  status_id INT UNSIGNED NOT NULL,
  is_inside_window BOOL, -- whether we are inside rolling window (only  matters while status_id is 2 or 3)
  FOREIGN KEY FK_requestoffer_urdp (requestoffer_id)
  REFERENCES requestoffer (requestoffer_id)
  ON DELETE CASCADE,
  FOREIGN KEY FK_user_urdp (judged_user_id)
  REFERENCES user (user_id),
  FOREIGN KEY FK_j_user (judge_user_id)
  REFERENCES user (user_id),
  FOREIGN KEY FK_status_urdp (status_id)
  REFERENCES requestoffer_user_statuses (state_id)
)

---DELIMITER---

CREATE TABLE 
user_rank_data_point_note (
  urdp_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL, -- the user making the comment
  text NVARCHAR(500),
  FOREIGN KEY FK_urdp_note (urdp_id)
  REFERENCES user_rank_data_point (urdp_id),
  FOREIGN KEY FK_urdp_user_id (user_id)
  REFERENCES user (user_id)
)

---DELIMITER---

CREATE TABLE
system_to_user_message_text (
  stu_message_text_id INT UNSIGNED NOT NULL PRIMARY KEY,
  text VARCHAR(1000)
)

---DELIMITER---

INSERT INTO system_to_user_message_text(stu_message_text_id, text)
VALUES
(131,'Your transaction on a favor has been canceled by the other party.  Check out your profile page to enter feedback on that transaction.'),
(132,'Congratulations! You have been awarded the right to service a Favor.  Check your profile for more information.'),
(134,'A Favor which you were handling has been completed.'),
(135,'A Favor which you were owner of has been completed.'),
(136,'You have canceled an active transaction.'),
(147,'You have made an offer to handle a Favor'),
(148,'You have recieved an offer to handle a Favor'),
(222,'You have joined a new group.  It is now listed in your groups page'),
(223,'You have been removed from a group');

---DELIMITER---
-- this table holds messages sent by the system to users.
-- for example, for being selected to handle a requestoffer, or
-- the other person cancelling, anything where we are the mediator
-- and the text has to be localized.

CREATE TABLE  
system_to_user_message ( 
  stu_message_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  requestoffer_id INT UNSIGNED, 
  text_id INT UNSIGNED NOT NULL, -- corresponds to localization ids
  timestamp DATETIME,
  to_user_id INT UNSIGNED NOT NULL,   -- person receiving the message
  has_been_viewed BOOL DEFAULT FALSE, -- if the user has viewed this message
  FOREIGN KEY FK_to_user_id_stum (to_user_id)
  REFERENCES user (user_id),
  FOREIGN KEY FK_message_text (text_id)
  REFERENCES system_to_user_message_text (stu_message_text_id)
)

---DELIMITER---

-- this table will hold messages that are up to 24 hours old for users.
-- that means the table should never get too large, and if we plan
-- to hit it a lot (as we do) there won't be any performance problems
-- from it.

-- This table should have either a message_localization_id or a
-- message_text_id, not both.  One should be set, the other null.
-- otherwise, it's an exceptional situation.

CREATE TABLE  
temporary_message ( 
  message_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  timestamp DATETIME,
  user_id INT UNSIGNED, -- who the message is for
  message_localization_id INT UNSIGNED -- this being not null means the message is system-generated and has a localization lookup
)

---DELIMITER---

-- By creating a separate table to hold string messages, it enables
-- us to continue using integers for a majority of our messages and
-- only use text when it comes from a non-system user, and in that case
-- for us to use the memory for the text only when necessary.  For all
-- the system-generated messages, we'll just pass integers around.

CREATE TABLE
temporary_message_text (
  message_id INT UNSIGNED NOT NULL,
  text NVARCHAR(1000),
  FOREIGN KEY FK_temporary_message (message_id)
  REFERENCES temporary_message (message_id)
  ON DELETE CASCADE
)


---DELIMITER---

-- this table will hold invite codes.  It is expected that the table will
-- never have many values in it at a time, since the codes only last 5 minutes
-- before they expire.

-- invite codes are tied to the user who generated them, and they are 
-- time-based - they only last five minute before getting killed.

CREATE TABLE
invite_code (
    user_id INT UNSIGNED NOT NULL, -- the user who generated the invite code
    timestamp DATETIME, -- when the code was generated
    value VARCHAR(100) -- the text of the code.  a hash of random num + time + user id
)

---DELIMITER---
-- create a lookup table for postal code to lat/long, so it becomes easy to
-- show distance to places

-- some interesting information that should affect us:
-- postal codes have to follow certain rules.  They have to 
-- be from the latin alphabet, so we don't have to worry 
-- about unicode (NVARCHAR) for those guys.  Also,
-- it means we cannot trust them to be digits.  In many places, they
-- include letters.
-- see http://en.wikipedia.org/wiki/Postal_code for more info!

-- postal codes are HUGE tables - eventually, hundreds of megs.  For that
-- reason, for inserting it makes sense to do it this way: multiple tables
-- all keyed off the same id.  

CREATE TABLE  
postal_codes ( 
  postal_code_id INT UNSIGNED NOT NULL,
  country_id INT UNSIGNED NOT NULL,
  postal_code VARCHAR(30),
  PRIMARY KEY (postal_code_id, country_id)
)
---DELIMITER---
CREATE TABLE  
postal_code_latitude ( 
  postal_code_id INT UNSIGNED NOT NULL , 
  country_id INT UNSIGNED NOT NULL,
  latitude DOUBLE,
  PRIMARY KEY (postal_code_id, country_id)
)
---DELIMITER---
CREATE TABLE  
postal_code_longitude ( 
  postal_code_id INT UNSIGNED NOT NULL , 
  country_id INT UNSIGNED NOT NULL,
  longitude DOUBLE,
  PRIMARY KEY (postal_code_id, country_id)
)
---DELIMITER---
CREATE TABLE  
postal_code_details ( 
  postal_code_id INT UNSIGNED NOT NULL , 
  country_id INT UNSIGNED NOT NULL,
  details NVARCHAR(200),
  PRIMARY KEY (postal_code_id, country_id)
)

---DELIMITER---

-- this table holds the groups for the system.  users can create groups
-- and use them to be discriminating in their choice of favor handlers.

CREATE TABLE
user_group (
  group_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  name NVARCHAR(50),
  owner_id INT UNSIGNED,
  FOREIGN KEY FK_owner_user_id (owner_id) 
    REFERENCES user (user_id)
);

---DELIMITER---

-- holds descriptions of groups

CREATE TABLE
group_description (
  group_id INT UNSIGNED NOT NULL,
  text NVARCHAR(500), -- the description
  FOREIGN KEY FK_group_description_id (group_id) 
    REFERENCES user_group (group_id)
);

---DELIMITER---

-- holds descriptions for users as they want the other members of the
-- group to view them.  Only other group members can see this.

CREATE TABLE
user_group_description (
  user_id INT UNSIGNED NOT NULL, -- the user this description applies to
  group_id INT UNSIGNED NOT NULL, -- the group they're a member of
  text NVARCHAR(500), -- the description
  FOREIGN KEY FK_user_group_description_group_id (group_id) 
    REFERENCES user_group (group_id),
  FOREIGN KEY FK_user_group_description (user_id) 
    REFERENCES user (user_id)
);


---DELIMITER---

-- This provides an easy way to map between users and the groups they
-- are members of.
CREATE TABLE
user_to_group (
  user_id INT UNSIGNED,
  group_id INT UNSIGNED,
  PRIMARY KEY (user_id, group_id),
  FOREIGN KEY FK_user_to_group_group_id (group_id) 
    REFERENCES user_group (group_id),
  FOREIGN KEY FK_user_to_group_user_id (user_id) 
    REFERENCES user (user_id)
);

---DELIMITER---

-- this object encapsulates an invite to a user. It's like the 
-- engraved invitation to a user to join a group.
--
-- the user sees the invitation, and as soon as they take an action,
-- like, "accept" or "reject", the invite is deleted

CREATE TABLE
user_group_invite (
  group_id INT UNSIGNED,
  user_id INT UNSIGNED, -- the user we are inviting to the group
  date_created DATETIME,
  FOREIGN KEY FK_group_id_invite (group_id) 
    REFERENCES user_group (group_id),
  FOREIGN KEY FK_user_id_invite (user_id) 
    REFERENCES user (user_id),
  PRIMARY KEY (group_id, user_id) -- there can only be one invite 
                          -- to a user from a given group at any time.
);

---DELIMITER---

CREATE TABLE
country (
  country_id INT UNSIGNED PRIMARY KEY,
  country_name NVARCHAR(100)
)

