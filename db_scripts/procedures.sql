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
  DECLARE msg VARCHAR(100);
  IF (text_value IS NULL OR text_value = '') THEN
      SET msg = CONCAT(
        fieldname,' value in ',procname,' was empty or null');
      
      SIGNAL SQLSTATE '45000' 
      SET message_text = msg;
  END IF;
END

---DELIMITER---

DROP PROCEDURE IF EXISTS recalculate_rank_on_user;

---DELIMITER---

-- This procedure calculates and applies the rank calculation for users.
-- it operates on a 6-month rolling schedule.  
-- user rank data points that are more than 6 months old 
-- will not be applied in this average.

-- this procedure does not double-check the user or requestoffer id, 
-- because it is assumed that by the time the calling procedure 
-- gets to this one,
-- that will have already been validated.

CREATE PROCEDURE recalculate_rank_on_user
(
  uid INT UNSIGNED, -- the user id having his rank recalculated
  is_thumbs_up BOOL -- the opinion of the other party
) 
BEGIN
  DECLARE ladder INT;

  SELECT rank_ladder INTO ladder
  FROM user
  WHERE user_id = uid;

  -- adjust the ranking ladder.
  IF is_thumbs_up = 1 THEN -- ladder only goes up one at a time
    IF ladder < 15 THEN
      UPDATE user SET rank_ladder = rank_ladder + 1 WHERE user_id = uid;
    END IF;
  ELSEIF is_thumbs_up = 0 THEN -- ladder drops 3 at a time
    IF ladder - 3 < -3 THEN
      UPDATE user SET rank_ladder = -3 WHERE user_id = uid;
    ELSE
      UPDATE user SET rank_ladder = rank_ladder - 3 WHERE user_id = uid;
    END IF;
  END IF;

  -- get the number of rankings that are less than 6 months old
  -- and recalculate the average
    UPDATE user
    SET 
      rank_average = 
        (
          SELECT AVG(meritorious)
          FROM user_rank_data_point
          WHERE 
            judged_user_id = uid
            AND
            status_id = 3 -- feedback is complete
            AND
            UTC_TIMESTAMP() < (date_entered + INTERVAL 6 MONTH)
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
  DECLARE valid_rid INT UNSIGNED;
  DECLARE msg VARCHAR(100);

  SELECT COUNT(*) INTO valid_rid 
  FROM requestoffer 
  WHERE requestoffer_id = rid;

  IF (valid_rid <> 1) THEN
      SET msg = CONCAT('requestoffer does not exist in the system: ', 
        rid);
      
      SIGNAL SQLSTATE '45000' 
      SET message_text = msg;
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
  DECLARE valid_uid INT;
  DECLARE msg VARCHAR(100);

  SELECT COUNT(*) INTO valid_uid 
  FROM user 
  WHERE user_id = uid;

  IF (valid_uid <> 1) THEN
      SET msg = CONCAT('user does not exist in the system: ', 
        uid);
      
      SIGNAL SQLSTATE '45000' 
      SET message_text = msg;
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
      datetime, audit_action_id, user1_id, 
      user2_id, requestoffer_id, extra_id, notes_id)
      VALUES(
        UTC_TIMESTAMP(),     -- the current time and date
        my_audit_action_id,  -- the action, e.g. create, delete, etc.
        my_user1_id,          -- the user causing the action
        my_user2_id,          -- the user causing the action
        my_requestoffer_id,        -- the thing being acted upon
        my_extra_id,              -- extra id's, for example, groups
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
  my_startdate VARCHAR(10),
  my_enddate VARCHAR(10),
  my_status VARCHAR(50), -- can be many INT's separated by commas
  my_categories VARCHAR(50), -- several INT's separated by commas.
  my_user_id VARCHAR(50), -- can be many INT's separated by commas
  page INT UNSIGNED,
  my_desc NVARCHAR(50),
  my_postcode VARCHAR(50),  -- the postcode they are searching
  my_max_dist DOUBLE,
	OUT total_pages INT UNSIGNED
) 
BEGIN 
  DECLARE first_row, last_row INT;
  DECLARE my_country_id, my_postal_code_id INT;

  SELECT country_id, postal_code_id INTO my_country_id, my_postal_code_id
  FROM user
  WHERE user_id = ruid;

  -- set up paging.  Right now it's always 10 or less rows on the page.
  SET first_row = page * 10;
  SET last_row = (page * 10) + 10;

  -- this is to get a user's own draft requestoffers
  (
    SELECT SQL_CALC_FOUND_ROWS r.requestoffer_id, 
    r.datetime, 
    r.description, 
    rs.status, 
    r.points, 
    u.rank_average, 
    u.rank_ladder,
    rsr.user_id AS been_offered,
    r.requestoffering_user_id, 
    r.handling_user_id, 
    r.category,
    pc.postal_code,
    pcd.details,
    calc_approx_dist(r.country_id, r.postal_code_id, my_country_id, my_postal_code_id) AS distance
    FROM requestoffer r 
    JOIN requestoffer_state rs
      ON rs.requestoffer_id = r.requestoffer_id
    JOIN user u ON u.user_id = r.requestoffering_user_id 
    LEFT JOIN requestoffer_service_request rsr
      ON r.requestoffer_id = rsr.requestoffer_id 
        AND rsr.user_id = ruid AND rsr.status = 106 -- 106 is "NEW"
    LEFT JOIN postal_codes pc
      ON pc.postal_code_id = r.postal_code_id 
        AND pc.country_id = r.country_id
    LEFT JOIN postal_code_details pcd
      ON pcd.postal_code_id = r.postal_code_id 
        AND pcd.country_id = r.country_id
    WHERE rs.status = 109 AND r.requestoffering_user_id = ruid

    AND

    -- searching by status
    CASE WHEN my_status <> '' THEN
    rs.status IN (my_status)
    ELSE TRUE
    END

    AND 

    -- searching by categories
    CASE WHEN my_categories <> '' THEN
    r.category IN (my_categories)
    ELSE TRUE
    END

    AND

    -- searching by requestoffering user
    CASE WHEN my_user_id <> '' THEN
    requestoffering_user_id IN (my_user_id)
    ELSE TRUE
    END

    AND

    -- searching by dates
    CASE WHEN my_startdate <> '' AND my_enddate <> '' THEN
    r.datetime >= my_startdate AND r.datetime <= my_enddate
    WHEN my_startdate <> '' THEN
    r.datetime >= my_startdate
    WHEN my_enddate <> '' THEN
    r.datetime <= my_enddate
    ELSE TRUE
    END

    AND

    -- searching by description
    CASE WHEN description <> '' THEN
    description LIKE CONCAT('%' , my_desc , '%')
    ELSE TRUE
    END

    AND

    -- searching by postcode
    CASE WHEN my_postcode <> '' THEN
    pc.postal_code = my_postcode
    ELSE TRUE
    END

    HAVING
    -- searching by distance
    CASE WHEN my_max_dist > 0.0 THEN
    distance <= my_max_dist
    ELSE TRUE
    END

  )

  UNION ALL


  -- get everything but a user's own draft requestoffers
  (
    SELECT r.requestoffer_id, 
    r.datetime, 
    r.description, 
    rs.status, 
    r.points, 
    u.rank_average, 
    u.rank_ladder,
    rsr.user_id AS been_offered,
    r.requestoffering_user_id, 
    r.handling_user_id, 
    r.category,
    pc.postal_code,
    pcd.details,
    calc_approx_dist(r.country_id, r.postal_code_id, my_country_id, my_postal_code_id) AS distance
    FROM requestoffer r 
    JOIN requestoffer_state rs
      ON rs.requestoffer_id = r.requestoffer_id
    JOIN user u ON u.user_id = r.requestoffering_user_id 
    LEFT JOIN requestoffer_service_request rsr
      ON r.requestoffer_id = rsr.requestoffer_id 
    AND rsr.user_id = ruid AND rsr.status = 106 -- 106 is "NEW"
    LEFT JOIN postal_codes pc
      ON pc.postal_code_id = r.postal_code_id 
        AND pc.country_id = r.country_id
    LEFT JOIN postal_code_details pcd
      ON pcd.postal_code_id = r.postal_code_id 
        AND pcd.country_id = r.country_id
    WHERE rs.status <> 109 -- draft

    AND

    -- searching by status
    CASE WHEN my_status <> '' THEN
    rs.status IN (my_status)
    ELSE TRUE
    END

    AND 

    -- searching by categories
    CASE WHEN my_categories <> '' THEN
    r.category IN (my_categories)
    ELSE TRUE
    END

    AND

    -- searching by requestoffering user
    CASE WHEN my_user_id <> '' THEN
    requestoffering_user_id IN (my_user_id)
    ELSE TRUE
    END

    AND

    -- searching by dates
    CASE WHEN my_startdate <> '' AND my_enddate <> '' THEN
    r.datetime >= my_startdate AND r.datetime <= my_enddate
    WHEN my_startdate <> '' THEN
    r.datetime >= my_startdate
    WHEN my_enddate <> '' THEN
    r.datetime <= my_enddate
    ELSE TRUE
    END

    AND

    -- searching by description
    CASE WHEN description <> '' THEN
    description LIKE CONCAT('%' , my_desc , '%')
    END

    AND

    -- searching by postcode
    CASE WHEN my_postcode <> '' THEN
    pc.postal_code = my_postcode
    ELSE TRUE
    END

    HAVING
    -- searching by distance
    CASE WHEN my_max_dist > 0.0 THEN
    distance <= my_max_dist
    ELSE TRUE
    END
  )
  ORDER BY datetime DESC
  LIMIT first_row,last_row; 

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
  cat INT, -- category - this cannot be empty or we'll SQLException.
  coid INT, -- the country id - used to get location
  poid INT, -- the postal code id - used to get location
  OUT new_requestoffer_id INT UNSIGNED
) 
BEGIN 
  DECLARE cat_err_msg VARCHAR(100);

  IF (cat <= 0) THEN
      SET cat_err_msg = 'no category set- not allowed in this proc';
      SIGNAL SQLSTATE '45000' set message_text = cat_err_msg;
  END IF;

  -- check the user exists
  call validate_user_id(ruid);
  
  -- A) The main part - add the requestoffer to that table.
  INSERT into requestoffer (description, datetime, points, category, 
    requestoffering_user_id, country_id, postal_code_id)
   VALUES (my_desc, UTC_TIMESTAMP(), pts, cat, ruid, coid, poid); 
         
  SET new_requestoffer_id = LAST_INSERT_ID();

  -- 109 requestoffers always start 'draft'

  INSERT INTO requestoffer_state (requestoffer_id, status, datetime)
  VALUES (new_requestoffer_id, 109, UTC_TIMESTAMP());


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
-- the context of a requestoffer.  Can be done while the
-- requestoffer is being handled or by offerers to handle in
-- OPEN status.

