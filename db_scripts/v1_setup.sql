-- Note that these scripts will be run in the order written

-- as a necessary
-- separator between SQL scripts, we use the delimiter keyword, having three
-- dashes in front and back, that you see below. 

---DELIMITER---

-- add a procedure for setting version
CREATE PROCEDURE set_version
(IN version INT) 
BEGIN 
	UPDATE config set config_value = version
	WHERE config_item = 'db_version';
END

---DELIMITER---
CALL set_version(1);
---DELIMITER---

-- create the user table

CREATE TABLE IF NOT EXISTS 
  user (
    user_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    first_name NVARCHAR(100),
    last_name NVARCHAR(100),
    email NVARCHAR(200),
    password NVARCHAR(100)
  );

---DELIMITER---


-- add_security_cols_to_usertable.sql

ALTER TABLE user 
ADD COLUMN (
  is_logged_in BOOL, 
  last_time_logged_in DATETIME,
  last_ip_logged_in VARCHAR(40)
)


---DELIMITER---

-- this guy is an enum only.  Don't expect to put this value
-- directly into the output.  Rather, we use the number to determine
-- which localized value to get.  That is, it will make it easier for
-- use when we need to translate languages.

CREATE TABLE IF NOT EXISTS
request_status (
  request_status_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  request_status_value VARCHAR(20)
);


---DELIMITER---
-- now we put our enums into the request_status table.
-- these are intentionally in all-caps to emphasize they are not
-- supposed to go straight to the client.  They must be localized first.
INSERT INTO request_status (request_status_value)
VALUES('OPEN'),('CLOSED'),('TAKEN');

---DELIMITER---
-- create_request_table

CREATE TABLE IF NOT EXISTS 
request ( 
  request_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  datetime DATETIME,
  description NVARCHAR(1000),
  points INT,
  status INT,
  title NVARCHAR(255),
  requesting_user INT NOT NULL,
  FOREIGN KEY FK_requesting_user_user_id (requesting_user) 
    REFERENCES user (user_id) 
    ON DELETE CASCADE,
  FOREIGN KEY FK_status_request_status_id (status)
    REFERENCES request_status (request_status_id)
    ON DELETE CASCADE
);


---DELIMITER---
-- create the tables to store categories and assign them to requests.

CREATE TABLE IF NOT EXISTS 
request_category ( 
  request_category_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	request_category_value VARCHAR(20),
)

---DELIMITER---
-- now we put our enums into the request_category table.
-- these are intentionally in all-caps to emphasize they are not
-- supposed to go straight to the client.  They must be localized first.
INSERT INTO request_category (request_category_value)
VALUES('MATH'),('PHYSICS'),('ECONOMICS'),('HISTORY'),('ENGLISH');

---DELIMITER---
-- here, we set up a table to correlate categories to a given
-- request.

CREATE TABLE IF NOT EXISTS 
request_category_to_request ( 
	request_id INT NOT NULL,
  request_category_id INT NOT NULL
  FOREIGN KEY FK_requesting_user_user_id (requesting_user) 
    REFERENCES user (user_id) 
    ON DELETE CASCADE,
  FOREIGN KEY FK_status_request_status_id (status)
    REFERENCES request_status (request_status_id)
    ON DELETE CASCADE

)
