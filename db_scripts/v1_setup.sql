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
-- Here we set the version of the database.  This needs to get incremented each release.
CALL set_version(1);
---DELIMITER---

-- create the user table

CREATE TABLE IF NOT EXISTS 
  user (
    user_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    first_name NVARCHAR(100),
    last_name NVARCHAR(100),
    email NVARCHAR(200) UNIQUE, 
    password NVARCHAR(100),
		points int unsigned,
		language int unsigned NULL,
		is_logged_in BOOL, 
		last_time_logged_in DATETIME,
		last_ip_logged_in VARCHAR(40),
		rank INT NOT NULL DEFAULT 50,
		username NVARCHAR(50)
  );

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
  description NVARCHAR(10000),
  points INT UNSIGNED,
  status INT,
  title NVARCHAR(255),
  requesting_user_id INT NOT NULL,
  FOREIGN KEY FK_requesting_user_user_id (requesting_user_id) 
    REFERENCES user (user_id) 
    ON DELETE CASCADE,
  FOREIGN KEY FK_status_request_status_id (status)
    REFERENCES request_status (request_status_id)
    ON DELETE CASCADE
);



---DELIMITER---
-- here, we set up a table to correlate categories to a given
-- request.

CREATE TABLE IF NOT EXISTS 
request_to_category ( 
	request_id INT NOT NULL,
  request_category_id INT NOT NULL,
  FOREIGN KEY FK_request_id_request_id (request_id) 
    REFERENCES request (request_id) 
    ON DELETE CASCADE,
  FOREIGN KEY FK_request_category_id_request_category_id (request_category_id)
    REFERENCES request_category (request_category_id)
    ON DELETE CASCADE
)

---DELIMITER---
-- create a table of meesages for requests

CREATE TABLE IF NOT EXISTS 
request_message ( 
  request_id INT NOT NULL,
	message NVARCHAR(10000),
	timestamp datetime,
	user_id INT NOT NULL,
  FOREIGN KEY FK_request_id (request_id)
	REFERENCES request (request_id)
	ON DELETE CASCADE,
  FOREIGN KEY FK_user_id (user_id)
	REFERENCES user (user_id)
	ON DELETE CASCADE
)

---DELIMITER---
-- create a table of known languages

CREATE TABLE IF NOT EXISTS 
languages ( 
  language_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	language_name	NVARCHAR(30)
)

---DELIMITER---
-- add to a table of known languages

INSERT INTO languages (language_name)
VALUES('English'),('French'),('Spanish')

---DELIMITER---
-- create a lookup table for words and 
-- phrases to their localized counterparts, e.g. French, English, etc.

CREATE TABLE IF NOT EXISTS 
localization_lookup ( 
  local_id INT NOT NULL PRIMARY KEY,
	English NVARCHAR(1000),
	French NVARCHAR(1000),
	Spanish NVARCHAR(1000)
)

---DELIMITER---
-- create the tables to store categories and assign them to requests.

CREATE TABLE IF NOT EXISTS 
request_category ( 
  request_category_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	request_category_value VARCHAR(20),
	localization_value INT NOT NULL,
  FOREIGN KEY FK_localization_value (localization_value )
    REFERENCES localization_lookup (local_id)
    ON DELETE CASCADE
)

