-- Here we define events.  These are actions that take place on a regular
-- interval.  You can find information about these at:
-- http://dev.mysql.com/doc/refman/5.5/en/create-event.html
--
-- we will use them for a few ideas - like timeouts, for example.


-- IMPORTANT! The event scheduler in MySQL has to be running for this to
-- work.
-- check with "show processlist;".  If you don't see event_scheduler under
-- User column, it's not running.


SET GLOBAL event_scheduler = ON;
---DELIMITER---
DROP EVENT IF EXISTS user_timeout;
---DELIMITER---

-- Timeout event - an event to check whether users have passed their
-- timeout period and should have "is_logged_in" set false.  Timeout
-- meaning that once users have a certain amount of time without activity,
-- the system should log them out.

-- this sql does the following: every 5 seconds, run a script to check for
-- users whose last action was more than timeout_seconds ago.
-- compare the current time (UTC_TIMSTAMP()) with their last activity
-- (last_activity_time) plus the timeout (timeout_seconds).  If the
-- current time is greater (further into the future), then we act.

CREATE EVENT user_timeout 
ON SCHEDULE
  EVERY 3 HOUR 
COMMENT 'logs out users past their timeout period'
DO
  BEGIN
      UPDATE user 
      SET is_logged_in = 0 
      WHERE UTC_TIMESTAMP() > 
          (last_activity_time + INTERVAL timeout_seconds SECOND);
  END

---DELIMITER---
DROP EVENT IF EXISTS location_purge;
---DELIMITER---

-- every day, find locations that are not tied to either a user
-- or a requestoffer and delete them, and add an audit about doing so.

CREATE EVENT location_purge 
ON SCHEDULE
  EVERY 1 DAY 
COMMENT 'deletes locations that are not tied to either a user or a requestoffer'
DO
  BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
      SIGNAL SQLSTATE '45000' 
      SET message_text = "exception in location_purge event";
    END;

    DROP TEMPORARY TABLE IF EXISTS locations_to_delete;

   -- temporary table of id's to delete
   -- Get locations that have neither a user nor a requestoffer
    CREATE TEMPORARY TABLE locations_to_delete AS ( 
      SELECT l.location_id  
      from location l 
      LEFT JOIN location_to_user ltu ON ltu.location_id = l.location_id 
      LEFT JOIN location_to_requestoffer ltr 
        ON ltr.location_id = l.location_id 
      WHERE ltu.location_id IS NULL AND ltr.location_id IS NULL
    );

    DELETE FROM location -- here we actually delete
    WHERE location_id IN (
      select location_id from locations_to_delete
    );

    INSERT INTO audit ( -- now, store an audit of what we deleted
      datetime, audit_action_id, user1_id, extra_id)
    SELECT UTC_TIMESTAMP(), 404, 1, location_id
    FROM locations_to_delete;

  END

---DELIMITER---
DROP EVENT IF EXISTS clear_out_old_messages;
---DELIMITER---

-- this sql does the following: every 5 minutes, run a script to delete
-- messages whose creation time was more than 24 hours ago.
-- note: this should also clear out the text messages stored in
-- temporary_message_text table, which should "ON DELETE CASCADE"

CREATE EVENT clear_out_old_messages
ON SCHEDULE
  EVERY 5 MINUTE 
COMMENT 'Removes old messages from the temporary message table'
DO
  BEGIN
      DELETE FROM temporary_message 
      WHERE UTC_TIMESTAMP() > 
          (timestamp + INTERVAL 24 HOUR);
  END

---DELIMITER---
DROP EVENT IF EXISTS revert_open_requestoffers_to_draft;
---DELIMITER---

-- this sql does the following: every 5 minutes, run a script to revert
-- any requestoffers more than a day old that have not been 
-- taken to the draft status.

CREATE EVENT revert_open_requestoffers_to_draft
ON SCHEDULE
  EVERY 1 HOUR 
