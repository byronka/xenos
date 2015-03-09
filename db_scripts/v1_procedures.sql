-- NOTE: This script will rebuild any existing procedures of the same name.


-- Some helper validation functions follow:
-- -----------------------------------------



DROP PROCEDURE IF EXISTS is_non_empty_string;

---DELIMITER---

CREATE PROCEDURE is_non_empty_string
(
  procname VARCHAR(40), -- the name of the procedure we're coming from
  fieldname VARCHAR(40), -- the field we're checking for non-null or empty
  text_value NVARCHAR(200) -- the actual text to check
) 
BEGIN
  IF (text_value IS NULL OR text_value = '') THEN
      SET @msg = CONCAT(
        fieldname,' value in ',procname,' was empty or null');
      
      SIGNAL SQLSTATE '45000' 
      SET message_text = @msg;
  END IF;
END

---DELIMITER---

DROP PROCEDURE IF EXISTS recalculate_rank_on_user;

---DELIMITER---

-- This procedure calculates and applies the rank calculation for users.
-- it operates on a 6-month rolling schedule.  Every input, thumbs-up
-- or thumbs-down, will be inserted into the table and averaged out.

-- inputs that are more than 6 months old will be deleted and not applied
-- in this average.

-- this procedure does not double-check the user or requestoffer id, 
-- because it is assumed that by the time the calling procedure 
-- gets to this one,
-- that will have already been validated.

CREATE PROCEDURE recalculate_rank_on_user
(
  j_uid INT UNSIGNED, -- ther user judging the other user
  uid INT UNSIGNED, -- the user id having his rank recalculated
  rid INT UNSIGNED, -- the requestoffer id
  is_thumbs_up BOOL -- the opinion of the other party
) 
BEGIN
  
  -- get the number of rankings that are less than 60 days old
  UPDATE user
  SET rank = 
  (
    SELECT AVG(meritorious)
    FROM user_rank_data_point
    WHERE UTC_TIMESTAMP() < (date_entered + INTERVAL 60 DAY)
  )
  WHERE user_id = uid;

END

---DELIMITER---

DROP PROCEDURE IF EXISTS validate_requestoffer_id;

---DELIMITER---

CREATE PROCEDURE validate_requestoffer_id
(
  rid INT UNSIGNED
) 
BEGIN 

  SELECT COUNT(*) INTO @valid_rid 
  FROM requestoffer 
  WHERE requestoffer_id = rid;

  IF (@valid_rid <> 1) THEN
      SET @msg = CONCAT('requestoffer does not exist in the system: ', 
        rid);
      
      SIGNAL SQLSTATE '45000' 
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
      
      SIGNAL SQLSTATE '45000' 
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
CREATE PROCEDURE add_audit
(
  my_audit_action_id INT UNSIGNED, 
  my_user1_id INT UNSIGNED, 
  my_user2_id INT UNSIGNED, 
  my_requestoffer_id INT UNSIGNED, 
  my_extra_id INT UNSIGNED,
  my_notes NVARCHAR(100)
) 
BEGIN 
  DECLARE the_audit_notes_id INT UNSIGNED;

  IF my_notes = "" OR my_notes is NULL -- if we get an empty string, don't add to notes
  THEN 
    INSERT INTO audit (
      datetime, audit_action_id, user1_id, 
      user2_id, requestoffer_id, extra_id)
      VALUES(
        UTC_TIMESTAMP(), 
        my_audit_action_id, 
        my_user1_id, 
        my_user2_id, 
        my_requestoffer_id,
        my_extra_id
      );
  ELSE
    INSERT INTO audit_notes (notes) VALUES(my_notes);
    SET the_audit_notes_id = LAST_INSERT_ID();
    INSERT INTO audit (
      datetime, audit_action_id, user1_id, user2_id, requestoffer_id, extra_id, notes_id)
      VALUES(
        UTC_TIMESTAMP(),     -- the current time and date
        my_audit_action_id,  -- the action, e.g. create, delete, etc.
        my_user1_id,          -- the user causing the action
        my_user2_id,          -- the user causing the action
        my_requestoffer_id,        -- the thing being acted upon
        my_extra_id,              -- extra id's, for example, locations
        the_audit_notes_id); -- notes about the action ,like during requestoffer delete
  END IF;

END

-- Business procedures now
-- -----------------------

---DELIMITER---