CREATE PROCEDURE put_message
(
  my_message NVARCHAR(200),
  fr_uid INT UNSIGNED, -- "from" user id - the person sending the message
  to_uid INT UNSIGNED,-- "to" user id - the user the message is intended for
  rid INT UNSIGNED -- the requestoffer id
) 
BEGIN 
  DECLARE full_msg NVARCHAR(200);
  DECLARE from_username NVARCHAR(200);
  DECLARE to_username NVARCHAR(200);

  CALL is_non_empty_string('put_message','my_message',my_message);
  CALL validate_requestoffer_id(rid);
  CALL validate_user_id(fr_uid);
  CALL validate_user_id(to_uid);

  SELECT username INTO from_username
  FROM user WHERE user_id = fr_uid;
  SELECT username INTO to_username
  FROM user WHERE user_id = to_uid;

  SELECT CONCAT(from_username,' says to ',to_username,': ', my_message) INTO full_msg;

  INSERT into requestoffer_message (
		message, requestoffer_id, from_user_id, to_user_id, timestamp)
  VALUES (full_msg, rid, fr_uid, to_uid, UTC_TIMESTAMP());

  CALL put_temporary_message(to_uid, NULL, full_msg);

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
  DECLARE can_take BOOLEAN;
  DECLARE msg VARCHAR(100);
  DECLARE ro_owner INT UNSIGNED;

  call validate_requestoffer_id(rid);
  call validate_user_id(uid);

	SELECT COUNT(*) INTO can_take
	FROM requestoffer_state rs
	WHERE rs.status = 76 -- 'open'
	AND rs.requestoffer_id = rid;
	
  IF (can_take <> 1) THEN
      SET msg = CONCAT('cannot take requestoffer', rid,', not open');
      SIGNAL SQLSTATE '45000' SET message_text = msg;
  END IF;

  INSERT INTO requestoffer_service_request 
    (requestoffer_id, user_id, date_created, status)
  VALUES (rid, uid, UTC_TIMESTAMP(), 106); -- starts with 'new' status

	SELECT r.requestoffering_user_id INTO ro_owner
	FROM requestoffer r
	WHERE r.requestoffer_id = rid;

  -- send a message to the owner of that requestoffer
  CALL put_system_to_user_message(148, ro_owner, rid);

  -- Add an audit that this user is offering to take the requestoffer
  CALL add_audit(209,uid,ro_owner,rid,NULL,NULL);

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
  DECLARE can_take BOOLEAN;
  DECLARE msg VARCHAR(100);
  DECLARE urdp_id, owner_id INT;

  call validate_requestoffer_id(rid);
  call validate_user_id(uid);

	SELECT COUNT(*) INTO can_take
	FROM requestoffer_state rs
	WHERE rs.status = 76 -- 'open'
	AND rs.requestoffer_id = rid;
	
  IF (can_take <> 1) THEN
      SET msg = CONCAT('cannot take requestoffer', rid,', not open');
      SIGNAL SQLSTATE '45000' SET message_text = msg;
  END IF;

  -- modify the requestoffer to indicate this user has taken it
  UPDATE requestoffer 
  SET handling_user_id = uid  
  WHERE requestoffer_id = rid;

  UPDATE requestoffer_state
  SET status = 78 -- "taken", datetime = UTC_TIMESTAMP()
  WHERE requestoffer_id = rid;

  -- get the owner's user id
  SELECT requestoffering_user_id INTO owner_id
  FROM requestoffer
  WHERE requestoffer_id = rid;
  
  -- indicate that this user is in "ACTIVE" state on this requestoffer
  -- default to "true" for meritorious, so if the feedback never happens,
  -- it is assumed that things went ok.
  INSERT INTO user_rank_data_point
  (date_entered, judge_user_id, judged_user_id, requestoffer_id, status_id, is_inside_window, meritorious)
  VALUES 
  (UTC_TIMESTAMP(), owner_id,uid, rid, 1, 1, 1), 
  (UTC_TIMESTAMP(), uid,owner_id, rid, 1, 1, 1); 

  SET urdp_id = LAST_INSERT_ID();

  -- Add an audit that these users are going into ACTIVE state
  CALL add_audit(306,uid,owner_id,rid,urdp_id,NULL);
  CALL add_audit(306,owner_id,uid,rid,urdp_id,NULL);

  -- change the service request to accepted for the winning user
  UPDATE requestoffer_service_request 
  SET 
    status = 107, -- "accepted"
    date_modified = UTC_TIMESTAMP()
  WHERE requestoffer_id = rid AND user_id = uid AND status = 106;

  -- Add an audit for the winning user
  CALL add_audit(207,owner_id,uid,rid,NULL,NULL);

  -- send a message to the winnng user
  CALL put_system_to_user_message(132, uid, rid);

  -- Add an audit for the losing users
  INSERT INTO audit (
    datetime, audit_action_id, user1_id, user2_id, requestoffer_id)
  SELECT UTC_TIMESTAMP(), 208, owner_id, user_id, rid
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
  DECLARE status_id INT;
  DECLARE status VARCHAR(50);
  DECLARE msg,delete_msg VARCHAR(100);

  -- check that the requestoffer exists
  call validate_requestoffer_id(rid);
  call validate_user_id(uid);


  -- get a string version of the status
  SELECT requestoffer_status_id, requestoffer_status_value 
  INTO status_id, status
  FROM requestoffer_status 
  WHERE requestoffer_status_id = 
    (
      SELECT status
      FROM requestoffer_state
      WHERE requestoffer_id = rid
    );

  IF (status_id <> 76 AND status_id <> 109) THEN
    SET msg = CONCAT('not possible to delete request ',rid,
    ' since it is not open or draft');
    SIGNAL SQLSTATE '45000' SET message_text = msg;
  END IF;

  -- get a message for the deletion audit
  SELECT CONCAT(
      SUBSTR(description,1,30),
      '|',
      'created:', SUBSTR(datetime,1,10),
      '|',
      'pts:', points,
      '|',
      'st:',status) INTO delete_msg
    FROM requestoffer
    WHERE requestoffer_id = rid;

    
      -- actually delete the requestoffer here.
      DELETE FROM requestoffer WHERE requestoffer_id = rid;


      -- Add an audit about deleting the requestoffer
      CALL add_audit(205,uid,NULL,rid,NULL,delete_msg);

    
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

  -- audit that the requestoffer was reverted
  call add_audit(206, uid, uid, rid, NULL, NULL);

  -- give point back to the user
  UPDATE user 
  SET points = points + 1
  WHERE user_id = uid;

  -- audit that the point was returned to the user who owns the requestoffer
  call add_audit(303, 1, uid, rid, NULL, NULL);

  -- audit that we are rejecting users who had offered to handle this
  INSERT INTO audit (
    datetime, audit_action_id, user1_id, user2_id, requestoffer_id)
  SELECT UTC_TIMESTAMP(), 211, uid, rsr.user_id, rid
  FROM requestoffer_service_request rsr
  WHERE rsr.status = 106 AND rsr.requestoffer_id = rid; -- 106 is "new"

  -- set associated service request statuses to "rejected"
  -- if they aren't already rejected.
  UPDATE requestoffer_service_request rsr 
  SET rsr.status = 108, 
  rsr.date_modified = UTC_TIMESTAMP() -- 108 is "REJECTED"
  WHERE rsr.status = 106 AND rsr.requestoffer_id = rid; -- 106 is "new"


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
  DECLARE count_email_username INT;
  DECLARE my_ipaddr VARCHAR(50);
  DECLARE msg NVARCHAR(150);
  DECLARE message NVARCHAR(150);
  DECLARE the_user_name NVARCHAR(15);
  DECLARE new_user_id INT UNSIGNED;
  DECLARE inviter_id INT UNSIGNED;

  -- make sure the username and password and salt are non-empty
  call is_non_empty_string('create_new_user','uname',uname);
  call is_non_empty_string('create_new_user','pword',pword);
  call is_non_empty_string('create_new_user','slt',slt);

  -- check that this username doesn't match an email in the system
  SELECT COUNT(*) INTO count_email_username
  FROM user 
  WHERE uname = user.email;
    
  IF (count_email_username > 0) THEN
      SET msg = CONCAT(
				'username matches existing email during insert: ', uname );
      
      SIGNAL SQLSTATE '45000' 
      SET message_text = msg;
  END IF;

  -- (this next part is disabled during the beta.  Turn it back
  -- on in the final product.)
  -- check that the invite code is valid
  -- SELECT user_id INTO inviter_id
  -- FROM invite_code
  -- WHERE value = my_invite_code;

  -- (remove this next part in the final product.  Here, we'll say
  -- that the system user is the inviter, during the beta only.)
  SELECT 1 INTO inviter_id;

  -- (this whole section, for checking invite code, is being
  -- commented out during beta.)
  -- guard against the count of valid invite codes being zero
  -- we will use this error message back on the client side.
  -- IF inviter_id IS NULL THEN
  --     -- if the ip address is too long, truncate
  --     IF LENGTH(ipaddr) > 20 THEN
  --       SET my_ipaddr = CONCAT(SUBSTR(ipaddr,1,20),'...');
  --     ELSE
  --       SET my_ipaddr = ipaddr;
  --     END IF;

  --     -- if the username is too long, truncate
  --     IF LENGTH(uname) > 10 THEN
  --       SET the_user_name = CONCAT(SUBSTR(uname,1,10),'...');
  --     ELSE
  --       SET the_user_name = uname;
  --     END IF;

  --     SET message = CONCAT('ip: ',my_ipaddr,' name: ',the_user_name,
  --       ' invite code: ', SUBSTR(my_invite_code,1,10),'...');

  --     -- audit that they failed the invite-code check
  --     CALL add_audit(110,NULL,NULL,NULL,NULL,message);
  --     
  --     -- return an error so we can indicate that on the client
  --     SIGNAL SQLSTATE '45000' 
  --     SET message_text = 'invite code is invalid';
  -- END IF;


  -- add the user
  INSERT INTO user (username, password, salt, 
      date_created, last_ip_logged_in, inviter)
  VALUES (uname, pword, slt, UTC_TIMESTAMP(), ipaddr, inviter_id);

  SET new_user_id = LAST_INSERT_ID();

  -- (we don't have invite codes during beta.  This section commented out)
  -- delete that invite code
  -- DELETE FROM invite_code
  -- WHERE value = my_invite_code;

  -- Add an audit about registering a new user
  CALL add_audit(101,new_user_id,inviter_id,NULL,NULL,ipaddr);

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
  DECLARE my_timestamp DATETIME;
  DECLARE cookie_val_plaintext,p_phrase VARCHAR(130);

  call validate_user_id(uid);
  call is_non_empty_string('register_user_and_get_cookie','ip',ip);

  SELECT UTC_TIMESTAMP() INTO my_timestamp;

  -- set registration values
  UPDATE user
  SET is_logged_in = 1, last_time_logged_in = my_timestamp,
  last_ip_logged_in = ip
  WHERE user_id = uid;

  -- takes the user id, the ip, and a timestamp and encrypts
  -- that into a string value which we will use as the cookie.
  -- the value to encrypt will look like this:
  -- USER_ID|IP|TIMESTAMP
  -- for example:
  -- "123|108.91.12.198|2014-01-02 13:04:19"
  -- Notice the delimiter is a pipe symbol.
  SELECT CONCAT(uid,'|',ip,'|',my_timestamp) 
    INTO cookie_val_plaintext;

  SELECT config_value INTO p_phrase 
  FROM config
  WHERE config_item = 'cookie_passphrase';

  SELECT HEX(
    AES_ENCRYPT(
      cookie_val_plaintext, SHA2(p_phrase,512))) INTO new_cookie;

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
  DECLARE pass NVARCHAR(15);
  DECLARE message NVARCHAR(100);
  DECLARE ip_msg VARCHAR(100);
  DECLARE last_ip VARCHAR(50);

  SELECT user_id, last_ip_logged_in into user_id_found, last_ip
  FROM user
  WHERE username = their_username AND BINARY password = their_password;

  -- audit that their username / password didn't match anything in our db
  IF user_id_found IS null THEN
    SET pass = SUBSTR(IFNULL(their_password,'WAS_NULL'), 1, 10);
    SET message = CONCAT('ip: ',their_ip_address,' name: ',their_username,' pass: ',pass,'...');
    CALL add_audit(104,NULL,NULL,NULL,NULL,message);
  END IF;

  -- audit that they are coming from a different ip now.
  IF last_ip <> their_ip_address THEN
    SET ip_msg = CONCAT('old ip: ',last_ip,' new_ip:',their_ip_address);
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
  DECLARE plaintext_cookie,msg,p_phrase VARCHAR(120);
  DECLARE my_user_id INT UNSIGNED;
  DECLARE found_users,user_id_length INT;
  DECLARE ip_address VARCHAR(50);
  DECLARE my_timestamp VARCHAR(40);

  call is_non_empty_string(
    'decrypt_cookie_and_check_validity','enc_cookie',enc_cookie);

  SELECT config_value INTO p_phrase 
  FROM config
  WHERE config_item = 'cookie_passphrase';

  -- See register_user_and_get_cookie for more info on cookie format
  -- if this fails, it should put a null into plaintext_cookie
  SELECT 
    AES_DECRYPT(UNHEX(enc_cookie), SHA2(p_phrase,512)) 
    INTO plaintext_cookie;

  -- if there's an error...
  IF (plaintext_cookie IS NULL OR plaintext_cookie = '')
    THEN
      SET msg = 
      CONCAT(
				'got null when trying to unencrypt cookie '
        ,SUBSTR(IFNULL(enc_cookie,''), 1, 6)
        ,'...'
        ,' with passphrase: '
        ,SUBSTR(IFNULL(p_phrase,''), 1, 4)
        , '...'
        ,'Ip: '
        ,IFNULL(ip_address,'warning: no ip address given')
      );
      CALL add_audit(107,NULL,NULL,NULL,NULL,msg);
      SIGNAL SQLSTATE '45000' SET message_text = msg;
  END IF;

  SELECT SUBSTRING_INDEX(plaintext_cookie, '|',1) INTO my_user_id;
  SELECT LENGTH(
    SUBSTRING_INDEX(plaintext_cookie, '|',1)) INTO user_id_length;
  SELECT SUBSTR(
    SUBSTRING_INDEX(
      plaintext_cookie, '|',2),user_id_length+2) INTO ip_address;
  SELECT SUBSTRING_INDEX(plaintext_cookie, '|',-1) INTO my_timestamp;
  
  SELECT COUNT(*) INTO found_users
  FROM user
  WHERE 
    is_logged_in = 1 
    AND last_time_logged_in = my_timestamp
    AND user_id = my_user_id
    AND last_ip_logged_in = ip_address;

  IF (found_users <> 1) THEN
    SET msg = CONCAT(IFNULL(found_users,-1), ' users found. user_id: '
      , IFNULL(my_user_id , -1)
      ,' ip_address: ',IFNULL(ip_address, '')
      ,' timestamp: ',IFNULL(my_timestamp, ''));
    CALL add_audit(106,NULL,NULL,NULL,NULL,msg);
    SET user_id_out = -1;
  -- if we got here, the user's info is good.
  ELSEIF update_last_activity = 1 THEN
    -- here, we update the last activity time.  This is used by
    -- the timeout mechanism to see if the user has gone idle, and needs
    -- to be logged out automatically.
    UPDATE user 
    SET last_activity_time = UTC_TIMESTAMP() 
    WHERE user_id = my_user_id;
    SET user_id_out = my_user_id;
  ELSE
    SET user_id_out = my_user_id;
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
rid INT UNSIGNED -- the requestoffer
)
BEGIN
  DECLARE is_valid BOOLEAN;
  DECLARE msg VARCHAR(120);
  DECLARE the_handling_user_id INT UNSIGNED;
  DECLARE owner_urdp_id, handler_urdp_id INT;

  -- first some guard clauses
	call validate_requestoffer_id(rid);	
	call validate_user_id(uid);

  -- make sure a valid requestoffer exists for completion
	SELECT COUNT(*) INTO is_valid
	FROM requestoffer r
  JOIN requestoffer_state rs ON rs.requestoffer_id = r.requestoffer_id
	WHERE r.requestoffering_user_id = uid 
		AND r.requestoffer_id = rid
		AND rs.status = 78; -- taken

	IF (is_valid <> 1) THEN
		SET msg = CONCAT('requestoffer ',
		  rid,' does not have a requestoffering user id of ',
			uid,' for completion, or it is not in the right status (taken)');
		SIGNAL SQLSTATE '45000' SET message_text = msg;
	END IF;

	-- at this point we are pretty sure it's all cool.

  -- notice that we don't remove the handling user, that's intentional.
  -- if we've completed this requestoffer, then it's done, it's not going
  -- up again to be reused.  We can go ahead and leave this information
  -- here as an auditing-type artifact.
	UPDATE requestoffer_state -- change state of the requestoffer
	SET status = 77, -- 'closed'
  datetime = UTC_TIMESTAMP()
	WHERE requestoffer_id = rid;

  SELECT handling_user_id INTO the_handling_user_id
  FROM requestoffer
  WHERE requestoffer_id = rid;

  -- audit that the owner is making this RO complete
	CALL add_audit(203,uid,the_handling_user_id,rid,NULL,NULL);

  -- get the handling user's id
  SELECT handling_user_id INTO the_handling_user_id
  FROM requestoffer 
  WHERE requestoffer_id = rid;

  -- give the handling user their points
  UPDATE user
  SET points = points + 1
  WHERE user_id = the_handling_user_id;

  -- only the owner of the requestoffer can "COMPLETE" one.
  
  -- we need the servicer to provide input, so...
  -- change the state for the servicer to COMPLETE_FEEDBACK_POSSIBLE

  SELECT urdp_id INTO handler_urdp_id
  FROM user_rank_data_point
  WHERE
    judge_user_id = the_handling_user_id 
    AND judged_user_id = uid
    AND requestoffer_id = rid
    AND status_id = 1;

  UPDATE user_rank_data_point
    SET 
      date_entered = UTC_TIMESTAMP(),  -- last modified date update
      status_id = 2 -- move them to needing to provide feedback
    WHERE 
    urdp_id = handler_urdp_id;

  -- audit that we're putting the handling user in COMPLETE_FEEDBACK_POSSIBLE
	CALL add_audit(307,the_handling_user_id,uid,rid,handler_urdp_id,'From status_id 1');

  SELECT urdp_id INTO owner_urdp_id
  FROM user_rank_data_point
  WHERE
    judge_user_id = uid
    AND judged_user_id = the_handling_user_id
    AND requestoffer_id = rid
    AND status_id = 1;

  UPDATE user_rank_data_point
    SET 
      date_entered = UTC_TIMESTAMP(),  -- last modified date update
      status_id = 2 -- COMPLETE_FEEDBACK_POSSIBLE
    WHERE 
      urdp_id = owner_urdp_id;


  -- Audit that we're putting the owner into COMPLETE_FEEDBACK_POSSIBLE
	CALL add_audit(307,uid,the_handling_user_id,rid,owner_urdp_id,'From status_id 1');

  -- audit that the handling user earned a point off this
	CALL add_audit(302,uid,the_handling_user_id,rid,NULL,NULL);

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
  DECLARE is_valid BOOLEAN;
  DECLARE msg VARCHAR(120);
  DECLARE pts INT;

	call validate_requestoffer_id(rid);	
	call validate_user_id(uid);

	SELECT COUNT(*) INTO is_valid
	FROM requestoffer r
  JOIN requestoffer_state rs ON rs.requestoffer_id = r.requestoffer_id
	WHERE r.requestoffering_user_id = uid 
		AND r.requestoffer_id = rid
		AND rs.status = 109; -- draft status

	IF (is_valid <> 1) THEN
		SET msg = CONCAT('requestoffer ',
		  rid,' does not have a requestoffering user id of ',
			uid,' , or it is not in the right status (draft)');
		SIGNAL SQLSTATE '45000' SET message_text = msg;
	END IF;

	-- at this point we are pretty sure it's all cool.

  UPDATE requestoffer_state
  SET status = 76, datetime = UTC_TIMESTAMP()
  WHERE requestoffer_id = rid;

  -- Add an audit that the user published their requestoffer
  CALL add_audit(202,uid,NULL,rid,NULL,NULL);

  SELECT points INTO pts 
  FROM requestoffer 
  WHERE requestoffer_id = rid;

  -- Deduct points from the user
  UPDATE user SET points = points - pts WHERE user_id = uid;

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
  rid INT UNSIGNED -- the requestoffer
) 
BEGIN 
  DECLARE the_handling_user_id, the_requestoffering_user_id INT UNSIGNED;
  DECLARE other_party INT UNSIGNED;
  DECLARE handler_urdp_id INT;

  CALL validate_user_id(uid);
  CALL validate_requestoffer_id(rid);

  -- get the other party on this requestoffer.
  -- if we are the owner, get the handler, and vice versa
  SELECT handling_user_id, requestoffering_user_id 
  INTO the_handling_user_id, the_requestoffering_user_id
  FROM requestoffer
  WHERE requestoffer_id = rid;
  
  -- here we will set the id for the other member
  -- of this transaction
  IF (uid = the_handling_user_id) THEN
    SET other_party = the_requestoffering_user_id;
  ELSE
    SET other_party = the_handling_user_id;
  END IF;

  -- change the status on the requestoffer
  UPDATE requestoffer
  SET handling_user_id = NULL  -- clear out the handling user
  WHERE requestoffer_id = rid;

  UPDATE requestoffer_state
  SET status = 76 -- "OPEN", datetime = UTC_TiMESTAMP()
  WHERE requestoffer_id = rid;

  -- audit that this user canceled
  CALL add_audit(204,uid,other_party,rid,NULL, NULL);

  SELECT urdp_id INTO handler_urdp_id
  FROM user_rank_data_point
  WHERE judge_user_id = other_party
    AND judged_user_id = uid
    AND requestoffer_id = rid
    AND status_id = 1;

  UPDATE user_rank_data_point
    SET 
      date_entered = UTC_TIMESTAMP(),  -- last modified date update
      status_id = 2 -- move them to needing to provide feedback
    WHERE urdp_id = handler_urdp_id;

    -- audit that the other party is going into COMPLETE_FEEDBACK_POSSIBLE
  CALL add_audit(307,other_party,uid,rid,handler_urdp_id,'From status_id 1');

  UPDATE user_rank_data_point
    SET 
      date_entered = UTC_TIMESTAMP(),  -- last modified date update
      status_id = 2 -- they have provided feedback, they're done.
    WHERE judge_user_id = uid
    AND judged_user_id = other_party
    AND requestoffer_id = rid
    AND status_id = 1;

    -- audit that the cancelling user is going into COMPLETE_FEEDBACK_POSSIBLE
  CALL add_audit(307,uid,other_party,rid,handler_urdp_id,'From status_id 1');

  -- inform the other user the transaction is canceled.
  CALL put_system_to_user_message(131, other_party, rid);

  -- inform the acting user they have canceled the transaction
  CALL put_system_to_user_message(136, uid, rid);
  
  -- set audit for removal of handling user due to cancellation
  CALL add_audit(210,uid,the_handling_user_id,rid,NULL,NULL); 

