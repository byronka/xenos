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
      ROLLBACK;
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
  uid INT UNSIGNED, -- the user id having his rank recalculated
  rid INT UNSIGNED, -- the requestoffer id
  is_thumbs_up BOOL -- the opinion of the other party
) 
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;

  INSERT INTO user_rank_data_point
  (
    date_entered, 
    user_id, 
    requestoffer_id, 
    is_thumbs_up
  ) 
  VALUES (UTC_TIMESTAMP(), uid, rid, is_thumbs_up);
  
  -- get the number of rankings that are less than 60 days old
  UPDATE user
  SET rank = 
  (
    SELECT AVG(is_thumbs_up)
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
      ROLLBACK;
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
      ROLLBACK;
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
	OUT total_pages INT UNSIGNED
) 
BEGIN 
	SET @search_clauses = ""; -- all our search clauses go on this.
         
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
    CONCAT(@search_clauses, " AND description LIKE CONCAT('%' , @desc , '%') ");
  END IF;



  SET @ruid = ruid;
  SET @get_requestoffer_count = 
     CONCAT('SELECT CEIL(COUNT(*)/10) INTO @total_pages
            FROM requestoffer r 
            JOIN requestoffer_to_category rtc 
              ON rtc.requestoffer_id = r.requestoffer_id 
            JOIN requestoffer_category rc 
              ON rc.category_id = rtc.requestoffer_category_id 
            JOIN user u ON u.user_id = r.requestoffering_user_id 
            WHERE requestoffering_user_id <> @ruid
            ', @search_clauses );

  -- prepare and execute!
	PREPARE get_requestoffer_count FROM @get_requestoffer_count;
	EXECUTE get_requestoffer_count; 

	SET total_pages = @total_pages;

  -- set up paging.  Right now it's always 10 or less rows on the page.
  SET @first_row = page * 10;
  SET @last_row = (page * 10) + 10;

  SET @get_requestoffer = 
     CONCAT('SELECT r.requestoffer_id, 
            r.datetime, 
            r.description, 
            r.status, 
            r.points, 
            u.rank, 
            rsr.user_id AS been_offered,
            r.requestoffering_user_id, 
            r.handling_user_id, 
            GROUP_CONCAT(rc.category_id SEPARATOR ",") 
            AS categories 
            FROM requestoffer r 
            JOIN requestoffer_to_category rtc 
              ON rtc.requestoffer_id = r.requestoffer_id 
            JOIN requestoffer_category rc 
              ON rc.category_id = rtc.requestoffer_category_id 
            JOIN user u ON u.user_id = r.requestoffering_user_id 
            LEFT JOIN requestoffer_service_request rsr
              ON r.requestoffer_id = rsr.requestoffer_id 
              AND rsr.user_id = @ruid
            WHERE requestoffering_user_id <> @ruid AND r.status <> 109
            ', @search_clauses ,'
            GROUP BY r.requestoffer_id 
            ORDER BY r.datetime DESC
            LIMIT ',@first_row,',',@last_row );


  -- prepare and execute!
	PREPARE get_requestoffer FROM @get_requestoffer;
	EXECUTE get_requestoffer; 
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

  call put_requestoffer_trans_section(my_desc, ruid, pts, cats, new_requestoffer_id);
END

---DELIMITER---

DROP PROCEDURE IF EXISTS put_requestoffer_trans_section;

---DELIMITER---

-- this procedure holds just the transactional portion
-- of the code, so we can declare a handler and know it will
-- only apply there.

CREATE PROCEDURE put_requestoffer_trans_section
(
  my_desc NVARCHAR(200),
  ruid INT UNSIGNED, -- requestoffering user id
  pts INT, -- points
  cats VARCHAR(50), -- this cannot be empty or we'll SQLException.
  OUT new_requestoffer_id INT UNSIGNED
)
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;

  START TRANSACTION;

  -- check the user exists
  call validate_user_id(ruid);
  
  -- A) The main part - add the requestoffer to that table.
  SET @status = 109; -- requestoffers always start 'draft'
  INSERT into requestoffer (description, datetime, points,
   status, requestoffering_user_id)
   VALUES (my_desc, UTC_TIMESTAMP(), pts, @status, ruid); 
         
  SET new_requestoffer_id = LAST_INSERT_ID();


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

  -- C) Deduct points from the user
  UPDATE user SET points = points - pts WHERE user_id = ruid;


  -- D) Add an audit
  CALL add_audit(1,ruid,new_requestoffer_id,'');
  CALL add_audit(12,ruid,new_requestoffer_id,'');

  COMMIT;

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

  INSERT into requestoffer_message (
		message, requestoffer_id, from_user_id, to_user_id, timestamp)
  SELECT 
    CONCAT(username,' says:', my_message), 
    rid, 
    fr_uid, 
    @to_user_id,
    UTC_TIMESTAMP()
  FROM user WHERE user_id = fr_uid;

