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


---DELIMITER---

-- a procedure we will call to add the audit, to keep things tidy
-- in the code.  We are adding to two tables at once, possibly (notes
-- and audit) so to avoid having complexity in the java, we'll just
-- call the stored procedure.

CREATE PROCEDURE add_audit
(
  my_audit_action_id INT UNSIGNED, 
  my_user_id INT UNSIGNED, 
  my_target_id INT UNSIGNED, 
  my_notes NVARCHAR(100)
) 
BEGIN 
  DECLARE the_audit_notes_id INT UNSIGNED;

  CASE
    WHEN my_notes = "" 
			OR my_notes is NULL -- if we get an empty string, don't add to notes
  THEN 
    INSERT INTO audit (
      datetime, audit_action_id, user_id, target_id)
      VALUES(
        UTC_TIMESTAMP(), 
        my_audit_action_id, 
        my_user_id, 
        my_target_id);
  ELSE
    INSERT INTO audit_notes (notes) VALUES(my_notes);
    SET the_audit_notes_id = LAST_INSERT_ID();
    INSERT INTO audit (
      datetime, audit_action_id, user_id, target_id, notes_id)
      VALUES(
        UTC_TIMESTAMP(),     -- the current time and date
        my_audit_action_id,  -- the action, e.g. create, delete, etc.
        my_user_id,          -- the user causing the action
        my_target_id,        -- the thing being acted upon
        the_audit_notes_id); -- notes about the action ,like during delete
  END CASE;

END


---DELIMITER---

CREATE PROCEDURE get_others_requests
(
  ruid INT UNSIGNED,
	title NVARCHAR(255),
  startdate VARCHAR(10),
  enddate VARCHAR(10),
  status VARCHAR(50), -- can be many INT's separated by commas
  categories VARCHAR(50),
  minpoints INT UNSIGNED,
  maxpoints INT UNSIGNED,
  user_id VARCHAR(50), -- can be many INT's separated by commas
  page INT UNSIGNED
) 
BEGIN 
	SET @search_clauses = ""; -- all our search clauses go on this.
         
  -- searching by points
  IF minpoints > 0 AND maxpoints > 0 THEN
    SET @minpoints = minpoints;
    SET @maxpoints = maxpoints;
    SET @search_clauses = 
      CONCAT(@search_clauses, 
        ' AND @minpoints <= r.points AND r.points <= @maxpoints ');
  ELSEIF minpoints > 0 THEN
    SET @minpoints = minpoints;
    SET @search_clauses = 
      CONCAT(@search_clauses, ' AND @minpoints <= r.points ');
  ELSEIF maxpoints > 0 THEN
    SET @maxpoints = maxpoints;
    SET @search_clauses = 
      CONCAT(@search_clauses, ' AND @maxpoints >= r.points ');
  END IF;

  -- searching by status
  IF status <> '' THEN
    SET @search_clauses = 
      CONCAT(@search_clauses, ' AND status IN (',status,') ');
  END IF;

  -- searching by categories
  IF categories <> '' THEN
    SET @search_clauses = 
      CONCAT(@search_clauses, ' AND rc.category_id IN (',categories,') ');
  END IF;

  -- searching by requesting user
  IF user_id <> '' THEN
    SET @search_clauses = 
			CONCAT(@search_clauses, 
				' AND requesting_user_id IN (', user_id ,')');
  END IF;
  
  -- searching by dates
  IF startdate <> '' AND enddate <> '' THEN
    SET @startdate = startdate;
    SET @enddate = enddate;
    SET @search_clauses = 
      CONCAT(@search_clauses, 
        ' AND datetime >= @startdate AND datetime <= @enddate ');
  ELSEIF startdate <> '' THEN
    SET @startdate = startdate;
    SET @search_clauses = 
      CONCAT(@search_clauses, ' AND datetime >= @startdate ');
  ELSEIF enddate <> '' THEN
    SET @enddate = enddate;
    SET @search_clauses = CONCAT(@search_clauses, 
      ' AND datetime <= @enddate ');
  END IF;

  -- searching by title
	IF title <> '' THEN
		SET @title = title;
		SET @search_clauses = 
    CONCAT(@search_clauses, " AND title LIKE CONCAT('%' , @title , '%') ");
	END IF;

  -- set up paging.  Right now it's always 10 or less rows on the page.
  SET @first_row = page * 10;
  SET @last_row = (page * 10) + 10;

  -- the prime request
  SET @ruid = ruid;
  SET @get_request = 
     CONCAT('SELECT r.request_id, 
            r.datetime, 
            r.description, 
            r.status, 
            r.points, 
            r.title, 
            u.rank, 
            r.requesting_user_id, 
            GROUP_CONCAT(rc.category_id SEPARATOR ",") 
            AS categories 
            FROM request r 
            JOIN request_to_category rtc ON rtc.request_id = r.request_id 
            JOIN request_category rc 
              ON rc.category_id = rtc.request_category_id 
            JOIN user u ON u.user_id = r.requesting_user_id 
            WHERE requesting_user_id <> @ruid
            ', @search_clauses ,'
            GROUP BY r.request_id 
            ORDER BY r.request_id ASC
            LIMIT ',@first_row,',',@last_row );


  -- prepare and execute!
	PREPARE get_request FROM @get_request;
	EXECUTE get_request; 
END

---DELIMITER---

CREATE PROCEDURE put_request
(
  my_desc NVARCHAR(10000),
  ruid INT UNSIGNED, -- requesting user id
	ti NVARCHAR(255), -- title
  pts INT UNSIGNED, -- points
  cats VARCHAR(50), -- categories
  OUT new_request_id INT UNSIGNED
) 
BEGIN 
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
  BEGIN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' 
    SET message_text = 'general error while creating request.';
  END;

  START TRANSACTION;

  -- Check that the user has the points.
  SELECT points INTO @user_points
  FROM user 
  WHERE user_id = ruid;
  
  IF (@user_points < @points) THEN
      SET @msg = CONCAT('user lacks points to make this request: ', 
        ruid );
      ROLLBACK;
      SIGNAL SQLSTATE '45001' set message_text = msg;
  END IF;

  -- Prepare a handler in case there is a SQLException, 
  -- we want to roll back.

  -- A) The main part - add the request to that table.
  SET @status = 76; -- requests always start 'open'
  INSERT into request (description, datetime, points,
   status, title, requesting_user_id)
   VALUES (my_desc, UTC_TIMESTAMP(), pts, @status, ti, ruid); 
         
  SET new_request_id = LAST_INSERT_ID();


  -- B) Add categories.
  CREATE TEMPORARY TABLE CAT_IDS (id INT);
  SELECT CONCAT(
    'INSERT INTO CAT_IDS (id) VALUES ',cats) INTO @cat_sql;

  PREPARE cat_sql FROM @cat_sql;
  EXECUTE cat_sql;

  INSERT INTO request_to_category (request_id, request_category_id)
  SELECT new_request_id, id FROM CAT_IDS;
  DROP TABLE CAT_IDS;

  -- C) Deduct points from the user
  UPDATE user SET points = points - pts WHERE user_id = ruid;


  -- D) Add an audit
  CALL add_audit(1,ruid,new_request_id,'');

  COMMIT;