END


---DELIMITER---

DROP PROCEDURE IF EXISTS get_my_temporary_msgs_for_website;   

---DELIMITER---

CREATE PROCEDURE get_my_temporary_msgs_for_website
(
  uid INT UNSIGNED -- the user id
) 
BEGIN 

    -- select the messages that haven't been seen
    SELECT tm.message_localization_id, tmt.text
    FROM temporary_message tm
    LEFT JOIN temporary_message_text tmt
      ON tm.message_id = tmt.message_id
    WHERE tm.user_id = uid 
      AND tm.has_displayed_in_website = 0;

    -- mark them as seen on website
    UPDATE temporary_message
    SET has_displayed_in_website = 1
    WHERE user_id = uid 
      AND has_displayed_in_website = 0;

END

---DELIMITER---

DROP PROCEDURE IF EXISTS get_my_temporary_msgs_for_email;   

---DELIMITER---

-- this gets all the temporary messages for everyone, and marks
-- them all as having been emailed out.  It is used by a program
-- that packages up all the messages into bundles per user and emails
-- them out.

CREATE PROCEDURE get_my_temporary_msgs_for_email () 
BEGIN 

    -- select the messages that haven't been emailed to a user
    SELECT u.email, tm.user_id, tm.message_localization_id, tmt.text
    FROM temporary_message tm
    LEFT JOIN temporary_message_text tmt
      ON tm.message_id = tmt.message_id
    JOIN user u ON u.user_id = tm.user_id
    WHERE 
      tm.has_emailed = 0
    AND 
      u.email IS NOT NULL
    AND
      u.email <> '';

    -- mark them as having been emailed
    UPDATE temporary_message tm
    JOIN user u ON u.user_id = tm.user_id
    SET tm.has_emailed = 1
    WHERE 
      tm.has_emailed = 0
    AND 
      u.email IS NOT NULL
    AND
      u.email <> '';