DROP PROCEDURE IF EXISTS get_others_requestoffers;
---DELIMITER---
CREATE PROCEDURE get_others_requestoffers
(
  ruid INT UNSIGNED, -- the user asking to see the request offers
  startdate VARCHAR(10),
  enddate VARCHAR(10),
  status VARCHAR(50), -- can be many INT's separated by commas
  categories VARCHAR(50),
  user_id VARCHAR(50), -- can be many INT's separated by commas
  page INT UNSIGNED,
  description NVARCHAR(50),
  minrank FLOAT, -- must be between 0 and 1, or null
  maxrank FLOAT, -- must be between 0 and 1, or null
  postcode VARCHAR(50), 
	OUT total_pages INT UNSIGNED
) 
BEGIN 
	SET @search_clauses = ""; -- all our search clauses go on this.
         
  -- searching by status
  IF status <> '' THEN
    SET @search_clauses = 
      CONCAT(@search_clauses, ' AND rs.status IN (',status,') ');
  END IF;


  -- searching by categories
  IF categories <> '' THEN
    SET @search_clauses = 
      CONCAT(@search_clauses, ' AND rc.category_id IN (',categories,') ');
  END IF;

  -- searching by requestoffering user
  IF user_id <> '' THEN
    SET @search_clauses = 
			CONCAT(@search_clauses, 
				' AND requestoffering_user_id IN (', user_id ,')');
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

  -- searching by description
  IF description <> '' THEN
    SET @desc = description;
    SET @search_clauses = 
    CONCAT(@search_clauses, 
      " AND description LIKE CONCAT('%' , @desc , '%') ");
  END IF;

  -- searching by rank
  IF minrank > 0.0 AND maxrank > 0.0 THEN
    SET @minrank = minrank;
    SET @maxrank = maxrank;
    SET @search_clauses = 
      CONCAT(@search_clauses, 
        ' AND @minrank <= u.rank AND u.rank <= @maxrank ');
  ELSEIF minrank > 0 THEN
    SET @minrank = minrank;
    SET @search_clauses = 
      CONCAT(@search_clauses, ' AND @minrank <= u.rank ');
  ELSEIF maxrank > 0 THEN
    SET @maxrank = maxrank;
    SET @search_clauses = 
      CONCAT(@search_clauses, ' AND @maxrank >= u.rank ');
  END IF;

  -- searching by postcode - right now, only an exact match
  IF postcode <> '' THEN
    SET @postcode = postcode;
    SET @search_clauses = 
      CONCAT(@search_clauses, ' AND l.postal_code = @postcode ');
  END IF;

  SET @ruid = ruid;

  -- set up paging.  Right now it's always 10 or less rows on the page.
  SET @first_row = page * 10;
  SET @last_row = (page * 10) + 10;

  SET @get_requestoffer = 
     CONCAT('
        (
            SELECT SQL_CALC_FOUND_ROWS r.requestoffer_id, 
            r.datetime, 
            r.description, 
            rs.status, 
            r.points, 
            u.rank, 
            rsr.user_id AS been_offered,
            r.requestoffering_user_id, 
            r.handling_user_id, 
            GROUP_CONCAT(DISTINCT l.postal_code SEPARATOR ",") AS postcodes,
            GROUP_CONCAT(DISTINCT l.city SEPARATOR ",") AS cities,
            GROUP_CONCAT(rc.category_id SEPARATOR ",") 
            AS categories 
            FROM requestoffer r 
            JOIN requestoffer_state rs
              ON rs.requestoffer_id = r.requestoffer_id
            JOIN requestoffer_to_category rtc 
              ON rtc.requestoffer_id = r.requestoffer_id 
            JOIN requestoffer_category rc 
              ON rc.category_id = rtc.requestoffer_category_id 
            JOIN user u ON u.user_id = r.requestoffering_user_id 
            LEFT JOIN requestoffer_service_request rsr
              ON r.requestoffer_id = rsr.requestoffer_id 
              AND rsr.user_id = @ruid AND rsr.status = 106 -- 106 is "NEW"
            LEFT JOIN location_to_requestoffer ltr
              ON r.requestoffer_id = ltr.requestoffer_id
            LEFT JOIN location l
              ON l.location_id = ltr.location_id
            WHERE rs.status = 109 AND r.requestoffering_user_id = @ruid
            ', @search_clauses ,'
            GROUP BY r.requestoffer_id , l.city, l.postal_code
          )

            UNION ALL

          (
            SELECT r.requestoffer_id, 
            r.datetime, 
            r.description, 
            rs.status, 
            r.points, 
            u.rank, 
            rsr.user_id AS been_offered,
            r.requestoffering_user_id, 
            r.handling_user_id, 
            GROUP_CONCAT(DISTINCT l.postal_code SEPARATOR ",") AS postcodes,
            GROUP_CONCAT(DISTINCT l.city SEPARATOR ",") AS cities,
            GROUP_CONCAT(rc.category_id SEPARATOR ",") 
            AS categories 
            FROM requestoffer r 
            JOIN requestoffer_state rs
              ON rs.requestoffer_id = r.requestoffer_id
            JOIN requestoffer_to_category rtc 
              ON rtc.requestoffer_id = r.requestoffer_id 
            JOIN requestoffer_category rc 
              ON rc.category_id = rtc.requestoffer_category_id 
            JOIN user u ON u.user_id = r.requestoffering_user_id 
            LEFT JOIN requestoffer_service_request rsr
              ON r.requestoffer_id = rsr.requestoffer_id 
              AND rsr.user_id = @ruid AND rsr.status = 106 -- 106 is "NEW"
            LEFT JOIN location_to_requestoffer ltr
              ON r.requestoffer_id = ltr.requestoffer_id
            LEFT JOIN location l
              ON l.location_id = ltr.location_id
            WHERE rs.status <> 109
            ', @search_clauses ,'
            GROUP BY r.requestoffer_id , l.city, l.postal_code
          )
            ORDER BY datetime DESC
            LIMIT ',@first_row,',',@last_row );


  -- prepare and execute!
	PREPARE get_requestoffer FROM @get_requestoffer;
	EXECUTE get_requestoffer; 

	SET total_pages = CEIL(FOUND_ROWS()/10);

END

---DELIMITER---

DROP PROCEDURE IF EXISTS put_requestoffer;

---DELIMITER---

CREATE PROCEDURE put_requestoffer
(
  my_desc NVARCHAR(200),
  ruid INT UNSIGNED, -- requestoffering user id
  pts INT, -- points
  cats VARCHAR(50), -- categories - this cannot be empty or we'll SQLException.
  OUT new_requestoffer_id INT UNSIGNED
) 
BEGIN 

  IF (LENGTH(cats) = 0) THEN
      SET @cat_err_msg = 'categories was empty - not allowed in this proc';
      SIGNAL SQLSTATE '45000' set message_text = @cat_err_msg;
  END IF;

  -- check the user exists
  call validate_user_id(ruid);
  
  -- A) The main part - add the requestoffer to that table.
  INSERT into requestoffer (description, datetime, points,
   requestoffering_user_id)
   VALUES (my_desc, UTC_TIMESTAMP(), pts, ruid); 
         
  SET new_requestoffer_id = LAST_INSERT_ID();
  SET @status = 109; -- requestoffers always start 'draft'

  INSERT INTO requestoffer_state (requestoffer_id, status, datetime)
  VALUES (new_requestoffer_id, @status, UTC_TIMESTAMP());


  -- B) Add categories.
  CREATE TEMPORARY TABLE IF NOT EXISTS CAT_IDS (id INT);
  SELECT CONCAT(
    'INSERT INTO CAT_IDS (id) VALUES ',cats) INTO @cat_sql;

  PREPARE cat_sql FROM @cat_sql;
  EXECUTE cat_sql;

  INSERT INTO 
    requestoffer_to_category (requestoffer_id, requestoffer_category_id)
  SELECT new_requestoffer_id, id FROM CAT_IDS;
  DROP TEMPORARY TABLE CAT_IDS;



  -- D) Add an audit

  -- audit that this user created a new requestoffer
  CALL add_audit(201,ruid,NULL,new_requestoffer_id,NULL,'');