COMMENT 'moves stale requestoffers back to draft status'
DO
  BEGIN

    DROP TEMPORARY TABLE IF EXISTS requestoffers_to_change_status;

    -- get all the requestoffers that need to have their status changed
    CREATE TEMPORARY TABLE requestoffers_to_change_status AS ( 
      SELECT requestoffer_id
      FROM requestoffer_state
      WHERE status = 76
        AND UTC_TIMESTAMP() > (datetime + INTERVAL 24 HOUR)
    );

    -- update the requestoffers to be draft status
      UPDATE requestoffer_state rs
      JOIN requestoffers_to_change_status rtcs 
        ON rtcs.requestoffer_id = rs.requestoffer_id
      SET rs.status = 109, datetime = UTC_TIMESTAMP(); -- 109 is "DRAFT"

      -- audit that we are setting the requestoffer to draft
      INSERT INTO audit (
        datetime, audit_action_id, user1_id, requestoffer_id)
      SELECT UTC_TIMESTAMP(), 206, 1, requestoffer_id -- 1 is system user
      FROM requestoffers_to_change_status;

      -- audit that we are rejecting users who had offered to handle this
      INSERT INTO audit (
        datetime, audit_action_id, user1_id, user2_id, requestoffer_id)
      SELECT UTC_TIMESTAMP(), 211, 1, rsr.user_id, rsr.requestoffer_id
      FROM requestoffers_to_change_status rtcs
      JOIN requestoffer_service_request rsr
        ON rtcs.requestoffer_id = rsr.requestoffer_id
      WHERE rsr.status = 106; -- 106 is "new"

      -- set associated service request statuses to "rejected"
      -- if they aren't already rejected.
      UPDATE requestoffer_service_request rsr 
      JOIN requestoffers_to_change_status rtcs
        ON rtcs.requestoffer_id = rsr.requestoffer_id
      SET rsr.status = 108, 
      rsr.date_modified = UTC_TIMESTAMP() -- 108 is "REJECTED"
      WHERE rsr.status = 106; -- 106 is "new"

      -- give points back to the owning users
      UPDATE user u 
      JOIN requestoffer r 
        ON u.user_id = r.requestoffering_user_id
      JOIN requestoffers_to_change_status rtcs 
        ON rtcs.requestoffer_id = r.requestoffer_id
      SET u.points = u.points + r.points; 

  END

---DELIMITER---
DROP EVENT IF EXISTS clear_out_old_invite_codes;
---DELIMITER---

-- this sql does the following: every minute, run a script to delete
-- invite codes that were generated by users and not used to register a user

CREATE EVENT clear_out_old_invite_codes
ON SCHEDULE
  EVERY 1 MINUTE 
COMMENT 'Removes old invite codes from the invite_code table'
DO
  BEGIN
      DELETE FROM invite_code 
      WHERE UTC_TIMESTAMP() > 
          (timestamp + INTERVAL 7 DAY);
  END

---DELIMITER---
DROP EVENT IF EXISTS adjust_user_rankings;
---DELIMITER---

-- this sql does the following: once a day, run a script to recalculate
-- user rankings for those users who have user_rank_data_points that are
-- outside the 6 month rolling window.  Audits this also.

CREATE EVENT adjust_user_rankings
ON SCHEDULE
  EVERY 1 DAY 
COMMENT 'recalculates user rankings for 6 month rolling window'
DO
  BEGIN

    -- a table to hold user rank data points outside the rolling window
    DROP TEMPORARY TABLE IF EXISTS urdps_going_outside_window;

    CREATE TEMPORARY TABLE urdps_going_outside_window AS ( 
      SELECT urdp_id, judge_user_id, 
        judged_user_id, requestoffer_id, date_entered
      FROM user_rank_data_point
      WHERE 
        UTC_TIMESTAMP() > (date_entered + INTERVAL 6 MONTH)
        AND
        is_inside_window = 1
    );

    -- audit going outside the window
    INSERT INTO audit (
      datetime, audit_action_id, user1_id, user2_id, 
      requestoffer_id, extra_id)
    SELECT UTC_TIMESTAMP(), 310, 1, ugow.judge_user_id, 
      ugow.requestoffer_id, ugow.urdp_id
    FROM urdps_going_outside_window ugow;

    -- actually set them to be outside the window
    UPDATE user_rank_data_point urdp
    JOIN urdps_going_outside_window ugow ON ugow.urdp_id = urdp.urdp_id
    SET urdp.is_inside_window = 0;

    -- only update users if they have user rank data points
    -- that are moving from being inside the rolling window to outside.
    UPDATE user u
    JOIN user_rank_data_point urdp ON urdp.judged_user_id = u.user_id
    JOIN urdps_going_outside_window ugow ON ugow.judged_user_id = u.user_id
    SET 
      u.rank_average = 
        (
          SELECT AVG(meritorious)
          FROM user_rank_data_point
          WHERE 
            judged_user_id = u.user_id
            AND
            status_id = 3 -- feedback is complete
            AND
            UTC_TIMESTAMP() < (date_entered + INTERVAL 6 MONTH)
        );

    -- audit that certain users had their ranks adjusted because of
    -- urdp's going outside window
    INSERT INTO audit (
      datetime, audit_action_id, user1_id, user2_id, requestoffer_id
    )
    SELECT UTC_TIMESTAMP(), 309, 1, judged_user_id, requestoffer_id
    FROM urdps_going_outside_window;

  END