END

---DELIMITER---

DROP PROCEDURE IF EXISTS offer_to_take_requestoffer;

---DELIMITER---

CREATE PROCEDURE offer_to_take_requestoffer
(
  uid INT UNSIGNED,
  rid INT UNSIGNED
) 
BEGIN 

  call validate_requestoffer_id(rid);
  call validate_user_id(uid);

	SELECT COUNT(*) INTO @can_take
	FROM requestoffer r
	WHERE r.status = 76 -- 'open'
	AND r.requestoffer_id = rid;
	
  IF (@can_take <> 1) THEN
      SET @msg = CONCAT('cannot take requestoffer', rid,', not open');
      SIGNAL SQLSTATE '45000' SET message_text = @msg;
  END IF;

  call offer_to_take_requestoffer_trans_section(uid, rid);

END

---DELIMITER---

DROP PROCEDURE IF EXISTS offer_to_take_requestoffer_trans_section;

---DELIMITER---

CREATE PROCEDURE offer_to_take_requestoffer_trans_section
(
  uid INT UNSIGNED,
  rid INT UNSIGNED
) 
BEGIN 
DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;

  START TRANSACTION;

    INSERT INTO requestoffer_service_request 
      (requestoffer_id, user_id, date_created, status)
    VALUES (rid, uid, UTC_TIMESTAMP(), 106); -- starts with 'new' status

    -- Add an audit
    CALL add_audit(7,uid,rid,NULL);

  COMMIT;

END


---DELIMITER---

DROP PROCEDURE IF EXISTS take_requestoffer;

---DELIMITER---

CREATE PROCEDURE take_requestoffer
(
  uid INT UNSIGNED,
  rid INT UNSIGNED
) 
BEGIN 

  call validate_requestoffer_id(rid);
  call validate_user_id(uid);

	SELECT COUNT(*) INTO @can_take
	FROM requestoffer r
	WHERE r.status = 76 -- 'open'
	AND r.requestoffer_id = rid;
	
  IF (@can_take <> 1) THEN
      SET @msg = CONCAT('cannot take requestoffer', rid,', not open');
      SIGNAL SQLSTATE '45000' SET message_text = @msg;
  END IF;

  call take_requestoffer_trans_section(uid, rid);

END

---DELIMITER---

DROP PROCEDURE IF EXISTS take_requestoffer_trans_section;

---DELIMITER---