END

---DELIMITER---

CREATE PROCEDURE put_message
(
  my_message NVARCHAR(10000),
  uid INT UNSIGNED,
  rid INT UNSIGNED
) 
BEGIN 
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' 
    SET message_text = 'general error while adding message.';
  END;

  START TRANSACTION;

  -- A) The main part - add the request to that table.

  INSERT into request_message (message, request_id, user_id, timestamp)
  SELECT 
  CONCAT(username,' says:', @message), 
  rid, 
  uid, 
  UTC_TIMESTAMP()
  FROM user WHERE user_id = uid;
 
  COMMIT;
END

---DELIMITER---

CREATE PROCEDURE take_request
(
  uid INT UNSIGNED,
  rid INT UNSIGNED
) 
BEGIN 
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' 
    SET message_text = 'general error while taking a request.';
  END;
  START TRANSACTION;

  -- first check that they are trying to 
  -- take something that exists
  SELECT COUNT(*) INTO @valid_id 
  FROM request 
  WHERE request_id = rid;

  IF (@valid_id <> 1) THEN
      SET @msg = CONCAT('request does not exist in the system: ', 
        rid);
      ROLLBACK;
      SIGNAL SQLSTATE '45002' 
      SET message_text = @msg;
  END IF;

  -- actually change the status of the request here.
  UPDATE request 
  SET 
    status = 78, 
    handling_user_id = uid  
  WHERE request_id = rid;

  -- Add an audit
  CALL add_audit(3,uid,rid,NULL);

  COMMIT;

END

---DELIMITER---

CREATE PROCEDURE delete_request
(
  uid INT UNSIGNED,
  rid INT UNSIGNED
) 
BEGIN 
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' 
    SET message_text = 'general error while deleting a request.';
  END;

  START TRANSACTION;

  -- first check that they are trying to 
  -- delete something that exists
  SELECT COUNT(*) INTO @valid_id 
  FROM request 
  WHERE request_id = rid;

  IF (@valid_id <> 1) THEN
      SET @msg = CONCAT('request does not exist in the system: ', 
        rid);
      ROLLBACK;
      SIGNAL SQLSTATE '45002' 
      SET message_text = @msg;
  END IF;

  -- get the points on this request.


  SELECT points into @points
  FROM request 
  WHERE request_id = rid;

  -- get a string version of the status
  SELECT request_status_value INTO @status
  FROM request_status 
  WHERE request_status_id = 
    (
      SELECT status
      FROM request 
      WHERE request_id = rid
    );

  -- get a message for the deletion audit
  SELECT CONCAT(
      SUBSTR(description,1,30),
      '|',
      SUBSTR(title,1,20),
      '|',
      'created:', SUBSTR(datetime,1,10),
      '|',
      'pts:', points,
      '|',
      'st:',@status) INTO @delete_msg
    FROM request
    WHERE request_id = rid;


  -- actually delete the request here.
  DELETE FROM request WHERE request_id = rid;

  -- give points back to the user
  UPDATE user 
  SET points = points + @points 
  WHERE user_id = uid;

  -- Add an audit
  CALL add_audit(2,uid,rid,@delete_msg);

  COMMIT;