END

---DELIMITER---

DROP PROCEDURE IF EXISTS rank_other_user;   

---DELIMITER---

CREATE PROCEDURE rank_other_user
(
  uid INT UNSIGNED, -- the user id acting as judge
  my_urdp_id INT UNSIGNED, -- the user rank data point id
  is_satis BOOL, -- whether the user is satisfied
  comment NVARCHAR(500) -- a comment by the judging user
) 
BEGIN 
  DECLARE count_valid_urdps INT;
  DECLARE msg VARCHAR(120);
  DECLARE judged_uid,rid INT UNSIGNED;

  CALL validate_user_id(uid);

  -- we only allow feedback in these situations: this user is, in fact,
  -- the judge.  status is "feedback possible".  date is within 30 days
  -- of going to status 2 (feedback possible)
  SELECT COUNT(*) INTO count_valid_urdps
  FROM user_rank_data_point
  WHERE urdp_id = my_urdp_id 
    AND judge_user_id = uid 
    AND status_id = 2
    AND UTC_TIMESTAMP() < (date_entered + INTERVAL 30 DAY);

  -- check that a user rank data point exists with this id.
  IF count_valid_urdps = 0 THEN
    SET msg = CONCAT('no urdp having an id of ', my_urdp_id,
     ' status_id of 2 ,judge_user_id of ', uid, 'inside 30 day window');
    
    SIGNAL SQLSTATE '45000' 
    SET message_text = msg;
  END IF;

  SELECT judged_user_id, requestoffer_id INTO judged_uid, rid
  FROM user_rank_data_point
  WHERE urdp_id = my_urdp_id;

  UPDATE user_rank_data_point
  SET 
    date_entered = UTC_TIMESTAMP(),  -- last modified date update
    meritorious = is_satis,
    status_id = 3 -- they have provided feedback, they're done.
  WHERE urdp_id = my_urdp_id;

  IF comment IS NOT NULL AND comment <> '' THEN
    INSERT INTO user_rank_data_point_note (urdp_id, user_id, text)
    VALUES (my_urdp_id, uid, comment);
  END IF;

  CALL recalculate_rank_on_user(judged_uid, is_satis);

	CALL add_audit(308,uid,judged_uid,rid,my_urdp_id,'from status_id 2');

  -- audit that the user is raising or lowering the other party's rank
  IF (is_satis) THEN
    CALL add_audit(304,uid,judged_uid,rid,my_urdp_id,NULL);
  ELSE
    CALL add_audit(305,uid,judged_uid,rid,my_urdp_id,NULL);
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
  DECLARE the_code VARCHAR(256);

  SET the_code = sha2(concat(UTC_TIMESTAMP(), '_',my_user_id,'_', rand()),256);
  SET new_invite_code = the_code;

  INSERT INTO invite_code (user_id, timestamp, value)
  VALUES (my_user_id, UTC_TIMESTAMP(), the_code);

  CALL add_audit(109, my_user_id, NULL, NULL, NULL, NULL);
