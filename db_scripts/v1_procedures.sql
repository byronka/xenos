-- NOTE: This script will rebuild any existing procedures of the same name.



DROP PROCEDURE IF EXISTS is_non_empty_string;

-- Some helper validation functions follow:
-- -----------------------------------------
---DELIMITER---

CREATE PROCEDURE is_non_empty_string
(
  procname VARCHAR(40), -- add here the name of the procedure we're coming from
  fieldname VARCHAR(40), -- add the field we're checking for non-null or empty
  text_value NVARCHAR(10000) -- here you place the actual text to check
) 
BEGIN
  IF (text_value IS NULL OR text_value = '') THEN
      SET @msg = CONCAT(fieldname,' value in ',procname,' was empty or null');
      ROLLBACK;
      SIGNAL SQLSTATE '45000' 
      SET message_text = @msg;
  END IF;
END

---DELIMITER---

DROP PROCEDURE IF EXISTS validate_request_id;

---DELIMITER---

CREATE PROCEDURE validate_request_id
(
  rid INT UNSIGNED
) 
BEGIN 

  SELECT COUNT(*) INTO @valid_rid 
  FROM request 
  WHERE request_id = rid;

  IF (@valid_rid <> 1) THEN
      SET @msg = CONCAT('request does not exist in the system: ', 
        rid);
      ROLLBACK;
      SIGNAL SQLSTATE '45002' 
      SET message_text = @msg;
  END IF;
END
---DELIMITER---

DROP PROCEDURE IF EXISTS validate_user_id;

---DELIMITER---

CREATE PROCEDURE validate_user_id
(
  uid INT UNSIGNED
) 
BEGIN 

  SELECT COUNT(*) INTO @valid_uid 
  FROM user 
  WHERE user_id = uid;

  IF (@valid_uid <> 1) THEN
      SET @msg = CONCAT('user does not exist in the system: ', 
        uid);
      ROLLBACK;
      SIGNAL SQLSTATE '45002' 
      SET message_text = @msg;
  END IF;
END

---DELIMITER---

DROP PROCEDURE IF EXISTS add_audit;

---DELIMITER---
-- a procedure we will call to add the audit, to keep things tidy
-- in the code.  We are adding to two tables at once, possibly (notes
-- and audit) so to avoid having complexity in the java, we'll just
-- call the stored procedure.
--
-- No transactions here - it's assumed we'll be called from inside one.
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

-- Business procedures now
-- -----------------------

---DELIMITER---

DROP PROCEDURE IF EXISTS get_others_requests;
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

DROP PROCEDURE IF EXISTS put_request;
---DELIMITER---
CREATE PROCEDURE put_request
(
  my_desc NVARCHAR(10000),
  ruid INT UNSIGNED, -- requesting user id
	ti NVARCHAR(255), -- title
  pts INT UNSIGNED, -- points
  cats VARCHAR(50), -- categories - this cannot be empty or we'll SQLException.
  OUT new_request_id INT UNSIGNED
) 
BEGIN 

  IF (LENGTH(cats) = 0) THEN
      SET @cat_err_msg = 'categories was empty - not allowed in this proc';
      SIGNAL SQLSTATE '45001' set message_text = @cat_err_msg;
  END IF;

  START TRANSACTION;

  -- check the user exists
  call validate_user_id(ruid);
  
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
  CREATE TEMPORARY TABLE IF NOT EXISTS CAT_IDS (id INT);
  SELECT CONCAT(
    'INSERT INTO CAT_IDS (id) VALUES ',cats) INTO @cat_sql;

  PREPARE cat_sql FROM @cat_sql;
  EXECUTE cat_sql;

  INSERT INTO request_to_category (request_id, request_category_id)
  SELECT new_request_id, id FROM CAT_IDS;
  DROP TEMPORARY TABLE CAT_IDS;

  -- C) Deduct points from the user
  UPDATE user SET points = points - pts WHERE user_id = ruid;


  -- D) Add an audit
  CALL add_audit(1,ruid,new_request_id,'');

  COMMIT;