CREATE PROCEDURE take_requestoffer_trans_section
(
  uid INT UNSIGNED,
  rid INT UNSIGNED
) 
BEGIN 
DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;

  START TRANSACTION;
    UPDATE requestoffer 
    SET 
      status = 78,  -- 'taken'
      handling_user_id = uid  
    WHERE requestoffer_id = rid;

    -- Add an audit
    CALL add_audit(3,uid,rid,NULL);

  COMMIT;

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

  -- get the points on this requestoffer.
  SELECT points into @points
  FROM requestoffer 
  WHERE requestoffer_id = rid;

  -- get a string version of the status
  SELECT requestoffer_status_id, requestoffer_status_value 
  INTO @status_id, @status
  FROM requestoffer_status 
  WHERE requestoffer_status_id = 
    (
      SELECT status
      FROM requestoffer 
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

    call delete_requestoffer_trans_section(uid, rid);
END

---DELIMITER---

DROP PROCEDURE IF EXISTS delete_requestoffer_trans_section;

---DELIMITER---

CREATE PROCEDURE delete_requestoffer_trans_section
(
  uid INT UNSIGNED,
  rid INT UNSIGNED
) 
BEGIN 
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;
  START TRANSACTION;

    -- actually delete the requestoffer here.
    DELETE FROM requestoffer WHERE requestoffer_id = rid;

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

  call create_new_user_trans_section(uname, pword, slt);
END

---DELIMITER---

DROP PROCEDURE IF EXISTS create_new_user_trans_section;

---DELIMITER---

CREATE PROCEDURE create_new_user_trans_section
(
  uname NVARCHAR(50),
  pword VARCHAR(64),
  slt VARCHAR(50)
) 
BEGIN 
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;

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
  OUT new_cookie VARCHAR(200)
) 
BEGIN 

  call validate_user_id(uid);
  call is_non_empty_string('register_user_and_get_cookie','ip',ip);
  call register_user_and_get_cookie_trans_section(uid, ip, new_cookie);
END

---DELIMITER---

DROP PROCEDURE IF EXISTS register_user_and_get_cookie_trans_section;

---DELIMITER---

CREATE PROCEDURE register_user_and_get_cookie_trans_section
(
  uid INT UNSIGNED,
  ip VARCHAR(15), -- e.g. "255.255.255.255"
  OUT new_cookie VARCHAR(200)
) 
BEGIN 
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
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

    SELECT config_value INTO @p_phrase 
    FROM config
    WHERE config_item = 'cookie_passphrase';

    SELECT HEX(
      AES_ENCRYPT(
        @cookie_val_plaintext, SHA2(@p_phrase,512))) INTO new_cookie;

    CALL add_audit(15, uid, uid, NULL);
  COMMIT;

END

---DELIMITER---

DROP PROCEDURE IF EXISTS user_logout;

---DELIMITER---

CREATE PROCEDURE user_logout
(
  uid INT UNSIGNED
) 
BEGIN 
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;

  START TRANSACTION;
    UPDATE user SET is_logged_in = false;
    CALL add_audit(16, uid, uid, NULL);
  COMMIT;
END

---DELIMITER---

DROP PROCEDURE IF EXISTS decrypt_cookie_and_check_validity;

---DELIMITER---