END

---DELIMITER---

DROP PROCEDURE IF EXISTS set_user_description;   

---DELIMITER---

CREATE PROCEDURE set_user_description
(
  my_user_id INT UNSIGNED,
  my_text NVARCHAR(500)
)
BEGIN
  DECLARE existing_count INT;

  -- get the count of existing user descriptions for this user.
  SELECT COUNT(*) INTO existing_count
  FROM user_description
  WHERE user_id = my_user_id;

  -- if they already have a description, update it.  Otherwise, add a row
  IF existing_count = 1 THEN
    UPDATE user_description 
    SET text = my_text 
    WHERE user_id = my_user_id;
  ELSE
    INSERT INTO user_description (user_id, text)
    VALUES (my_user_id, my_text);
  END IF;

  CALL add_audit(111, my_user_id, NULL, NULL, NULL, NULL);
END

---DELIMITER---

DROP PROCEDURE IF EXISTS create_user_group;   

---DELIMITER---

CREATE PROCEDURE create_user_group
(
  the_group_name NVARCHAR(50),
  the_group_description NVARCHAR(500),
  new_owner_id INT UNSIGNED
)
BEGIN
  DECLARE new_group_id INT UNSIGNED;

  -- validate our input values
  call validate_user_id(new_owner_id);
  call is_non_empty_string(
    'create_user_group','the_group_name',the_group_name);

  -- add the group
  INSERT INTO user_group (name, owner_id)
  VALUES (the_group_name, new_owner_id);

  SET new_group_id = LAST_INSERT_ID();

  -- add the group description
  INSERT INTO group_description (group_id, text)
  VALUES (new_group_id, the_group_description);

  -- add the owner as a member of the group
  INSERT INTO user_to_group (user_id, group_id)
  VALUES (new_owner_id, new_group_id);

  CALL add_audit(407, new_owner_id, NULL, NULL, new_group_id, NULL);

