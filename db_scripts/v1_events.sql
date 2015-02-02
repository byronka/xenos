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

-- this sql does the following: every minute, run a script to check for
-- users whose last action was more than timeout_seconds ago.
-- compare the current time (UTC_TIMSTAMP()) with their last activity
-- (last_activity_time) plus the timeout (timeout_seconds).  If the
-- current time is greater (further into the future), then we act.

CREATE EVENT user_timeout 
ON SCHEDULE
  EVERY 1 MINUTE 
COMMENT 'logs out users past their timeout period'
DO
  UPDATE user 
  SET is_logged_in = 0 
  WHERE UTC_TIMESTAMP() > 
      (last_activity_time + INTERVAL timeout_seconds SECOND);