CREATE PROCEDURE decrypt_cookie_and_check_validity
(
  enc_cookie VARCHAR(200), -- The cookie encrypted
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

  IF (@plaintext_cookie IS NULL OR @plaintext_cookie = '')
    THEN
      CALL add_audit(14,NULL,NULL,NULL);
      SET @msg = 
      CONCAT(
				'got null when trying to unencrypt cookie '
        ,SUBSTR(IFNULL(enc_cookie,''), 1, 6)
        ,'...'
        ,' with passphrase: '
        ,SUBSTR(IFNULL(@p_phrase,''), 1, 4)
        , '...'
      );
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
    CALL add_audit(5,@user_id,NULL,@msg);
    SET user_id_out = -1;
  ELSE -- if we got here, the user's info is good.
    UPDATE user SET last_activity_time = UTC_TIMESTAMP() WHERE user_id = @my_user_id;
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

	call validate_requestoffer_id(rid);	
	call validate_user_id(uid);

	SELECT COUNT(*) INTO @is_valid
	FROM requestoffer
	WHERE requestoffering_user_id = uid 
		AND requestoffer_id = rid
		AND status = 78; -- taken

	IF (@is_valid <> 1) THEN
		SET @msg = CONCAT('requestoffer ',
		  rid,' does not have a requestoffering user id of ',
			uid,' for completion, or it is not in the right status (taken)');
		SIGNAL SQLSTATE '45000' SET message_text = @msg;
	END IF;

	-- at this point we are pretty sure it's all cool.
  call complete_ro_transaction_trans_section(uid, rid, satis);
END

---DELIMITER---

DROP PROCEDURE IF EXISTS complete_ro_transaction_trans_section;

---DELIMITER---

-- simply sets the state of a requestoffer to closed.
-- however, first, it checks validity of values it's been given.
CREATE PROCEDURE complete_ro_transaction_trans_section
(
uid INT UNSIGNED, -- the user who owns this requestoffer
rid INT UNSIGNED, -- the requestoffer
satis BOOL -- whether the owner of the RO was satisfied
)
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;

	START TRANSACTION;

	UPDATE requestoffer -- change state of the requestoffer
	SET 
    status = 77, -- 'closed'
    is_satisfied = satis
	WHERE requestoffer_id = rid;

  SELECT handling_user_id INTO @handling_user_id
  FROM requestoffer 
  WHERE requestoffer_id = rid;

  UPDATE user
  SET points = points + 1
  WHERE user_id = @handling_user_id;

	CALL add_audit(11,@handling_user_id,rid,NULL);
  CALL recalculate_rank_on_user(@handling_user_id, rid, satis);
  IF (satis) THEN
    CALL add_audit(6,uid,rid,NULL);
  ELSE
    CALL add_audit(10,uid,rid,NULL);
  END IF;

	COMMIT;
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
	FROM requestoffer
	WHERE requestoffering_user_id = uid 
		AND requestoffer_id = rid
		AND status = 109; -- draft status

	IF (@is_valid <> 1) THEN
		SET @msg = CONCAT('requestoffer ',
		  rid,' does not have a requestoffering user id of ',
			uid,' , or it is not in the right status (draft)');
		SIGNAL SQLSTATE '45000' SET message_text = @msg;
	END IF;

	-- at this point we are pretty sure it's all cool.
  call publish_requestoffer_trans_section(uid, rid);

END
---DELIMITER---

DROP PROCEDURE IF EXISTS publish_requestoffer_trans_section;

---DELIMITER---

-- just set the status to 'open' which will make it available
-- for searching by others and handling.

CREATE PROCEDURE publish_requestoffer_trans_section
(
  uid INT UNSIGNED,
  rid INT UNSIGNED
) 
BEGIN 
DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;

  START TRANSACTION;

    UPDATE requestoffer
    SET status = 76
    WHERE requestoffer_id = rid;

    -- Add an audit
    CALL add_audit(9,uid,rid,NULL);

  COMMIT;

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
DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;

  START TRANSACTION;

  UPDATE user 
  SET password = new_password
  WHERE user_id = uid;

  CALL add_audit(13,exec_uid,uid,NULL);

  COMMIT;

END

---DELIMITER---

DROP PROCEDURE IF EXISTS cancel_taken_requestoffer;   

---DELIMITER---

CREATE PROCEDURE cancel_taken_requestoffer
(
  uid INT UNSIGNED, -- the user making the choice to cancel
  rid INT UNSIGNED, -- the requestoffer
  is_thumbs_up BOOL -- thumbs up on the cancellation
) 
BEGIN 
DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;

  START TRANSACTION;
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
    SET 
      status = 76 -- OPEN
      ,handling_user_id = NULL  -- clear out the handling user
    WHERE requestoffer_id = rid;

    -- inform the other user the transaction is canceled.
    CALL put_system_to_user_message(131, @other_party, rid);

    -- inform the acting user they have canceled the transaction
    CALL put_system_to_user_message(136, uid, rid);
    
    -- set audit for removal of handling user - 
    -- either way, they get removed as handler
    CALL add_audit(19,uid,@handling_user_id,NULL); 

    -- recalculate the ranking on the other party
    CALL recalculate_rank_on_user(@other_party, rid, is_thumbs_up);
    IF (is_thumbs_up) THEN
      CALL add_audit(17,uid,rid,NULL);
    ELSE
      CALL add_audit(18, uid, rid,NULL);
    END IF;

  COMMIT;

END
