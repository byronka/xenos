/*
The following was mostly generated by a command, I just tidied it up afterwards.

For future maintainers, this is how I did it:
I built the project and started with an empty database.
I went through a fair chunk of the feature set, trying to hit
every nook and cranny of possibility.  Then, I used the following command:

  options used
  ------------

  --complete-insert	Use complete INSERT statements that include column names
  --disable-keys	For each table, surround the INSERT statements with statements to disable and enable keys
  --no-create-db	This option suppresses the CREATE DATABASE statements
  --no-create-info	Do not write CREATE TABLE statements that re-create each dumped table
  --no-set-names	Same as --skip-set-charset - --skip-set-charset	Suppress the SET NAMES statement
  --no-tablespaces	Do not write any CREATE LOGFILE GROUP or CREATE TABLESPACE statements in output
  --order-by-primary	Dump each table's rows sorted by its primary key, or by its first unique index
  --skip-comments	Do not add comments to the dump file
  --skip-add-locks	Do not add locks
  --skip-quote-names	Do not quote identifiers
  --add-drop-table	Add a DROP TABLE statement before each CREATE TABLE statement

  The actual command
  -------------------

  mysqldump  --single-transaction --add-drop-table --complete-insert --no-create-db --no-create-info --no-set-names --no-tablespaces --order-by-primary --skip-comments --skip-add-locks --skip-quote-names xenos_database -u xenosuser -ppassword1 > test

this puts a file together, "test".  I edited that file, taking out the stuff that
will get put in in setup.sql, like the first few users (id's 1, 2, and 3) and some
of the enums (like requestoffer_service_request_status, basically anything where you 
see an INSERT in v1_setup.sql).  Definitely delete the config table entries.  
I added SET FOREIGN_KEY_CHECKS=0; and =1 at beginning
and end.  A little testing, frustration, and poof we're done!

*/
SET FOREIGN_KEY_CHECKS=0;
---DELIMITER---
INSERT INTO user 
(user_id, username, email, password, points, language, is_logged_in, date_created, salt, last_time_logged_in, last_activity_time, timeout_seconds, last_ip_logged_in, rank_average, is_admin, inviter, current_location)
VALUES 
(4,'bob',NULL,'2967B4F08443FBCAA916C0F86E259D0329D218624C9C6580AA3DE987FAB81866',-1,NULL,0,'2015-03-11 01:30:11','8285468784553744646','2015-03-11 01:33:23','2015-03-11 01:36:38',1800,'127.0.0.1',0.5,0,1,2),
(5,'alice',NULL,'332178DC10FA7FC3266BD66269D2F586D69BCAD486EAB56A91E95574928D728E',1,NULL,0,'2015-03-11 01:30:26','4418363537396537050','2015-03-11 01:32:51','2015-03-11 01:36:41',1800,'127.0.0.1',1,0,1,2),
(6,'sally',NULL,'8DD97D339E8DCD2885A61EBA72E509910A06EB718B03964799D16792C328428E',0,NULL,0,'2015-03-11 01:30:43','5675512930062176300','2015-03-11 01:31:54','2015-03-11 01:32:00',1800,'127.0.0.1',0.5,0,1,1);
---DELIMITER---
INSERT INTO audit (datetime, audit_action_id, user1_id, user2_id, requestoffer_id, extra_id, notes_id) VALUES ('2015-03-11 01:29:45',107,NULL,NULL,NULL,NULL,1),('2015-03-11 01:30:11',101,4,NULL,NULL,NULL,2),('2015-03-11 01:30:27',101,5,NULL,NULL,NULL,3),('2015-03-11 01:30:43',101,6,NULL,NULL,NULL,4),('2015-03-11 01:30:48',102,4,NULL,NULL,NULL,NULL),('2015-03-11 01:31:28',201,4,NULL,1,NULL,NULL),('2015-03-11 01:31:28',401,4,NULL,NULL,1,NULL),('2015-03-11 01:31:29',403,4,NULL,NULL,1,NULL),('2015-03-11 01:31:29',402,NULL,NULL,1,1,NULL),('2015-03-11 01:31:32',202,4,NULL,1,NULL,NULL),('2015-03-11 01:31:32',301,1,4,1,NULL,NULL),('2015-03-11 01:31:36',103,4,NULL,NULL,NULL,NULL),('2015-03-11 01:31:40',102,5,NULL,NULL,NULL,NULL),('2015-03-11 01:31:45',209,5,4,1,NULL,NULL),('2015-03-11 01:31:49',103,5,NULL,NULL,NULL,NULL),('2015-03-11 01:31:54',102,6,NULL,NULL,NULL,NULL),('2015-03-11 01:31:58',209,6,4,1,NULL,NULL),('2015-03-11 01:32:00',103,6,NULL,NULL,NULL,NULL),('2015-03-11 01:32:03',102,4,NULL,NULL,NULL,NULL),('2015-03-11 01:32:12',306,5,4,1,1,NULL),('2015-03-11 01:32:13',306,4,5,1,1,NULL),('2015-03-11 01:32:13',207,4,5,1,NULL,NULL),('2015-03-11 01:32:13',208,4,6,1,NULL,NULL),('2015-03-11 01:32:26',201,4,NULL,2,NULL,NULL),('2015-03-11 01:32:26',401,0,NULL,NULL,2,NULL),('2015-03-11 01:32:26',402,NULL,NULL,2,2,NULL),('2015-03-11 01:32:43',205,4,NULL,2,NULL,5),('2015-03-11 01:32:47',103,4,NULL,NULL,NULL,NULL),('2015-03-11 01:32:51',102,5,NULL,NULL,NULL,NULL),('2015-03-11 01:33:23',102,4,NULL,NULL,NULL,NULL),('2015-03-11 01:35:06',203,4,NULL,1,NULL,NULL),('2015-03-11 01:35:07',307,5,4,1,2,6),('2015-03-11 01:35:07',308,4,5,1,1,7),('2015-03-11 01:35:07',302,4,5,1,NULL,NULL),('2015-03-11 01:35:07',304,4,5,1,NULL,NULL),('2015-03-11 01:36:38',103,4,NULL,NULL,NULL,NULL),('2015-03-11 01:36:41',103,5,NULL,NULL,NULL,NULL);
---DELIMITER---
INSERT INTO audit_notes (notes_id, notes) VALUES (1,'got null when trying to unencrypt cookie 437EA0... with passphrase: d68e...Ip: 127.0.0.1'),(2,'127.0.0.1'),(3,'127.0.0.1'),(4,'127.0.0.1'),(5,'Someone please do my English h|created:2015-03-11|pts:1|st:DRAFT'),(6,'From status_id 1'),(7,'From status_id 1');
---DELIMITER---
INSERT INTO location (location_id, address_line_1, address_line_2, city, state, postal_code, country) 
VALUES 
(1,'5335 Dogwood meadows cover','','Germantown','TN','38139','USA'),(2,'20675 Cutwater Place','','Sterling','VA','20165','USA');
---DELIMITER---
INSERT INTO location_to_requestoffer (location_id, requestoffer_id) VALUES (1,1);
---DELIMITER---
INSERT INTO location_to_user (location_id, user_id) VALUES (1,4),(2,4),(2,5);
---DELIMITER---
INSERT INTO requestoffer (requestoffer_id, datetime, description, points, category, requestoffering_user_id, handling_user_id) VALUES (1,'2015-03-11 01:31:28','Babysit my unruly kids',1,143,4,5);
---DELIMITER---
INSERT INTO requestoffer_message (requestoffer_id, message, timestamp, from_user_id, to_user_id) VALUES (1,'alice says:What time do you want me over there?','2015-03-11 01:33:10',5,4),(1,'bob says:Umm, 7pm will do fine','2015-03-11 01:33:39',4,5),(1,'alice says:great, I\'ll see you then.','2015-03-11 01:34:35',5,4),(1,'bob says:Thanks for the babysitting.','2015-03-11 01:35:02',4,5);
---DELIMITER---
INSERT INTO requestoffer_service_request (service_request_id, requestoffer_id, user_id, date_created, date_modified, status) VALUES (1,1,5,'2015-03-11 01:31:45','2015-03-11 01:32:13',107),(2,1,6,'2015-03-11 01:31:57','2015-03-11 01:32:13',108);
---DELIMITER---
INSERT INTO requestoffer_state (requestoffer_id, status, datetime) VALUES (1,77,'2015-03-11 01:31:32');
---DELIMITER---
INSERT INTO system_to_user_message (stu_message_id, requestoffer_id, text_id, timestamp, to_user_id, has_been_viewed) VALUES (1,1,148,'2015-03-11 01:31:45',4,0),(2,1,148,'2015-03-11 01:31:57',4,0),(3,1,132,'2015-03-11 01:32:13',5,0),(4,1,133,'2015-03-11 01:32:13',6,0);
---DELIMITER---
INSERT INTO temporary_message (message_id, timestamp, user_id, message_localization_id) VALUES (1,'2015-03-11 01:31:45',4,148),(2,'2015-03-11 01:31:58',4,148),(3,'2015-03-11 01:32:13',5,132),(4,'2015-03-11 01:32:13',6,133),(5,'2015-03-11 01:33:10',4,NULL),(6,'2015-03-11 01:33:39',5,NULL),(7,'2015-03-11 01:34:35',4,NULL),(8,'2015-03-11 01:35:02',5,NULL);
---DELIMITER---
INSERT INTO temporary_message_text (message_id, text) VALUES (5,'alice says:What time do you want me over there?'),(6,'bob says:Umm, 7pm will do fine'),(7,'alice says:great, I\'ll see you then.'),(8,'bob says:Thanks for the babysitting.');
---DELIMITER---
INSERT INTO user_rank_data_point (urdp_id, date_entered, judge_user_id, judged_user_id, requestoffer_id, meritorious, status_id) VALUES (1,'2015-03-11 01:35:07',4,5,1,1,3),(2,'2015-03-11 01:35:06',5,4,1,NULL,2);
---DELIMITER---
SET FOREIGN_KEY_CHECKS=1;