END

---DELIMITER---

DROP PROCEDURE IF EXISTS send_group_invite_to_user;   

---DELIMITER---


CREATE PROCEDURE send_group_invite_to_user
(
  the_owner_id INT UNSIGNED,
  the_group_id INT UNSIGNED,
  the_user_id INT UNSIGNED -- the id of the user we're inviting
)
BEGIN
  DECLARE count_valid, count_existing, already_member_count INT; 

  SELECT COUNT(*) INTO count_valid
  FROM user_group 
  WHERE group_id = the_group_id AND owner_id = the_owner_id;

  -- if the group didn't have this owner, are they trying to hack us?
  IF count_valid <> 1 THEN
      SIGNAL SQLSTATE '45000' 
      SET message_text = 'error(12) group did not have this owner';
  END IF;

  SELECT COUNT(*) INTO count_existing
  FROM user_group_invite
  WHERE group_id = the_group_id AND user_id = the_user_id;

  -- if this invite already exists, just reply with an error
  IF count_existing > 0 THEN
      SIGNAL SQLSTATE '45000' 
      SET message_text = 'an invite has already been sent';
  END IF;

  SELECT COUNT(*) INTO already_member_count
  FROM user_to_group
  WHERE group_id = the_group_id AND user_id = the_user_id;

  -- if this user is already a member of the group, disallow
  IF already_member_count > 0 THEN
      SIGNAL SQLSTATE '45000' 
      SET message_text = 'this user already exists in the group';
  END IF;

  -- create the invitation
  INSERT INTO user_group_invite(group_id, user_id, date_created)
  VALUES (the_group_id, the_user_id, UTC_TIMESTAMP());

  -- audit that we sent that user an invite
  CALL add_audit(408, the_owner_id, the_user_id, NULL, the_group_id, NULL);