END

---DELIMITER---

DROP PROCEDURE IF EXISTS put_system_to_user_message;

---DELIMITER---

-- a message sent from the system to a user
-- requires localization

CREATE PROCEDURE put_system_to_user_message
(
  the_message_id INT UNSIGNED, -- the id to a localization value
  to_uid INT UNSIGNED, -- user we are sending this to
  rid INT UNSIGNED -- referenced requestoffer, if that applies
) 
BEGIN 

  INSERT into system_to_user_message (
		text_id, requestoffer_id, to_user_id, timestamp)
  VALUES 
    (
      the_message_id,
      rid, 
      to_uid, 
      UTC_TIMESTAMP()
    );

  CALL put_temporary_message(to_uid, the_message_id, NULL);

END

---DELIMITER---

DROP PROCEDURE IF EXISTS put_temporary_message;

---DELIMITER---

-- stores a message in a table.  Messages over
-- 24 hours old get deleted from this table.

CREATE PROCEDURE put_temporary_message
(
  uid INT UNSIGNED, 
  message_id INT UNSIGNED,
  message_text NVARCHAR(1000)
) 
BEGIN 
  CALL validate_user_id(uid);

  -- check if we got an id to a message or a message string

  IF (message_id > 0) THEN

    -- just insert a row of data holding the message id
    INSERT INTO temporary_message
    (timestamp, user_id, message_localization_id)
    VALUES(UTC_TIMESTAMP(), uid, message_id);

  ELSEIF (message_text IS NOT NULL AND message_text <> '') THEN

      -- add the first piece
      INSERT INTO temporary_message
      (timestamp, user_id)
      VALUES(UTC_TIMESTAMP(), uid);

      -- add the text piece that ties back to the first piece
      INSERT INTO temporary_message_text
      (message_id, text)
      VALUES(LAST_INSERT_ID(), message_text);

  ELSE

    
    SIGNAL SQLSTATE '45000' 
    SET message_text =
      'exceptional situation - no message text or message id provided';

  END IF;


END

---DELIMITER---

DROP PROCEDURE IF EXISTS put_message;

---DELIMITER---

-- a message sent from one user to another within
-- the context of a requestoffer

CREATE PROCEDURE put_message
(
  my_message NVARCHAR(200),
  fr_uid INT UNSIGNED,
  rid INT UNSIGNED
) 
BEGIN 
  CALL is_non_empty_string('put_message','my_message',my_message);
  call validate_requestoffer_id(rid);
  call validate_user_id(fr_uid);

	-- whoever is the user id in the parameter is doing the talking,
  -- and we know both parties - a requestoffer owner and its handler.
	SELECT requestoffering_user_id , handling_user_id INTO @ro_uid,@h_uid
	FROM requestoffer ro
	WHERE ro.requestoffer_id = rid;

	IF fr_uid = @ro_uid
		THEN
		SET @to_user_id = @h_uid;
	ELSEIF fr_uid = @h_uid
		THEN
		SET @to_user_id = @ro_uid;
	END IF;

  SELECT 
    CONCAT(username,' says:', my_message) INTO @full_msg
  FROM user WHERE user_id = fr_uid;

  INSERT into requestoffer_message (
		message, requestoffer_id, from_user_id, to_user_id, timestamp)
  VALUES (@full_msg, rid, fr_uid, @to_user_id, UTC_TIMESTAMP());

  CALL put_temporary_message(@to_user_id, NULL, @full_msg);

END

---DELIMITER---

DROP PROCEDURE IF EXISTS offer_to_take_requestoffer;

---DELIMITER---

CREATE PROCEDURE offer_to_take_requestoffer
(
  uid INT UNSIGNED, -- the user who will handle the requestoffer
  rid INT UNSIGNED -- the id of the requestoffer
) 
BEGIN 

  call validate_requestoffer_id(rid);
  call validate_user_id(uid);

	SELECT COUNT(*) INTO @can_take
	FROM requestoffer_state rs
	WHERE rs.status = 76 -- 'open'
	AND rs.requestoffer_id = rid;
	
  IF (@can_take <> 1) THEN
      SET @msg = CONCAT('cannot take requestoffer', rid,', not open');
      SIGNAL SQLSTATE '45000' SET message_text = @msg;
  END IF;

  INSERT INTO requestoffer_service_request 
    (requestoffer_id, user_id, date_created, status)
  VALUES (rid, uid, UTC_TIMESTAMP(), 106); -- starts with 'new' status

	SELECT r.requestoffering_user_id INTO @ro_owner
	FROM requestoffer r
	WHERE r.requestoffer_id = rid;

  -- send a message to the owner of that requestoffer
  CALL put_system_to_user_message(148, @ro_owner, rid);

  -- Add an audit that this user is offering to take the requestoffer
  CALL add_audit(209,uid,@ro_owner,rid,NULL,NULL);

END

---DELIMITER---

DROP PROCEDURE IF EXISTS take_requestoffer;

---DELIMITER---

