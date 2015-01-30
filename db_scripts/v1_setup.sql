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
    password NVARCHAR(50),
    points INT UNSIGNED, -- max-out at 65535 - keep them below that.
    language INT UNSIGNED NULL, -- 1 is English.
    is_logged_in BOOL, 
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
(4,'New user was registered')


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
    WHEN my_notes = "" OR my_notes is NULL -- if we get an empty string, don't add to notes
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
  requesting_user_id INT UNSIGNED,
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
      CONCAT(@search_clauses, ' AND requesting_user_id IN (', user_id ,')');
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

  -- getting the requesting user, and rows for paging
  SET @ruid = requesting_user_id;

  -- set up paging.  Right now it's always 10 or less rows on the page.
  SET @first_row = page * 10;
  SET @last_row = (page * 10) + 10;

  -- the prime request
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
  description NVARCHAR(10000),
  requesting_user_id INT UNSIGNED,
	title NVARCHAR(255),
  points INT UNSIGNED, 
  categories VARCHAR(50),
  OUT new_request_id INT UNSIGNED
) 
BEGIN 
  -- Check that the user has the points.
  SET @user_points_sql = "
      SELECT points INTO @user_points
      FROM user 
      WHERE user_id = @requesting_user_id";
	PREPARE user_points_sql FROM @user_points_sql;
	EXECUTE user_points_sql; 
  
  IF (@user_points < @points) THEN
      SET @msg = CONCAT('user lacks points to make this request: ', 
        @requesting_user_id );
      SIGNAL SQLSTATE '45001' set message_text = msg;
  END IF;

  -- A) The main part - add the request to that table.
  SET @desc = description;
  SET @points = points;
  SET @title = title;
  SET @status = 76; -- requests always start 'open'
  SET @ruid = requesting_user_id;
	SET @insert_clause = 
      "INSERT into request (description, datetime, points,
       status, title, requesting_user_id)
       VALUES (@desc, UTC_TIMESTAMP(), @points, @status, @title, @ruid)"; 
         
	PREPARE insert_clause FROM @insert_clause;
	EXECUTE insert_clause; 
  SET @new_request_id = LAST_INSERT_ID();


  -- B) Add categories.
  CREATE TEMPORARY TABLE CAT_IDS (id INT);
  SET @cat_sql = CONCAT('INSERT INTO CAT_IDS (id) VALUES ',categories);
	PREPARE cat_sql FROM @cat_sql;
	EXECUTE cat_sql; 
  INSERT INTO request_to_category (request_id, request_category_id)
  SELECT @new_request_id, id FROM CAT_IDS;
  DROP TABLE CAT_IDS;

  -- C) Deduct points from the user
  SET @update_points_sql = 
    "UPDATE user SET points = points - @points WHERE user_id = @ruid";
	PREPARE update_points_sql FROM @update_points_sql;
	EXECUTE update_points_sql; 

  -- D) Add an audit
  CALL add_audit(1,@ruid,@new_request_id,'');
END

---DELIMITER---

CREATE PROCEDURE put_message
(
  message NVARCHAR(10000),
  user_id INT UNSIGNED,
  request_id INT UNSIGNED
) 
BEGIN 
  -- A) The main part - add the request to that table.
  SET @message = message;
  SET @user_id = user_id;
  SET @request_id = request_id;

	SET @insert_clause = 
     "INSERT into request_message (message, request_id, user_id, timestamp)
      SELECT 
      CONCAT(username,' says:', @message), 
      @request_id, 
      user_id, 
      UTC_TIMESTAMP()
      FROM user WHERE user_id = @user_id";
 
	PREPARE insert_clause FROM @insert_clause;
	EXECUTE insert_clause; 
END

---DELIMITER---

CREATE PROCEDURE delete_request
(
  user_id INT UNSIGNED,
  request_id INT UNSIGNED
) 
BEGIN 
  SET @user_id = user_id;
  SET @request_id = request_id;

  -- first check that they are trying to 
  -- delete something that exists
   SET @valid_id_sql = "
    SELECT COUNT(*) INTO @valid_id 
    FROM request 
    WHERE request_id = @request_id";
	PREPARE valid_id_sql FROM @valid_id_sql;
	EXECUTE valid_id_sql; 

  IF (@valid_id <> 1) THEN
      SET @msg = CONCAT('request does not exist in the system: ', 
        @request_id);
      SIGNAL SQLSTATE '45002' 
      SET message_text = @msg;
  END IF;

  -- get the points on this request.

  SET @pts_sql = "
    SELECT points into @points
    FROM request 
    WHERE request_id = @request_id
    ";
	PREPARE pts_sql FROM @pts_sql;
	EXECUTE pts_sql; 

  -- get a string version of the status
  SET @status_sql = "
      SELECT request_status_value INTO @status
      FROM request_status 
      WHERE request_status_id = 
        (
          SELECT status
          FROM request 
          WHERE request_id = @request_id
        )";
	PREPARE status_sql FROM @status_sql;
	EXECUTE status_sql; 

  -- get a message for the deletion audit
  SET @delete_msg_sql = 
  "SELECT CONCAT(
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
    WHERE request_id = @request_id";

	PREPARE delete_msg_sql FROM @delete_msg_sql;
	EXECUTE delete_msg_sql;  

  -- actually delete the request here.
  SET @del_sql = 'DELETE FROM request WHERE request_id = @request_id';

	PREPARE del_sql FROM @del_sql;
	EXECUTE del_sql; 

  -- give points back to the user
  SET @pts_sql = '
    UPDATE user 
    SET points = points + @points 
    WHERE user_id = @user_id';

	PREPARE pts_sql FROM @pts_sql;
	EXECUTE pts_sql; 

  -- Add an audit
  CALL add_audit(2,@user_id,@request_id,@delete_msg);

END

---DELIMITER---

CREATE PROCEDURE create_new_user
(
  username NVARCHAR(50),
  password NVARCHAR(50)
) 
BEGIN 
  SET @username = username;
  SET @password = password;

  -- check that this username doesn't match an email in the system
  SET @username_exists_as_email = "
    SELECT COUNT(*) INTO @count_email_username
    FROM user 
    WHERE @username = user.email";
	PREPARE username_exists_as_email FROM @username_exists_as_email;
	EXECUTE username_exists_as_email;  
    
  IF (@count_email_username > 0) THEN
      SET @msg = CONCAT('username matches existing email during insert: ', @username );
      SIGNAL SQLSTATE '45000' 
      SET message_text = @msg;
  END IF;

  -- add the user
  SET @insert_sql = "
    INSERT INTO user (username, password, points)
    VALUES (@username, @password, 100)";
	PREPARE insert_sql FROM @insert_sql;
	EXECUTE insert_sql;  

  SET @new_user_id = LAST_INSERT_ID();
  -- Add an audit
  CALL add_audit(4,@new_user_id,NULL,NULL);

END