END

---DELIMITER---

DROP PROCEDURE IF EXISTS respond_to_group_invite;   

---DELIMITER---

-- we only need the group and the user we're targeting.  right now, 
-- only the owner can send invites, so we don't have to think about who
-- is sending the invite - it's the owner of the group, 
-- that doesn't change.

CREATE PROCEDURE respond_to_group_invite
(
  is_accepted BOOL, -- whether the user is accepting the invite
  the_group_id INT UNSIGNED,
  the_user_id INT UNSIGNED -- the id of the user we're inviting
)
BEGIN
  DECLARE the_owner_id INT UNSIGNED;

  SELECT owner_id INTO the_owner_id
  FROM user_group 
  WHERE group_id = the_group_id;

  -- if it's accepted, we add the user to the group and audit
  IF is_accepted THEN

    INSERT INTO user_to_group (user_id, group_id)
    VALUES (the_user_id, the_group_id);
    CALL put_system_to_user_message(222, the_user_id, NULL);
    CALL add_audit(409, the_user_id, 
      the_owner_id, NULL, the_group_id, NULL);

  -- if it's rejected, we do not add the user to the 
  -- group, but we send a system message to the inviter
  -- and we add an audit message
  ELSE
    CALL add_audit(410, the_user_id, 
      the_owner_id, NULL, the_group_id, NULL);

  END IF;

  DELETE FROM user_group_invite
  WHERE group_id = the_group_id AND user_id = the_user_id;