CREATE PROCEDURE take_requestoffer
(
  uid INT UNSIGNED, -- the user who will handle the requestoffer
  rid INT UNSIGNED -- the id of the requestoffer
) 
BEGIN 

  call validate_requestoffer_id(rid);
  call validate_user_id(uid);

	SELECT COUNT(*) INTO @can_take
	FROM requestoffer_state rs
	WHERE rs.status = 76 -- 'open'
	AND rs.requestoffer_id = rid;
	
  IF (@can_take <> 1) THEN
      SET @msg = CONCAT('cannot take requestoffer', rid,', not open');
      SIGNAL SQLSTATE '45000' SET message_text = @msg;
  END IF;

  -- modify the requestoffer to indicate this user has taken it
  UPDATE requestoffer 
  SET handling_user_id = uid  
  WHERE requestoffer_id = rid;

  UPDATE requestoffer_state
  SET status = 78 -- "taken", datetime = UTC_TIMESTAMP()
  WHERE requestoffer_id = rid;

  -- get the owner's user id
  SELECT requestoffering_user_id INTO @owner_id
  FROM requestoffer
  WHERE requestoffer_id = rid;
  
  -- indicate that this user is in "ACTIVE" state on this requestoffer
  INSERT INTO user_rank_data_point
  (date_entered, judge_user_id, judged_user_id, requestoffer_id, status_id)
  VALUES 
  (UTC_TIMESTAMP(), @owner_id,uid, rid, 1), 
  (UTC_TIMESTAMP(), uid,@owner_id, rid, 1); 

  SET @urdp_id = LAST_INSERT_ID();

  -- Add an audit that these users are going into ACTIVE state
  CALL add_audit(306,uid,@owner_id,rid,@urdp_id,NULL);
  CALL add_audit(306,@owner_id,uid,rid,@urdp_id,NULL);

  -- change the service request to accepted for the winning user
  UPDATE requestoffer_service_request 
  SET 
    status = 107, -- "accepted"
    date_modified = UTC_TIMESTAMP()
  WHERE requestoffer_id = rid AND user_id = uid AND status = 106;

  -- Add an audit for the winning user
  CALL add_audit(207,@owner_id,uid,rid,NULL,NULL);

  -- send a message to the winnng user
  CALL put_system_to_user_message(132, uid, rid);

  -- Add an audit for the losing users
  INSERT INTO audit (
    datetime, audit_action_id, user1_id, user2_id, requestoffer_id)
  SELECT UTC_TIMESTAMP(), 208, @owner_id, user_id, rid
  FROM requestoffer_service_request 
  WHERE requestoffer_id = rid AND user_id <> uid AND status = 106;

  -- send a message to other users they were rejected
  INSERT into system_to_user_message (
    text_id, requestoffer_id, to_user_id, timestamp)
  SELECT 133, rid, user_id, UTC_TIMESTAMP()
  FROM requestoffer_service_request 
  WHERE requestoffer_id = rid AND user_id <> uid AND status = 106;

  INSERT INTO temporary_message
  (timestamp, user_id, message_localization_id)
  SELECT UTC_TIMESTAMP(), user_id, 133
  FROM requestoffer_service_request 
  WHERE requestoffer_id = rid AND user_id <> uid AND status = 106;

  -- change the service request to rejected for the losing users
  UPDATE requestoffer_service_request 
  SET 
    status = 108, -- "rejected"
    date_modified = UTC_TIMESTAMP()
  WHERE requestoffer_id = rid AND user_id <> uid AND status = 106;


END

---DELIMITER---

DROP PROCEDURE IF EXISTS delete_requestoffer;

---DELIMITER---

CREATE PROCEDURE delete_requestoffer
(
  uid INT UNSIGNED,
  rid INT UNSIGNED
) 
BEGIN 
  -- check that the requestoffer exists
  call validate_requestoffer_id(rid);
  call validate_user_id(uid);


  -- get a string version of the status
  SELECT requestoffer_status_id, requestoffer_status_value 
  INTO @status_id, @status
  FROM requestoffer_status 
  WHERE requestoffer_status_id = 
    (
      SELECT status
      FROM requestoffer_state
      WHERE requestoffer_id = rid
    );

  IF (@status_id <> 76 AND @status_id <> 109) THEN
    SET @msg = CONCAT('not possible to delete request ',rid,
    ' since it is not open or draft');
    SIGNAL SQLSTATE '45000' SET message_text = @msg;
  END IF;

  -- get a message for the deletion audit
  SELECT CONCAT(
      SUBSTR(description,1,30),
      '|',
      'created:', SUBSTR(datetime,1,10),
      '|',
      'pts:', points,
      '|',
      'st:',@status) INTO @delete_msg
    FROM requestoffer
    WHERE requestoffer_id = rid;

    
      -- actually delete the requestoffer here.
      DELETE FROM requestoffer WHERE requestoffer_id = rid;


      -- Add an audit about deleting the requestoffer
      CALL add_audit(205,uid,NULL,rid,NULL,@delete_msg);

    
END

---DELIMITER---

DROP PROCEDURE IF EXISTS retract_requestoffer;

---DELIMITER---
CREATE PROCEDURE retract_requestoffer
(
  uid INT UNSIGNED, -- the user id making the choice to unpublish
  rid INT UNSIGNED -- the requestoffer id
) 
BEGIN 
  CALL validate_user_id(uid);
  CALL validate_requestoffer_id(rid);

  UPDATE requestoffer_state
  SET status = 109, datetime = UTC_TIMESTAMP() -- 109 is "DRAFT"
  WHERE requestoffer_id = rid AND status = 76; -- 76 is "OPEN"

  -- get the points on this requestoffer.
  SELECT points, requestoffering_user_id into @points, @ruid
  FROM requestoffer 
  WHERE requestoffer_id = rid;

  -- give points back to the user
  UPDATE user 
  SET points = points + @points 
  WHERE user_id = @ruid;


  -- audit that the requestoffer was reverted
  call add_audit(206, uid, @ruid, rid, NULL, NULL);

  -- audit that the point was returned to the user who owns the requestoffer
  call add_audit(303, 1, @ruid, rid, NULL, NULL);

