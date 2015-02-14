-- Here we define events.  These are actions that take place on a regular
-- interval.  You can find information about these at:
-- http://dev.mysql.com/doc/refman/5.5/en/create-event.html
--
-- we will use them for a few ideas - like timeouts, for example.


-- Timeout event - an event to check whether users have passed their
-- timeout period and should have "is_logged_in" set false.  Timeout
-- meaning that once users have a certain amount of time without activity,
-- the system should log them out.

-- IMPORTANT! The event scheduler in MySQL has to be running for this to
-- work.
-- check with "show processlist;".  If you don't see event_scheduler under
-- User column, it's not running.

DROP EVENT IF EXISTS user_timeout;

---DELIMITER---
SET GLOBAL event_scheduler = ON;
---DELIMITER---

-- this sql does the following: every 5 seconds, run a script to check for
-- users whose last action was more than timeout_seconds ago.
-- compare the current time (UTC_TIMSTAMP()) with their last activity
-- (last_activity_time) plus the timeout (timeout_seconds).  If the
-- current time is greater (further into the future), then we act.

CREATE EVENT user_timeout 
ON SCHEDULE
  EVERY 5 SECOND 
COMMENT 'logs out users past their timeout period'
DO
	BEGIN
			UPDATE user 
			SET is_logged_in = 0 
			WHERE UTC_TIMESTAMP() > 
					(last_activity_time + INTERVAL timeout_seconds SECOND);
	END

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

    CREATE TEMPORARY TABLE locations_to_delete AS ( -- temporary table of id's to delete
      SELECT l.location_id  -- Get locations that have neither a user nor a requestoffer
      from location l 
      LEFT JOIN location_to_user ltu ON ltu.location_id = l.location_id 
      LEFT JOIN location_to_requestoffer ltr ON ltr.location_id = l.location_id 
      WHERE ltu.location_id IS NULL AND ltr.location_id IS NULL
    );

    DELETE FROM location -- here we actually delete
    WHERE location_id IN (
      select location_id from locations_to_delete
    );

    INSERT INTO audit ( -- now, store an audit of what we deleted
      datetime, audit_action_id, user_id, target_id)
    SELECT UTC_TIMESTAMP(), 8, 1, location_id
    FROM locations_to_delete;

  END