END

---DELIMITER---

DROP PROCEDURE IF EXISTS leave_group;   

---DELIMITER---

-- grants the ability for a member to leave a group.

CREATE PROCEDURE leave_group
(
  the_group_id INT UNSIGNED,
  the_user_id INT UNSIGNED -- the id of the user who is leaving
)
BEGIN
  DECLARE the_owner_id INT UNSIGNED;

  SELECT owner_id INTO the_owner_id
  FROM user_group 
  WHERE group_id = the_group_id;

  DELETE FROM user_to_group
  WHERE user_id = the_user_id AND group_id = the_group_id;


  -- audit that the user left the group
  CALL add_audit(406, the_user_id, 
    the_owner_id, NULL, the_group_id, NULL);

END

---DELIMITER---

DROP PROCEDURE IF EXISTS remove_from_group;   

---DELIMITER---

-- allows a group owner to remove a user from their group

CREATE PROCEDURE remove_from_group
(
  the_owner_id INT UNSIGNED,
  the_group_id INT UNSIGNED,
  the_user_id INT UNSIGNED -- the id of the user who is leaving
)
BEGIN
  DECLARE count_valid, count_existing, already_member_count INT; 

  SELECT COUNT(*) INTO count_valid
  FROM user_group 
  WHERE group_id = the_group_id AND owner_id = the_owner_id;

  -- if the group didn't have this owner, are they trying to hack us?
  IF count_valid <> 1 THEN
      SIGNAL SQLSTATE '45000' 
      SET message_text = 'error(13) group did not have this owner';
  END IF;

  DELETE FROM user_to_group
  WHERE user_id = the_user_id AND group_id = the_group_id;


  -- send a message to the user that they have been removed
  CALL put_system_to_user_message(223, the_user_id, NULL);

  -- audit that the user was removed from the group
  CALL add_audit(414, the_user_id, 
    the_owner_id, NULL, the_group_id, NULL);

END

---DELIMITER---

DROP PROCEDURE IF EXISTS retract_invitation;   

---DELIMITER---

-- if a group owner wants to take back an invitation to a user

CREATE PROCEDURE retract_invitation
(
  the_owner_id INT UNSIGNED,
  the_group_id INT UNSIGNED,
  the_user_id INT UNSIGNED
)
BEGIN
  DECLARE count_valid INT; 

  SELECT COUNT(*) INTO count_valid
  FROM user_group 
  WHERE group_id = the_group_id AND owner_id = the_owner_id;

  -- if the group didn't have this owner, are they trying to hack us?
  IF count_valid <> 1 THEN
    SIGNAL SQLSTATE '45000' 
    SET message_text = 'error(12) group did not have this owner';
  END IF;

  DELETE FROM user_group_invite
  WHERE user_id = the_user_id AND group_id = the_group_id;

  -- audit that the owner has retracted their invite to the user
  CALL add_audit(413, the_owner_id, the_user_id, NULL, the_group_id, NULL);
END

---DELIMITER---

DROP PROCEDURE IF EXISTS edit_group_description;   

---DELIMITER---


CREATE PROCEDURE edit_group_description
(
  the_group_id INT UNSIGNED,
  the_text NVARCHAR(500)
)
BEGIN
  DECLARE existing_count INT;
  DECLARE group_owner INT UNSIGNED;

  SELECT COUNT(*) INTO existing_count
  FROM user_group_description
  WHERE group_id = the_group_id;

  -- update or insert
  IF existing_count > 0 THEN
    UPDATE group_description
    SET text = the_text
    WHERE group_id = the_group_id;
  ELSE
    INSERT INTO group_description (group_id, text)
    VALUES (the_group_id, the_text);
  END IF;

  SELECT owner_id INTO group_owner
  FROM user_group
  WHERE group_id = the_group_id;

  CALL add_audit(415, group_owner, NULL, NULL, the_group_id, NULL);
END

---DELIMITER---

DROP PROCEDURE IF EXISTS edit_user_group_description;   

---DELIMITER---


CREATE PROCEDURE edit_user_group_description
(
  the_group_id INT UNSIGNED,
  the_user_id INT UNSIGNED,
  the_text NVARCHAR(500)
)
BEGIN
  DECLARE existing_count INT;

  SELECT COUNT(*) INTO existing_count
  FROM user_group_description
  WHERE group_id = the_group_id AND user_id = the_user_id;

  IF existing_count > 0 THEN
    UPDATE user_group_description
    SET text = the_text
    WHERE user_id = the_user_id AND group_id = the_group_id;
  ELSE
    INSERT INTO user_group_description (user_id, group_id, text)
    VALUES (the_user_id, the_group_id, the_text);
  END IF;

  CALL add_audit(412, the_user_id, NULL, NULL, the_group_id, NULL);
END

---DELIMITER---

DROP PROCEDURE IF EXISTS edit_user_current_location;   

---DELIMITER---

CREATE PROCEDURE edit_user_current_location
(
  the_user_id INT UNSIGNED,
  coid INT, -- country id
  poid INT -- postal code id
)
BEGIN

  UPDATE user
  SET 
    country_id = coid, 
    postal_code_id = poid
  WHERE user_id = the_user_id;

  CALL add_audit(401, the_user_id, NULL, coid, poid, NULL);
END

---DELIMITER---

DROP PROCEDURE IF EXISTS set_email;   

---DELIMITER---

CREATE PROCEDURE set_email
(
  uid INT UNSIGNED, -- the user whose email we'll change
  new_email NVARCHAR(200) -- the new email
) 
BEGIN 

  UPDATE user 
  SET email = new_email
  WHERE user_id = uid;

  CALL add_audit(112,uid,uid,NULL,NULL,new_email);
END