END
---DELIMITER---

DROP PROCEDURE IF EXISTS create_new_user;

---DELIMITER---

CREATE PROCEDURE create_new_user
(
  uname NVARCHAR(50),
  pword VARCHAR(64),
  slt VARCHAR(50),
  ipaddr VARCHAR(40), -- their ip address
  my_invite_code VARCHAR(100)
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
      
      SIGNAL SQLSTATE '45000' 
      SET message_text = @msg;
  END IF;

  -- check that the invite code is valid
  SELECT COUNT(*) INTO @count_invite_code
  FROM invite_code
  WHERE value = my_invite_code;

  -- guard against the count of valid invite codes being zero
  -- we will use this error message back on the client side.
  IF @count_invite_code = 0 THEN
      -- if the ip address is too long, truncate
      IF LENGTH(ipaddr) > 20 THEN
        SET @my_ipaddr = CONCAT(SUBSTR(ipaddr,1,20),'...');
      ELSE
        SET @my_ipaddr = ipaddr;
      END IF;

      -- if the username is too long, truncate
      IF LENGTH(uname) > 10 THEN
        SET @name = CONCAT(SUBSTR(uname,1,10),'...');
      ELSE
        SET @name = uname;
      END IF;

      SET @message = CONCAT('ip: ',@my_ipaddr,' name: ',@name,
        ' invite code: ', SUBSTR(my_invite_code,1,10),'...');

      -- audit that they failed the invite-code check
      CALL add_audit(110,NULL,NULL,NULL,NULL,@message);
      
      -- return an error so we can indicate that on the client
      SIGNAL SQLSTATE '45000' 
      SET message_text = 'invite code is invalid';
  END IF;


  -- add the user
  INSERT INTO user (username, password, salt, date_created, last_ip_logged_in, inviter)
  SELECT uname, pword, slt, UTC_TIMESTAMP(), ipaddr, user_id
  FROM invite_code
  WHERE value = my_invite_code;

  SET @new_user_id = LAST_INSERT_ID();

  -- delete that invite code
  DELETE FROM invite_code
  WHERE value = my_invite_code;

  -- Add an audit about registering a new user
  CALL add_audit(101,@new_user_id,NULL,NULL,NULL,ipaddr);

END

---DELIMITER---

DROP PROCEDURE IF EXISTS register_user_and_get_cookie;

---DELIMITER---

CREATE PROCEDURE register_user_and_get_cookie
(
  uid INT UNSIGNED,
  ip VARCHAR(15), -- e.g. "255.255.255.255"
  OUT new_cookie VARCHAR(200)
) 
BEGIN 

  call validate_user_id(uid);
  call is_non_empty_string('register_user_and_get_cookie','ip',ip);

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

  SELECT config_value INTO @p_phrase 
  FROM config
  WHERE config_item = 'cookie_passphrase';

  SELECT HEX(
    AES_ENCRYPT(
      @cookie_val_plaintext, SHA2(@p_phrase,512))) INTO new_cookie;

  -- register that a user logged in
  CALL add_audit(102, uid, NULL, NULL, NULL, NULL);

END

---DELIMITER---

DROP PROCEDURE IF EXISTS user_logout;

---DELIMITER---

CREATE PROCEDURE user_logout
(
  uid INT UNSIGNED
) 
BEGIN 
    UPDATE user SET is_logged_in = false WHERE user_id = uid;
    CALL add_audit(103, uid, NULL, NULL,NULL,NULL);
END

---DELIMITER---

DROP PROCEDURE IF EXISTS check_login;

---DELIMITER---

CREATE PROCEDURE check_login
(
  their_username NVARCHAR(50),
  their_password VARCHAR(64), -- a hash of their password
  their_ip_address VARCHAR(40), -- ip address of the requestor
	OUT user_id_found INT
) 
BEGIN 

  SELECT user_id, last_ip_logged_in into user_id_found, @last_ip
  FROM user
  WHERE BINARY username = their_username AND BINARY password = their_password;

  -- audit that their username / password didn't match anything in our db
  IF user_id_found IS null THEN
    SET @pass = SUBSTR(IFNULL(their_password,'WAS_NULL'), 1, 10);
    SET @message = CONCAT('ip: ',their_ip_address,' name: ',their_username,' pass: ',@pass,'...');
    CALL add_audit(104,NULL,NULL,NULL,NULL,@message);
  END IF;

  -- audit that they are coming from a different ip now.
  IF @last_ip <> their_ip_address THEN
    SET @ip_msg = CONCAT('old ip: ',@last_ip,' new_ip:',their_ip_address);
    CALL add_audit(108,user_id_found,NULL,NULL,NULL,message);
  END IF;


END
---DELIMITER---

DROP PROCEDURE IF EXISTS decrypt_cookie_and_check_validity;

---DELIMITER---

CREATE PROCEDURE decrypt_cookie_and_check_validity
(
  enc_cookie VARCHAR(200), -- The cookie encrypted
  update_last_activity BOOL, -- whether to update the activity timestamp
  ip_address VARCHAR(40), -- ip address of the requestor
  OUT user_id_out INT
) 
BEGIN 
  call is_non_empty_string(
    'decrypt_cookie_and_check_validity','enc_cookie',enc_cookie);

  SELECT config_value INTO @p_phrase 
  FROM config
  WHERE config_item = 'cookie_passphrase';

  -- See register_user_and_get_cookie for more info on cookie format
  -- if this fails, it should put a null into plaintext_cookie
  SELECT 
    AES_DECRYPT(UNHEX(enc_cookie), SHA2(@p_phrase,512)) 
    INTO @plaintext_cookie;

  -- if there's an error...
  IF (@plaintext_cookie IS NULL OR @plaintext_cookie = '')
    THEN
      SET @msg = 
      CONCAT(
				'got null when trying to unencrypt cookie '
        ,SUBSTR(IFNULL(enc_cookie,''), 1, 6)
        ,'...'
        ,' with passphrase: '
        ,SUBSTR(IFNULL(@p_phrase,''), 1, 4)
        , '...'
        ,'Ip: '
        ,ip_address
      );
      CALL add_audit(107,NULL,NULL,NULL,NULL,@msg);
      SIGNAL SQLSTATE '45000' SET message_text = @msg;
  END IF;

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
    CALL add_audit(106,NULL,NULL,NULL,NULL,@msg);
    SET user_id_out = -1;
  -- if we got here, the user's info is good.
  ELSEIF update_last_activity = 1 THEN
    -- here, we update the last activity time.  This is used by
    -- the timeout mechanism to see if the user has gone idle, and needs
    -- to be logged out automatically.
    UPDATE user 
    SET last_activity_time = UTC_TIMESTAMP() 
    WHERE user_id = @my_user_id;
    SET user_id_out = @my_user_id;
  ELSE
    SET user_id_out = @my_user_id;
  END IF;

 
END

---DELIMITER---

DROP PROCEDURE IF EXISTS complete_ro_transaction;

---DELIMITER---

-- simply sets the state of a requestoffer to closed.
-- however, first, it checks validity of values it's been given.
CREATE PROCEDURE complete_ro_transaction
(
uid INT UNSIGNED, -- the user who owns this requestoffer
rid INT UNSIGNED, -- the requestoffer
satis BOOL -- whether the owner of this RO was satisfied with result
)
BEGIN

  -- first some guard clauses
	call validate_requestoffer_id(rid);	
	call validate_user_id(uid);

	SELECT COUNT(*) INTO @is_valid
	FROM requestoffer r
  JOIN requestoffer_state rs ON rs.requestoffer_id = r.requestoffer_id
	WHERE r.requestoffering_user_id = uid 
		AND r.requestoffer_id = rid
		AND rs.status = 78; -- taken

	IF (@is_valid <> 1) THEN
		SET @msg = CONCAT('requestoffer ',
		  rid,' does not have a requestoffering user id of ',
			uid,' for completion, or it is not in the right status (taken)');
		SIGNAL SQLSTATE '45000' SET message_text = @msg;
	END IF;

	-- at this point we are pretty sure it's all cool.

  -- notice that we don't remove the handling user, that's intentional.
  -- if we've completed this requestoffer, then it's done, it's not going
  -- up again to be reused.  We can go ahead and leave this information
  -- here as an auditing-type artifact.
	UPDATE requestoffer_state -- change state of the requestoffer
	SET status = 77 -- 'closed', datetime = UTC_TIMESTAMP()
	WHERE requestoffer_id = rid;

	CALL add_audit(203,uid,@handling_user_id,rid,NULL,NULL);

  -- get the handling user's id
  SELECT handling_user_id INTO @handling_user_id
  FROM requestoffer 
  WHERE requestoffer_id = rid;

  -- give the handling user their points
  UPDATE user
  SET points = points + 1
  WHERE user_id = @handling_user_id;

  -- only the owner of the requestoffer can "COMPLETE" one.
  
  -- we need the servicer to provide input, so...
  -- change the state for the servicer to COMPLETE_FEEDBACK_POSSIBLE

  SELECT urdp_id INTO @handler_urdp_id
  FROM user_rank_data_point
  WHERE
    judge_user_id = @handling_user_id 
    AND judged_user_id = uid
    AND requestoffer_id = rid
    AND status_id = 1;

  UPDATE user_rank_data_point
    SET 
      date_entered = UTC_TIMESTAMP(),  -- last modified date update
      status_id = 2 -- move them to needing to provide feedback
    WHERE 
    urdp_id = @handler_urdp_id;

  -- audit that we're putting the handling user in COMPLETE_FEEDBACK_POSSIBLE
	CALL add_audit(307,@handling_user_id,uid,rid,@handler_urdp_id,'From status_id 1');

  SELECT urdp_id INTO @owner_urdp_id
  FROM user_rank_data_point
  WHERE
    judge_user_id = uid
    AND judged_user_id = @handling_user_id
    AND requestoffer_id = rid
    AND status_id = 1;

  UPDATE user_rank_data_point
    SET 
      date_entered = UTC_TIMESTAMP(),  -- last modified date update
      meritorious = satis,
      status_id = 3 -- they have provided feedback, they're done.
    WHERE 
      urdp_id = @owner_urdp_id;

  -- Audit that we're putting the owner into COMPLETE
	CALL add_audit(308,uid,@handling_user_id,rid,@owner_urdp_id,'From status_id 1');

  -- audit that the handling user earned a point off this
	CALL add_audit(302,uid,@handling_user_id,rid,NULL,NULL);

  -- recalculate the owner's rank
  CALL recalculate_rank_on_user(uid,@handling_user_id, rid, satis);

  -- audit that the owner is raising or lowering their rank
  IF (satis) THEN
    CALL add_audit(304,uid,@handling_user_id,rid,NULL,NULL);
  ELSE
    CALL add_audit(305,uid,@handling_user_id,rid,NULL,NULL);
  END IF;
	
END

---DELIMITER---

DROP PROCEDURE IF EXISTS publish_requestoffer;

---DELIMITER---

CREATE PROCEDURE publish_requestoffer
(
  uid INT UNSIGNED,
  rid INT UNSIGNED
) 
BEGIN 
	call validate_requestoffer_id(rid);	
	call validate_user_id(uid);

	SELECT COUNT(*) INTO @is_valid
	FROM requestoffer r
  JOIN requestoffer_state rs ON rs.requestoffer_id = r.requestoffer_id
	WHERE r.requestoffering_user_id = uid 
		AND r.requestoffer_id = rid
		AND rs.status = 109; -- draft status

	IF (@is_valid <> 1) THEN
		SET @msg = CONCAT('requestoffer ',
		  rid,' does not have a requestoffering user id of ',
			uid,' , or it is not in the right status (draft)');
		SIGNAL SQLSTATE '45000' SET message_text = @msg;
	END IF;

	-- at this point we are pretty sure it's all cool.

  UPDATE requestoffer_state
  SET status = 76, datetime = UTC_TIMESTAMP()
  WHERE requestoffer_id = rid;

  -- Add an audit that the user published their requestoffer
  CALL add_audit(202,uid,NULL,rid,NULL,NULL);

  SELECT points INTO @pts 
  FROM requestoffer 
  WHERE requestoffer_id = rid;

  -- Deduct points from the user
  UPDATE user SET points = points - @pts WHERE user_id = uid;

  -- audit that we deducted points from the user
  CALL add_audit(301,1,uid,rid,NULL,NULL);


END

---DELIMITER---

DROP PROCEDURE IF EXISTS change_password;   

---DELIMITER---

CREATE PROCEDURE change_password
(
  exec_uid INT UNSIGNED, -- the user carrying out the action
  uid INT UNSIGNED, -- the user whose password we'll change
  new_password VARCHAR(64) -- the new password
) 
BEGIN 

  UPDATE user 
  SET password = new_password
  WHERE user_id = uid;

  CALL add_audit(105,exec_uid,uid,NULL,NULL,NULL);

  

END

---DELIMITER---

DROP PROCEDURE IF EXISTS cancel_taken_requestoffer;   

---DELIMITER---

-- Note that either party may cancel at any time.

CREATE PROCEDURE cancel_taken_requestoffer
(
  uid INT UNSIGNED, -- the user making the choice to cancel
  rid INT UNSIGNED, -- the requestoffer
  is_thumbs_up BOOL -- thumbs up on the cancellation
) 
BEGIN 
    CALL validate_user_id(uid);
    CALL validate_requestoffer_id(rid);

    -- get the other party on this requestoffer.
    -- if we are the owner, get the handler, and vice versa
    SELECT handling_user_id, requestoffering_user_id 
    INTO @handling_user_id, @requestoffering_user_id
    FROM requestoffer
    WHERE requestoffer_id = rid;
    
    -- here we will set the id for the other member
    -- of this transaction
    IF (uid = @handling_user_id) THEN
      SET @other_party = @requestoffering_user_id;
    ELSE
      SET @other_party = @handling_user_id;
    END IF;

    -- change the status on the requestoffer
    UPDATE requestoffer
    SET handling_user_id = NULL  -- clear out the handling user
    WHERE requestoffer_id = rid;

    UPDATE requestoffer_state
    SET status = 76 -- "OPEN", datetime = UTC_TiMESTAMP()
    WHERE requestoffer_id = rid;

    CALL add_audit(204,uid,@other_party,rid,NULL, NULL);

    UPDATE user_rank_data_point
      SET 
        date_entered = UTC_TIMESTAMP(),  -- last modified date update
        status_id = 2 -- move them to needing to provide feedback
      WHERE judge_user_id = @other_party
      AND judged_user_id = uid
      AND requestoffer_id = rid
      AND status_id = 1;

    CALL add_audit(307,@other_party,uid,rid,@handler_urdp_id,'From status_id 1');

    UPDATE user_rank_data_point
      SET 
        date_entered = UTC_TIMESTAMP(),  -- last modified date update
        meritorious = is_thumbs_up,
        status_id = 3 -- they have provided feedback, they're done.
      WHERE judge_user_id = uid
      AND judged_user_id = @other_party
      AND requestoffer_id = rid
      AND status_id = 1;

    CALL add_audit(308,uid,@other_party,rid,@handler_urdp_id,'From status_id 1');

    -- inform the other user the transaction is canceled.
    CALL put_system_to_user_message(131, @other_party, rid);

    -- inform the acting user they have canceled the transaction
    CALL put_system_to_user_message(136, uid, rid);
    
    -- set audit for removal of handling user due to cancellation
    CALL add_audit(210,uid,@handling_user_id,rid,NULL,NULL); 

    -- recalculate the acting user's ranking
    CALL recalculate_rank_on_user(uid,@other_party, rid, is_thumbs_up);
    IF (is_thumbs_up) THEN
      CALL add_audit(304,uid,@other_party,rid,NULL,NULL);
    ELSE
      CALL add_audit(305,uid, @other_party,rid,NULL,NULL);
    END IF;

  

END

---DELIMITER---

DROP PROCEDURE IF EXISTS put_user_location;   

---DELIMITER---

CREATE PROCEDURE put_user_location
(
  uid INT UNSIGNED, -- if this is > 0, user wants it saved for themselves
  rid INT UNSIGNED, -- if this > 0, it accompanies a requestoffer
  addr1 NVARCHAR(255),
  addr2 NVARCHAR(255),
  my_city NVARCHAR(255),
  my_state NVARCHAR(255),
  my_postcode VARCHAR(30), -- most important value - see http://en.wikipedia.org/wiki/Postal_code for more info!
  my_country NVARCHAR(255)
) 
BEGIN 

  INSERT INTO location 
    (address_line_1, address_line_2, city, state, postal_code, country)
  VALUES
    (addr1, addr2, my_city, my_state, my_postcode, my_country);

  SET @new_location_id = LAST_INSERT_ID();

  -- audit: we just created a new location
  CALL add_audit(401, uid, NULL,NULL,@new_location_id, NULL);

  -- link it to a user, if they asked to save it
  IF uid > 0 THEN
    CALL validate_user_id(uid); -- it's a valid user, right?
    INSERT INTO location_to_user (location_id, user_id)
    VALUES (@new_location_id, uid);

    -- audit that we connected a location to a user
    CALL add_audit(403, uid, NULL, NULL, @new_location_id, NULL);
  END IF;

  -- link it to a requestoffer, if that's the situation
  IF rid > 0 THEN
    CALL validate_requestoffer_id(rid); -- valid requestoffer, right?
    INSERT INTO location_to_requestoffer (location_id, requestoffer_id)
    VALUES (@new_location_id, rid);

    -- audit that we connected a location to a requestoffer
    CALL add_audit(402, NULL, NULL, rid, @new_location_id, NULL);
  END IF;


END

---DELIMITER---

DROP PROCEDURE IF EXISTS assign_location_to_requestoffer;   

---DELIMITER---

CREATE PROCEDURE assign_location_to_requestoffer
(
  lid INT UNSIGNED, -- the location id
  rid INT UNSIGNED -- the requestoffer id
) 
BEGIN 

  SELECT COUNT(*) INTO @lid_count
  FROM location
  WHERE location_id = lid;

  IF (@lid_count <> 1) THEN
      SET @msg = CONCAT(
        'location_id ',lid,' does not exist in the location table');
      SIGNAL SQLSTATE '45000' 
      SET message_text = @msg;
  END IF;

  CALL validate_requestoffer_id(rid); -- valid requestoffer, right?
  INSERT INTO location_to_requestoffer (location_id, requestoffer_id)
  VALUES (lid, rid);

  -- audit: we just attached a location to a requestoffer. 
  CALL add_audit(402, NULL,NULL, rid,NULL, NULL);

END

---DELIMITER---

DROP PROCEDURE IF EXISTS get_my_temporary_msgs;   

---DELIMITER---

CREATE PROCEDURE get_my_temporary_msgs
(
  uid INT UNSIGNED -- the user id
) 
BEGIN 

  CALL validate_user_id(uid);

  -- check that we have some temporary messages for this user
  SELECT COUNT(*) INTO @count_msgs
  FROM temporary_message
  WHERE user_id = uid;

  -- only if we actually have messages, do we keep going
  IF @count_msgs > 0 THEN

    -- select the messages
    SELECT tm.message_localization_id, tmt.text
    FROM temporary_message tm
    LEFT JOIN temporary_message_text tmt
      ON tm.message_id = tmt.message_id
    WHERE tm.user_id = uid;

    -- delete them
    DELETE FROM temporary_message
    WHERE user_id = uid;
  ELSE
    SELECT tm.message_localization_id, tmt.text
    FROM temporary_message tm
    LEFT JOIN temporary_message_text tmt
      ON tm.message_id = tmt.message_id
    WHERE tm.user_id = uid;
  END IF;

END

---DELIMITER---

DROP PROCEDURE IF EXISTS rank_other_user;   

---DELIMITER---

CREATE PROCEDURE rank_other_user
(
  uid INT UNSIGNED, -- the user id
  my_urdp_id INT UNSIGNED, -- the user rank data point id
  is_satis BOOL -- whether the user is satisfied
) 
BEGIN 

  CALL validate_user_id(uid);

  SELECT COUNT(*) INTO @count_valid_urdps
  FROM user_rank_data_point
  WHERE urdp_id = my_urdp_id 
    AND judge_user_id = uid 
    AND status_id = 2;

  -- check that a user rank data point exists with this id.
  IF @count_valid_urdps = 0 THEN
    SET @msg = CONCAT('no urdp having an id of ', my_urdp_id,
     ' status_id of 2 ,judge_user_id of ', uid);
    
    SIGNAL SQLSTATE '45000' 
    SET message_text = @msg;
  END IF;

  SELECT judged_user_id, requestoffer_id INTO @judged_uid, @rid
  FROM user_rank_data_point
  WHERE urdp_id = my_urdp_id;

  UPDATE user_rank_data_point
  SET 
    date_entered = UTC_TIMESTAMP(),  -- last modified date update
    meritorious = is_satis,
    status_id = 3 -- they have provided feedback, they're done.
  WHERE urdp_id = my_urdp_id;

	CALL add_audit(308,uid,@judged_uid,@rid,my_urdp_id,'from status_id 2');

  -- audit that the user is raising or lowering the other party's rank
  IF (is_satis) THEN
    CALL add_audit(304,uid,@judged_uid,@rid,my_urdp_id,NULL);
  ELSE
    CALL add_audit(305,uid,@judged_uid,@rid,my_urdp_id,NULL);
  END IF;

END


---DELIMITER---

DROP PROCEDURE IF EXISTS show_audit_log_info;   

---DELIMITER---

CREATE PROCEDURE show_audit_log_info()
BEGIN

  SELECT a.datetime, u1.username, aa.action, u2.username,
      a.requestoffer_id, a.extra_id, an.notes 
  FROM audit a 
  JOIN audit_actions aa 
    ON aa.action_id = a.audit_action_id 
  LEFT JOIN user u1 
    ON u1.user_id = a.user1_id 
  LEFT JOIN user u2 
    ON u2.user_id = a.user2_id 
  LEFT JOIN audit_notes an 
    ON an.notes_id = a.notes_id
  ORDER BY a.datetime;

END

---DELIMITER---

DROP PROCEDURE IF EXISTS generate_invite_code;   

---DELIMITER---
CREATE PROCEDURE generate_invite_code
(
  my_user_id INT UNSIGNED,
  OUT new_invite_code VARCHAR(100)
)
BEGIN
  SET @code = sha2(concat(UTC_TIMESTAMP(), '_',my_user_id,'_', rand()),256);
  SET new_invite_code = @code;

  INSERT INTO invite_code (user_id, timestamp, value)
  VALUES (my_user_id, UTC_TIMESTAMP(), @code);

  CALL add_audit(109, my_user_id, NULL, NULL, NULL, NULL);
END