END

---DELIMITER---

CREATE PROCEDURE create_new_user
(
  uname NVARCHAR(50),
  pword VARCHAR(64),
  slt VARCHAR(50)
) 
BEGIN 
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' 
    SET message_text = 'general error while creating a new user.';
  END;

  START TRANSACTION;

  -- check that this username doesn't match an email in the system
  SELECT COUNT(*) INTO @count_email_username
  FROM user 
  WHERE uname = user.email;
    
  IF (@count_email_username > 0) THEN
      SET @msg = CONCAT(
				'username matches existing email during insert: ', uname );
      ROLLBACK;
      SIGNAL SQLSTATE '45000' 
      SET message_text = @msg;
  END IF;


  -- add the user
  INSERT INTO user (username, password, salt, date_created)
  VALUES (uname, pword, slt, UTC_TIMESTAMP());

  SET @new_user_id = LAST_INSERT_ID();


  -- Add an audit
  CALL add_audit(4,@new_user_id,NULL,NULL);

  COMMIT;

END
---DELIMITER---

CREATE PROCEDURE register_user_and_get_cookie
(
  uid INT UNSIGNED,
  ip VARCHAR(15), -- e.g. "255.255.255.255"
  p_phrase VARCHAR(50), -- used to encrypt the cookie_plaintext
  OUT new_cookie VARCHAR(200)
) 
BEGIN 
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' 
    set message_text = 'general error while registering a user.';
  END;

  START TRANSACTION;

  SELECT UTC_TIMESTAMP() INTO @timestamp;

  -- set registration values
  UPDATE user
  SET is_logged_in = 1, last_time_logged_in = @timestamp,
  last_ip_logged_in = ip
  WHERE user_id = uid;

  -- takes the user id, the ip, and a timestamp and encrypts
  -- that into a string value which we will use as the cookie.
  -- the value to encrypt will look like this:
  -- USER_ID|IP|TIMESTAMP
  -- for example:
  -- "123|108.91.12.198|2014-01-02 13:04:19"
  -- Notice the delimiter is a pipe symbol.
  SELECT CONCAT(uid,'|',ip,'|',@timestamp) 
    INTO @cookie_val_plaintext;

  SELECT HEX(
    AES_ENCRYPT(
      @cookie_val_plaintext, SHA2(p_phrase,512))) INTO new_cookie;

  COMMIT;

END
---DELIMITER---

CREATE PROCEDURE decrypt_cookie_and_check_validity
(
  enc_cookie VARCHAR(200), -- The cookie encrypted
  p_phrase VARCHAR(50),
  OUT user_id_out INT
) 
BEGIN 
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    SIGNAL SQLSTATE '45000' 
    set message_text = 'general error while validating cookie.';
  END;

  -- See register_user_and_get_cookie for more info on cookie format
  SELECT 
    AES_DECRYPT(UNHEX(enc_cookie), SHA2(p_phrase,512)) 
    INTO @plaintext_cookie;

  SELECT SUBSTRING_INDEX(@plaintext_cookie, '|',1) INTO @my_user_id;
  SELECT LENGTH(
    SUBSTRING_INDEX(@plaintext_cookie, '|',1)) INTO @user_id_length;
  SELECT SUBSTR(
    SUBSTRING_INDEX(
      @plaintext_cookie, '|',2),@user_id_length+2) INTO @ip_address;
  SELECT SUBSTRING_INDEX(@plaintext_cookie, '|',-1) INTO @timestamp;
  
  SELECT COUNT(*) INTO @found_users
  FROM user
  WHERE 
    is_logged_in = 1 
    AND last_time_logged_in = @timestamp
    AND user_id = @my_user_id
    AND last_ip_logged_in = @ip_address;

  IF (@found_users <> 1) THEN
    SET @msg = CONCAT(IFNULL(@found_users,-1), ' users found. user_id: '
      , IFNULL(@user_id , -1)
      ,' ip_address: ',IFNULL(@ip_address, '')
      ,' timestamp: ',IFNULL(@timestamp, ''));
    CALL add_audit(5,@user_id,NULL,@msg);
    SET user_id_out = -1;
  ELSE
    SET user_id_out = @my_user_id;
  END IF;
 
END