END

---DELIMITER---

DROP PROCEDURE IF EXISTS put_message;

---DELIMITER---

CREATE PROCEDURE put_message
(
  my_message NVARCHAR(10000),
  uid INT UNSIGNED,
  rid INT UNSIGNED
) 
BEGIN 
  -- A) The main part - add the request to that table.
  CALL is_non_empty_string('put_message','my_message',my_message);
  call validate_request_id(rid);
  call validate_user_id(uid);

  INSERT into request_message (message, request_id, user_id, timestamp)
  SELECT 
    CONCAT(username,' says:', my_message), 
    rid, 
    uid, 
    UTC_TIMESTAMP()
  FROM user WHERE user_id = uid;
END

---DELIMITER---

DROP PROCEDURE IF EXISTS take_request;

---DELIMITER---

CREATE PROCEDURE take_request
(
  uid INT UNSIGNED,
  rid INT UNSIGNED
) 
BEGIN 
  call validate_request_id(rid);
  call validate_user_id(uid);

  START TRANSACTION;
    UPDATE request 
    SET 
      status = 78,  -- 'taken'
      handling_user_id = uid  
    WHERE request_id = rid;

    -- Add an audit
    CALL add_audit(3,uid,rid,NULL);

  COMMIT;

END

---DELIMITER---

DROP PROCEDURE IF EXISTS delete_request;

---DELIMITER---

CREATE PROCEDURE delete_request
(
  uid INT UNSIGNED,
  rid INT UNSIGNED
) 
BEGIN 

  -- check that the request exists
  call validate_request_id(rid);
  call validate_user_id(uid);

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

  START TRANSACTION;

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

DROP PROCEDURE IF EXISTS create_new_user;

---DELIMITER---

CREATE PROCEDURE create_new_user
(
  uname NVARCHAR(50),
  pword VARCHAR(64),
  slt VARCHAR(50)
) 
BEGIN 

  -- make sure the username and password and salt are non-empty
  call is_non_empty_string('create_new_user','uname',uname);
  call is_non_empty_string('create_new_user','pword',pword);
  call is_non_empty_string('create_new_user','slt',slt);

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

  START TRANSACTION;

    -- add the user
    INSERT INTO user (username, password, salt, date_created)
    VALUES (uname, pword, slt, UTC_TIMESTAMP());

    SET @new_user_id = LAST_INSERT_ID();

    -- Add an audit
    CALL add_audit(4,@new_user_id,NULL,NULL);

  COMMIT;

END

---DELIMITER---

DROP PROCEDURE IF EXISTS register_user_and_get_cookie;

---DELIMITER---

CREATE PROCEDURE register_user_and_get_cookie
(
  uid INT UNSIGNED,
  ip VARCHAR(15), -- e.g. "255.255.255.255"
  p_phrase VARCHAR(50), -- used to encrypt the cookie_plaintext
  OUT new_cookie VARCHAR(200)
) 
BEGIN 
  call validate_user_id(uid);
  call is_non_empty_string('register_user_and_get_cookie','ip',ip);
  call is_non_empty_string('register_user_and_get_cookie','p_phrase',p_phrase);

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

DROP PROCEDURE IF EXISTS decrypt_cookie_and_check_validity;

---DELIMITER---

CREATE PROCEDURE decrypt_cookie_and_check_validity
(
  enc_cookie VARCHAR(200), -- The cookie encrypted
  p_phrase VARCHAR(50),
  OUT user_id_out INT
) 
BEGIN 
  call is_non_empty_string(
    'decrypt_cookie_and_check_validity','enc_cookie',enc_cookie);
  call is_non_empty_string(
    'decrypt_cookie_and_check_validity','p_phrase',p_phrase);

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
  ELSE -- if we got here, the user's info is good.
    UPDATE user SET last_activity_time = UTC_TIMESTAMP() WHERE user_id = @my_user_id;
    SET user_id_out = @my_user_id;
  END IF;
 
END
