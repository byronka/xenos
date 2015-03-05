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
INSERT INTO user (user_id, username, email, password, points, language, is_logged_in, date_created, salt, last_time_logged_in, last_activity_time, timeout_seconds, last_ip_logged_in, rank, is_admin) VALUES (4,'bob',NULL,'97CD670433F9E9675E9BE43F3F3FC797BCC52CFD91956B812F1062BC470DB607',-4,NULL,0,'2015-03-03 04:13:13','7282670826090997312','2015-03-04 00:12:31','2015-03-04 00:18:19',1800,'127.0.0.1',0.5,0),(5,'alice',NULL,'A6A70693AABAED9BD0681D0BE761FE21EA095C235A1C1D0AD9D3440D8759C3D2',-3,NULL,0,'2015-03-03 04:13:22','1771743456562480632','2015-03-03 23:30:18','2015-03-03 23:30:53',1800,'127.0.0.1',0.5,0),(6,'sally',NULL,'BE5F567D8662FEB68AB2DC41CB894E539C55445908BB6BDD1DED5B41FA190955',-2,NULL,0,'2015-03-03 04:13:31','7434174194845179283','2015-03-03 23:21:57','2015-03-03 23:22:05',1800,'127.0.0.1',0.5,0),(7,'victor_hugo',NULL,'A70D74DF23DE6FB419410B38DCB03B1C62ED3112005B05F5C09218D6E3AB5CDD',-5,NULL,1,'2015-03-03 04:14:13','6381981015702755546','2015-03-04 00:53:06','2015-03-04 01:58:58',1800,'127.0.0.1',1,0),(8,'葉問',NULL,'3876468330BC6D15890245FE2E48D6932CE9033DDBF0B5F4B0B6234393AE2311',-7,NULL,0,'2015-03-03 04:18:12','6770082270657734633','2015-03-03 23:22:57','2015-03-03 23:23:51',1800,'127.0.0.1',0.5,0),(9,'HernánCortés',NULL,'E2D85066016BAE7E43E1031FBBA2ACF01E2D689B654B0EDAA976F203CE1F1BEA',-5,NULL,0,'2015-03-03 04:18:43','4146914758501390980','2015-03-03 23:36:44','2015-03-03 23:37:53',1800,'127.0.0.1',0.5,0),(10,'cameron',NULL,'5740919FF75F3C32A40074A1B727ACD1D3993B550C129F60177D7E9B3498833F',-14,NULL,1,'2015-03-03 04:18:58','7599677155023395942','2015-03-04 00:53:28','2015-03-04 02:01:20',1800,'127.0.0.1',1,0),(11,'susanne',NULL,'0A2D922F1B6020AEB3A37F27E1281925B6B8CCBE63DC7E1CF1672B74DF03E9E0',-1,NULL,0,'2015-03-03 04:19:06','6144620495913025192','2015-03-03 23:24:51','2015-03-03 23:25:44',1800,'127.0.0.1',0.5,0),(12,'byron',NULL,'2CC5D8526466C69A4DF53D724370CC1A28D118D3DC1CD8BD18C9926E41DE1B52',-1,NULL,0,'2015-03-03 04:19:14','7174672554691516959','2015-03-03 04:39:15','2015-03-03 04:39:42',1800,'127.0.0.1',0.5,0),(13,'dan',NULL,'38B6E1108782CFA08E9BF241CF37EB33C17C41DF7CCB971B94836650393970F8',0,NULL,NULL,'2015-03-03 04:19:22','6144463533333340521',NULL,NULL,1800,NULL,0.5,0),(14,'david',NULL,'CBADC403243823056C1E6AB66CACCDDEA5AA91C15E4C1C6EDAE7B41DFBA58FFA',0,NULL,0,'2015-03-03 04:19:34','6807043001388214757','2015-03-03 23:25:50','2015-03-03 23:27:10',1800,'127.0.0.1',0.5,0),(15,'corey',NULL,'EC5F0A968D4881A0FBCE2C690FF7D0685608AAC370B6C9B9CDDFB57C86D258C0',0,NULL,NULL,'2015-03-03 04:19:43','3611808742672159011',NULL,NULL,1800,NULL,0.5,0),(16,'vivien',NULL,'82B805766457B360EE0EEAFAD6274289022F3654E90010DDBE89087B21B79A44',0,NULL,NULL,'2015-03-03 04:19:53','7102908473251563738',NULL,NULL,1800,NULL,0.5,0),(17,'nathan',NULL,'91AFA92D5375064948881446488E575E0FF14144C766C7F88C38EF190618A30B',0,NULL,NULL,'2015-03-03 04:20:04','4718376955854933964',NULL,NULL,1800,NULL,0.5,0),(18,'elysa',NULL,'89906EFF5176517D2916C5FA7F47DC107C50BCFDBC2C107D35F5642174052EAD',0,NULL,NULL,'2015-03-03 04:20:20','8686350601300417910',NULL,NULL,1800,NULL,0.5,0),(20,'mallory',NULL,'F25005C5B6534BB06D0C937E8DFD9E93BAAD783F0A0048CA7A8CBDC76612AEE7',0,NULL,NULL,'2015-03-03 23:31:02','5600717252430758006',NULL,NULL,1800,NULL,0.5,0),(21,'<script>alert(\'username\')</script>',NULL,'13DADFFDDFC9D42DDE6E1CFA8AF40E7DC0757FBAEF93C51A09BE181C59776A21',0,NULL,0,'2015-03-03 23:31:54','2568792068181838102','2015-03-04 00:18:24','2015-03-04 00:20:56',1800,'127.0.0.1',0,0);
---DELIMITER---
INSERT INTO audit (datetime, audit_action_id, user1_id, requestoffer_id, notes_id) VALUES ('2015-03-03 04:13:01',14,NULL,NULL,1),('2015-03-03 04:13:08',14,NULL,NULL,2),('2015-03-03 04:13:13',14,NULL,NULL,3),('2015-03-03 04:13:14',4,4,NULL,NULL),('2015-03-03 04:13:15',14,NULL,NULL,4),('2015-03-03 04:13:17',14,NULL,NULL,5),('2015-03-03 04:13:22',14,NULL,NULL,6),('2015-03-03 04:13:22',4,5,NULL,NULL),('2015-03-03 04:13:23',14,NULL,NULL,7),('2015-03-03 04:13:27',14,NULL,NULL,8),('2015-03-03 04:13:31',14,NULL,NULL,9),('2015-03-03 04:13:31',4,6,NULL,NULL),('2015-03-03 04:13:33',14,NULL,NULL,10),('2015-03-03 04:13:56',14,NULL,NULL,11),('2015-03-03 04:13:56',23,NULL,NULL,12),('2015-03-03 04:14:03',14,NULL,NULL,13),('2015-03-03 04:14:03',23,NULL,NULL,14),('2015-03-03 04:14:07',14,NULL,NULL,15),('2015-03-03 04:14:13',14,NULL,NULL,16),('2015-03-03 04:14:13',4,7,NULL,NULL),('2015-03-03 04:14:15',14,NULL,NULL,17),('2015-03-03 04:14:18',14,NULL,NULL,18),('2015-03-03 04:18:12',14,NULL,NULL,19),('2015-03-03 04:18:12',4,8,NULL,NULL),('2015-03-03 04:18:14',14,NULL,NULL,20),('2015-03-03 04:18:37',14,NULL,NULL,21),('2015-03-03 04:18:43',14,NULL,NULL,22),('2015-03-03 04:18:43',4,9,NULL,NULL),('2015-03-03 04:18:44',14,NULL,NULL,23),('2015-03-03 04:18:49',14,NULL,NULL,24),('2015-03-03 04:18:50',23,NULL,NULL,25),('2015-03-03 04:18:52',14,NULL,NULL,26),('2015-03-03 04:18:58',14,NULL,NULL,27),('2015-03-03 04:18:59',4,10,NULL,NULL),('2015-03-03 04:19:00',14,NULL,NULL,28),('2015-03-03 04:19:02',14,NULL,NULL,29),('2015-03-03 04:19:06',14,NULL,NULL,30),('2015-03-03 04:19:06',4,11,NULL,NULL),('2015-03-03 04:19:07',14,NULL,NULL,31),('2015-03-03 04:19:10',14,NULL,NULL,32),('2015-03-03 04:19:13',14,NULL,NULL,33),('2015-03-03 04:19:14',4,12,NULL,NULL),('2015-03-03 04:19:15',14,NULL,NULL,34),('2015-03-03 04:19:17',14,NULL,NULL,35),('2015-03-03 04:19:22',14,NULL,NULL,36),('2015-03-03 04:19:22',4,13,NULL,NULL),('2015-03-03 04:19:23',14,NULL,NULL,37),('2015-03-03 04:19:25',14,NULL,NULL,38),('2015-03-03 04:19:34',14,NULL,NULL,39),('2015-03-03 04:19:34',4,14,NULL,NULL),('2015-03-03 04:19:36',14,NULL,NULL,40),('2015-03-03 04:19:38',14,NULL,NULL,41),('2015-03-03 04:19:43',14,NULL,NULL,42),('2015-03-03 04:19:43',4,15,NULL,NULL),('2015-03-03 04:19:45',14,NULL,NULL,43),('2015-03-03 04:19:47',14,NULL,NULL,44),('2015-03-03 04:19:53',14,NULL,NULL,45),('2015-03-03 04:19:53',4,16,NULL,NULL),('2015-03-03 04:19:56',14,NULL,NULL,46),('2015-03-03 04:19:58',14,NULL,NULL,47),('2015-03-03 04:20:04',14,NULL,NULL,48),('2015-03-03 04:20:04',4,17,NULL,NULL),('2015-03-03 04:20:06',14,NULL,NULL,49),('2015-03-03 04:20:13',14,NULL,NULL,50),('2015-03-03 04:20:13',23,NULL,NULL,51),('2015-03-03 04:20:15',14,NULL,NULL,52),('2015-03-03 04:20:20',14,NULL,NULL,53),('2015-03-03 04:20:20',4,18,NULL,NULL),('2015-03-03 04:20:22',14,NULL,NULL,54),('2015-03-03 04:20:27',14,NULL,NULL,55),('2015-03-03 04:21:24',14,NULL,NULL,56),('2015-03-03 04:21:24',15,4,4,NULL),('2015-03-03 04:22:10',1,4,1,NULL),('2015-03-03 04:22:10',12,4,1,NULL),('2015-03-03 04:22:10',21,4,1,NULL),('2015-03-03 04:22:51',1,4,2,NULL),('2015-03-03 04:22:51',12,4,2,NULL),('2015-03-03 04:22:52',21,4,2,NULL),('2015-03-03 04:23:39',1,4,3,NULL),('2015-03-03 04:23:39',12,4,3,NULL),('2015-03-03 04:23:40',21,0,3,NULL),('2015-03-03 04:23:54',16,4,NULL,NULL),('2015-03-03 04:24:07',15,5,5,NULL),('2015-03-03 04:24:40',1,5,4,NULL),('2015-03-03 04:24:40',12,5,4,NULL),('2015-03-03 04:24:40',21,0,4,NULL),('2015-03-03 04:25:40',1,5,5,NULL),('2015-03-03 04:25:40',12,5,5,NULL),('2015-03-03 04:25:41',21,5,5,NULL),('2015-03-03 04:26:07',1,5,6,NULL),('2015-03-03 04:26:07',12,5,6,NULL),('2015-03-03 04:26:08',21,0,6,NULL),('2015-03-03 04:26:11',16,5,NULL,NULL),('2015-03-03 04:26:26',15,6,6,NULL),('2015-03-03 04:27:13',1,6,7,NULL),('2015-03-03 04:27:13',12,6,7,NULL),('2015-03-03 04:27:14',21,6,7,NULL),('2015-03-03 04:27:31',1,6,8,NULL),('2015-03-03 04:27:31',12,6,8,NULL),('2015-03-03 04:27:32',21,0,8,NULL),('2015-03-03 04:27:38',16,6,NULL,NULL),('2015-03-03 04:27:57',15,7,7,NULL),('2015-03-03 04:28:43',1,7,9,NULL),('2015-03-03 04:28:43',12,7,9,NULL),('2015-03-03 04:28:43',21,0,9,NULL),('2015-03-03 04:28:58',1,7,10,NULL),('2015-03-03 04:28:58',12,7,10,NULL),('2015-03-03 04:28:58',21,0,10,NULL),('2015-03-03 04:29:13',1,7,11,NULL),('2015-03-03 04:29:13',12,7,11,NULL),('2015-03-03 04:29:13',21,0,11,NULL),('2015-03-03 04:29:27',1,7,12,NULL),('2015-03-03 04:29:27',12,7,12,NULL),('2015-03-03 04:29:27',21,0,12,NULL),('2015-03-03 04:30:17',1,7,13,NULL),('2015-03-03 04:30:17',12,7,13,NULL),('2015-03-03 04:30:17',21,0,13,NULL),('2015-03-03 04:30:31',1,7,14,NULL),('2015-03-03 04:30:31',12,7,14,NULL),('2015-03-03 04:30:31',21,0,14,NULL),('2015-03-03 04:30:34',16,7,NULL,NULL),('2015-03-03 04:30:48',15,8,8,NULL),('2015-03-03 04:31:14',1,8,15,NULL),('2015-03-03 04:31:14',12,8,15,NULL),('2015-03-03 04:31:14',21,0,15,NULL),('2015-03-03 04:31:36',1,8,16,NULL),('2015-03-03 04:31:36',12,8,16,NULL),('2015-03-03 04:31:36',21,0,16,NULL),('2015-03-03 04:31:49',1,8,17,NULL),('2015-03-03 04:31:49',12,8,17,NULL),('2015-03-03 04:31:49',21,0,17,NULL),('2015-03-03 04:32:01',1,8,18,NULL),('2015-03-03 04:32:01',12,8,18,NULL),('2015-03-03 04:32:01',21,0,18,NULL),('2015-03-03 04:32:12',1,8,19,NULL),('2015-03-03 04:32:12',12,8,19,NULL),('2015-03-03 04:32:12',21,0,19,NULL),('2015-03-03 04:32:46',1,8,20,NULL),('2015-03-03 04:32:46',12,8,20,NULL),('2015-03-03 04:32:46',21,0,20,NULL),('2015-03-03 04:33:25',1,8,21,NULL),('2015-03-03 04:33:25',12,8,21,NULL),('2015-03-03 04:33:26',21,8,21,NULL),('2015-03-03 04:33:29',16,8,NULL,NULL),('2015-03-03 04:33:42',15,8,8,NULL),('2015-03-03 04:33:49',16,8,NULL,NULL),('2015-03-03 04:34:01',15,9,9,NULL),('2015-03-03 04:35:25',1,9,22,NULL),('2015-03-03 04:35:25',12,9,22,NULL),('2015-03-03 04:35:25',21,9,22,NULL),('2015-03-03 04:35:50',1,9,23,NULL),('2015-03-03 04:35:50',12,9,23,NULL),('2015-03-03 04:35:51',21,0,23,NULL),('2015-03-03 04:36:01',1,9,24,NULL),('2015-03-03 04:36:01',12,9,24,NULL),('2015-03-03 04:36:01',21,0,24,NULL),('2015-03-03 04:36:10',1,9,25,NULL),('2015-03-03 04:36:10',12,9,25,NULL),('2015-03-03 04:36:10',21,0,25,NULL),('2015-03-03 04:36:22',1,9,26,NULL),('2015-03-03 04:36:22',12,9,26,NULL),('2015-03-03 04:36:22',21,0,26,NULL),('2015-03-03 04:36:25',16,9,NULL,NULL),('2015-03-03 04:36:34',15,10,10,NULL),('2015-03-03 04:36:59',1,10,27,NULL),('2015-03-03 04:36:59',12,10,27,NULL),('2015-03-03 04:36:59',21,0,27,NULL),('2015-03-03 04:37:11',1,10,28,NULL),('2015-03-03 04:37:11',12,10,28,NULL),('2015-03-03 04:37:11',21,0,28,NULL),('2015-03-03 04:37:25',1,10,29,NULL),('2015-03-03 04:37:25',12,10,29,NULL),('2015-03-03 04:37:26',21,0,29,NULL),('2015-03-03 04:37:38',1,10,30,NULL),('2015-03-03 04:37:38',12,10,30,NULL),('2015-03-03 04:37:38',21,0,30,NULL),('2015-03-03 04:37:58',1,10,31,NULL),('2015-03-03 04:37:58',12,10,31,NULL),('2015-03-03 04:37:58',21,0,31,NULL),('2015-03-03 04:38:11',1,10,32,NULL),('2015-03-03 04:38:11',12,10,32,NULL),('2015-03-03 04:38:12',21,0,32,NULL),('2015-03-03 04:38:29',1,10,33,NULL),('2015-03-03 04:38:29',12,10,33,NULL),('2015-03-03 04:38:30',21,0,33,NULL),('2015-03-03 04:39:02',1,10,34,NULL),('2015-03-03 04:39:02',12,10,34,NULL),('2015-03-03 04:39:02',14,NULL,NULL,57),('2015-03-03 04:39:03',21,10,34,NULL),('2015-03-03 04:39:06',16,10,NULL,NULL),('2015-03-03 04:39:15',15,12,12,NULL),('2015-03-03 04:39:33',1,12,35,NULL),('2015-03-03 04:39:33',12,12,35,NULL),('2015-03-03 04:39:33',21,0,35,NULL),('2015-03-03 04:39:42',16,12,NULL,NULL),('2015-03-03 04:45:06',14,NULL,NULL,58),('2015-03-03 04:45:06',15,4,4,NULL),('2015-03-03 04:47:03',1,4,36,NULL),('2015-03-03 04:47:03',12,4,36,NULL),('2015-03-03 23:12:37',15,4,4,NULL),('2015-03-03 23:15:59',13,4,4,NULL),('2015-03-03 23:16:04',16,4,NULL,NULL),('2015-03-03 23:16:09',15,4,4,NULL),('2015-03-03 23:16:11',16,4,NULL,NULL),('2015-03-03 23:16:17',23,NULL,NULL,59),('2015-03-03 23:16:22',15,4,4,NULL),('2015-03-03 23:16:32',9,4,1,NULL),('2015-03-03 23:16:32',9,4,2,NULL),('2015-03-03 23:16:33',9,4,3,NULL),('2015-03-03 23:16:41',16,4,NULL,NULL),('2015-03-03 23:17:16',15,5,5,NULL),('2015-03-03 23:18:07',16,5,NULL,NULL),('2015-03-03 23:19:04',23,NULL,NULL,60),('2015-03-03 23:19:13',23,NULL,NULL,61),('2015-03-03 23:19:18',23,NULL,NULL,62),('2015-03-03 23:19:21',23,NULL,NULL,63),('2015-03-03 23:19:23',23,NULL,NULL,64),('2015-03-03 23:19:27',15,4,4,NULL),('2015-03-03 23:19:51',1,4,37,NULL),('2015-03-03 23:19:51',12,4,37,NULL),('2015-03-03 23:19:52',9,4,37,NULL),('2015-03-03 23:21:19',2,4,36,65),('2015-03-03 23:21:41',16,4,NULL,NULL),('2015-03-03 23:21:45',15,5,5,NULL),('2015-03-03 23:21:49',9,5,4,NULL),('2015-03-03 23:21:50',9,5,5,NULL),('2015-03-03 23:21:50',9,5,6,NULL),('2015-03-03 23:21:53',16,5,NULL,NULL),('2015-03-03 23:21:57',15,6,6,NULL),('2015-03-03 23:22:01',9,6,7,NULL),('2015-03-03 23:22:01',9,6,8,NULL),('2015-03-03 23:22:05',16,6,NULL,NULL),('2015-03-03 23:22:20',15,7,7,NULL),('2015-03-03 23:22:26',9,7,9,NULL),('2015-03-03 23:22:26',9,7,10,NULL),('2015-03-03 23:22:27',9,7,11,NULL),('2015-03-03 23:22:28',9,7,12,NULL),('2015-03-03 23:22:28',9,7,13,NULL),('2015-03-03 23:22:29',9,7,14,NULL),('2015-03-03 23:22:40',16,7,NULL,NULL),('2015-03-03 23:22:57',15,8,8,NULL),('2015-03-03 23:23:05',9,8,15,NULL),('2015-03-03 23:23:06',9,8,16,NULL),('2015-03-03 23:23:06',9,8,17,NULL),('2015-03-03 23:23:07',9,8,18,NULL),('2015-03-03 23:23:07',9,8,19,NULL),('2015-03-03 23:23:08',9,8,20,NULL),('2015-03-03 23:23:08',9,8,21,NULL),('2015-03-03 23:23:36',1,8,38,NULL),('2015-03-03 23:23:37',12,8,38,NULL),('2015-03-03 23:23:43',2,8,38,66),('2015-03-03 23:23:51',16,8,NULL,NULL),('2015-03-03 23:23:58',15,9,9,NULL),('2015-03-03 23:24:03',9,9,22,NULL),('2015-03-03 23:24:04',9,9,23,NULL),('2015-03-03 23:24:04',9,9,24,NULL),('2015-03-03 23:24:05',9,9,25,NULL),('2015-03-03 23:24:05',9,9,26,NULL),('2015-03-03 23:24:15',16,9,NULL,NULL),('2015-03-03 23:24:19',15,10,10,NULL),('2015-03-03 23:24:24',9,10,27,NULL),('2015-03-03 23:24:24',9,10,28,NULL),('2015-03-03 23:24:25',9,10,29,NULL),('2015-03-03 23:24:26',9,10,30,NULL),('2015-03-03 23:24:26',9,10,31,NULL),('2015-03-03 23:24:27',9,10,32,NULL),('2015-03-03 23:24:27',9,10,33,NULL),('2015-03-03 23:24:28',9,10,34,NULL),('2015-03-03 23:24:44',16,10,NULL,NULL),('2015-03-03 23:24:51',15,11,11,NULL),('2015-03-03 23:25:38',1,11,39,NULL),('2015-03-03 23:25:39',12,11,39,NULL),('2015-03-03 23:25:39',21,11,35,NULL),('2015-03-03 23:25:45',16,11,NULL,NULL),('2015-03-03 23:25:50',15,14,14,NULL),('2015-03-03 23:27:10',16,14,NULL,NULL),('2015-03-03 23:27:14',15,4,4,NULL),('2015-03-03 23:29:09',7,4,29,NULL),('2015-03-03 23:29:55',7,4,28,NULL),('2015-03-03 23:29:58',16,4,NULL,NULL),('2015-03-03 23:30:03',15,10,10,NULL),('2015-03-03 23:30:15',16,10,NULL,NULL),('2015-03-03 23:30:18',15,5,5,NULL),('2015-03-03 23:30:41',7,5,31,NULL),('2015-03-03 23:30:43',7,5,30,NULL),('2015-03-03 23:30:44',7,5,29,NULL),('2015-03-03 23:30:46',7,5,28,NULL),('2015-03-03 23:30:48',7,5,27,NULL),('2015-03-03 23:30:53',16,5,NULL,NULL),('2015-03-03 23:31:02',4,20,NULL,NULL),('2015-03-03 23:31:54',4,21,NULL,NULL),('2015-03-03 23:32:32',15,21,21,NULL),('2015-03-03 23:33:50',1,21,40,NULL),('2015-03-03 23:33:51',12,21,40,NULL),('2015-03-03 23:33:51',21,21,36,NULL),('2015-03-03 23:35:30',9,21,40,NULL),('2015-03-03 23:35:59',7,21,29,NULL),('2015-03-03 23:36:33',7,21,24,NULL),('2015-03-03 23:36:38',16,21,NULL,NULL),('2015-03-03 23:36:44',15,9,9,NULL),('2015-03-03 23:37:30',3,21,24,NULL),('2015-03-03 23:37:50',7,9,40,NULL),('2015-03-03 23:37:53',16,9,NULL,NULL),('2015-03-03 23:38:04',15,21,21,NULL),('2015-03-03 23:38:14',3,9,40,NULL),('2015-03-03 23:38:32',7,21,37,NULL),('2015-03-03 23:38:37',7,21,34,NULL),('2015-03-03 23:38:44',16,21,NULL,NULL),('2015-03-03 23:38:47',15,4,4,NULL),('2015-03-03 23:38:52',3,21,37,NULL),('2015-03-03 23:39:03',16,4,NULL,NULL),('2015-03-03 23:39:07',15,10,10,NULL),('2015-03-03 23:39:19',3,4,28,NULL),('2015-03-03 23:39:33',3,21,34,NULL),('2015-03-03 23:40:15',3,5,29,NULL),('2015-03-03 23:43:26',16,10,NULL,NULL),('2015-03-03 23:43:39',15,21,21,NULL),('2015-03-03 23:44:56',16,21,NULL,NULL),('2015-03-03 23:45:00',15,4,4,NULL),('2015-03-03 23:45:26',11,21,37,NULL),('2015-03-03 23:45:26',10,4,37,NULL),('2015-03-03 23:45:31',16,4,NULL,NULL),('2015-03-03 23:45:36',15,21,21,NULL),('2015-03-04 00:12:26',16,21,NULL,NULL),('2015-03-04 00:12:31',15,4,4,NULL),('2015-03-04 00:18:12',19,4,4,NULL),('2015-03-04 00:18:12',17,4,28,NULL),('2015-03-04 00:18:19',16,4,NULL,NULL),('2015-03-04 00:18:24',15,21,21,NULL),('2015-03-04 00:20:57',16,21,NULL,NULL),('2015-03-04 00:21:00',15,10,10,NULL),('2015-03-04 00:52:42',16,10,NULL,NULL),('2015-03-04 00:53:06',15,7,7,NULL),('2015-03-04 00:53:14',7,7,33,NULL),('2015-03-04 00:53:28',15,10,10,NULL),('2015-03-04 00:53:52',3,7,33,NULL),('2015-03-04 00:54:10',11,7,33,NULL),('2015-03-04 00:54:10',6,10,33,NULL),('2015-03-04 00:54:45',7,10,14,NULL),('2015-03-04 00:55:01',7,10,13,NULL),('2015-03-04 00:55:03',7,10,12,NULL),('2015-03-04 00:55:12',3,10,12,NULL),('2015-03-04 00:55:37',3,10,13,NULL),('2015-03-04 00:55:45',19,7,10,NULL),('2015-03-04 00:55:45',17,7,12,NULL),('2015-03-04 00:55:55',11,10,13,NULL),('2015-03-04 00:55:55',6,7,13,NULL),('2015-03-04 00:56:10',3,10,14,NULL),('2015-03-04 01:02:24',1,10,41,NULL),('2015-03-04 01:02:24',12,10,41,NULL),('2015-03-04 01:02:24',21,0,37,NULL),('2015-03-04 01:07:08',1,10,42,NULL),('2015-03-04 01:07:08',12,10,42,NULL),('2015-03-04 01:17:59',1,10,43,NULL),('2015-03-04 01:17:59',12,10,43,NULL),('2015-03-04 01:17:59',21,0,38,NULL),('2015-03-04 01:39:02',1,10,44,NULL),('2015-03-04 01:39:02',12,10,44,NULL),('2015-03-04 01:41:23',1,10,45,NULL),('2015-03-04 01:41:23',12,10,45,NULL),('2015-03-04 01:41:23',22,NULL,45,NULL),('2015-03-04 01:41:38',1,10,46,NULL),('2015-03-04 01:41:38',12,10,46,NULL),('2015-03-04 01:41:38',21,0,39,NULL),('2015-03-04 01:41:41',9,10,46,NULL),('2015-03-04 01:42:26',1,10,47,NULL),('2015-03-04 01:42:26',12,10,47,NULL);
---DELIMITER---
INSERT INTO audit_notes (notes_id, notes) VALUES (1,'127.0.0.1'),(2,'127.0.0.1'),(3,'127.0.0.1'),(4,'127.0.0.1'),(5,'127.0.0.1'),(6,'127.0.0.1'),(7,'127.0.0.1'),(8,'127.0.0.1'),(9,'127.0.0.1'),(10,'127.0.0.1'),(11,'127.0.0.1'),(12,'ip: 127.0.0.1 name: victor_hugo pass: 5E884898DA'),(13,'127.0.0.1'),(14,'ip: 127.0.0.1 name: victorhugo pass: 5E884898DA'),(15,'127.0.0.1'),(16,'127.0.0.1'),(17,'127.0.0.1'),(18,'127.0.0.1'),(19,'127.0.0.1'),(20,'127.0.0.1'),(21,'127.0.0.1'),(22,'127.0.0.1'),(23,'127.0.0.1'),(24,'127.0.0.1'),(25,'ip: 127.0.0.1 name: cameron pass: 5E884898DA'),(26,'127.0.0.1'),(27,'127.0.0.1'),(28,'127.0.0.1'),(29,'127.0.0.1'),(30,'127.0.0.1'),(31,'127.0.0.1'),(32,'127.0.0.1'),(33,'127.0.0.1'),(34,'127.0.0.1'),(35,'127.0.0.1'),(36,'127.0.0.1'),(37,'127.0.0.1'),(38,'127.0.0.1'),(39,'127.0.0.1'),(40,'127.0.0.1'),(41,'127.0.0.1'),(42,'127.0.0.1'),(43,'127.0.0.1'),(44,'127.0.0.1'),(45,'127.0.0.1'),(46,'127.0.0.1'),(47,'127.0.0.1'),(48,'127.0.0.1'),(49,'127.0.0.1'),(50,'127.0.0.1'),(51,'ip: 127.0.0.1 name: elysa pass: 5E884898DA'),(52,'127.0.0.1'),(53,'127.0.0.1'),(54,'127.0.0.1'),(55,'127.0.0.1'),(56,'127.0.0.1'),(57,'127.0.0.1'),(58,'127.0.0.1'),(59,'ip: 127.0.0.1 name: bob pass: F24FEA324A'),(60,'ip: 127.0.0.1 name: dude pass: 5E884898DA'),(61,'ip: 127.0.0.1 name: bob pass: 659E3A155B'),(62,'ip: 127.0.0.1 name:  pass: 9440BB2237'),(63,'ip: 127.0.0.1 name:  pass: E3B0C44298'),(64,'ip: 127.0.0.1 name: asdf pass: E3B0C44298'),(65,'Let\'s see if this makes a loca|created:2015-03-03|pts:1|st:DRAFT'),(66,' Xenos Request Favor Logout 葉問|created:2015-03-03|pts:1|st:DRAFT');
---DELIMITER---
INSERT INTO location (location_id, address_line_1, address_line_2, city, state, postal_code, country) VALUES (1,'964 Woodland Avenue','','Atlanta','GA','30316','USA'),(2,'696 Argonne Avenue','Apt. 4','Atlanta','GA','30016','USA'),(5,'21031 Triple Seven Road','','Sterling','VA','20165','USA'),(7,'Sally\'s house','','Halloween town','','',''),(13,' jeune femme issue de la bourgeoisie','Victor Hugo auquel il donne son p','Paris','','12345','France'),(20,'1954年葉問開始無心教授并开始吸食鴉片，梁相和駱耀等時常好言相勸，最終（1955年）導致徐尚田以書面勸說，當時的主要弟子除了伍燦之外，都在信中簽署聯名。  當時的梁相、駱耀、徐尚','葉問看到書信後，一言不發，並找到伍燦幫助，','梁相身為大師兄，葉問認為','其他弟子都來交心並願意追隨終身','123123','China'),(21,'兩名正室兒子葉準和葉正於1962年到港，','生認為詠春拳是值得發揚的','年遷到二子葉正位於通','名。雙番北（鄭北','時慶祝61歲及1972年於油','2月2日，葉問於旺角通菜街'),(22,' 	1485 Medellín, Corona de Castilla','',' 	2 de diciembre de 1547 Castilleja de l','','12345','Spain'),(34,'2000 placewater place','','rusty','CA','12345','CA'),(35,'20600 PlacePlace place','apt place','Starling','VA','20000','USA'),(36,'<script>alert(\'strt1\')</script>','<script>alert(\'strt2\')</script>','<script>alert(\'city\')</script>','<script>alert(\'state\')</script','<script>alert(\'post\'','<script>alert(\'country\')</script>'),(37,'','','','','',''),(38,'','','','','',''),(39,'1234','','','','','');
---DELIMITER---
INSERT INTO location_to_requestoffer (location_id, requestoffer_id) VALUES (1,1),(2,2),(5,5),(7,7),(13,13),(20,20),(21,21),(22,22),(34,34),(34,45),(35,39),(36,40),(37,41),(38,43),(39,46);
---DELIMITER---
INSERT INTO location_to_user (location_id, user_id) VALUES (1,4),(2,4),(5,5),(7,6),(21,8),(22,9),(34,10),(35,11),(36,21);
---DELIMITER---
INSERT INTO requestoffer (requestoffer_id, datetime, description, points, requestoffering_user_id, handling_user_id) VALUES (1,'2015-03-03 04:22:09','Babysit my kids while we go out trick-R-treating',1,4,NULL),(2,'2015-03-03 04:22:51','Wash my windows from the outside',1,4,NULL),(3,'2015-03-03 04:23:39','Can someone help me with my history homework tonight?',1,4,NULL),(4,'2015-03-03 04:24:39','I can\'t go back to yesterday because I was a different person then.',1,5,NULL),(5,'2015-03-03 04:25:40','“But I don’t want to go among mad people,\" Alice remarked. \"Oh, you can’t help that,\" said the Cat: \"we’re all mad here. I’m mad. You’re mad.\" \"How do you know I’m mad?\" said Alice. \"You must be,\" sai',1,5,NULL),(6,'2015-03-03 04:26:07','“Begin at the beginning,\" the King said, very gravely, \"and go on till you come to the end: then stop.” ',1,5,NULL),(7,'2015-03-03 04:27:12','Dr. Finkelstein: Sally! You came back. Sally: I had to. Dr. Finkelstein: For this. [holds Sally\'s detatched arm; she causes it to wave at herself] Sally: [smiles] Yes. Dr. Finkelstein: Shall we, then?',1,6,NULL),(8,'2015-03-03 04:27:31','Jack Skellington: Sally! I need your help most of all. Sally: You certainly do, Jack. I\'ve had the most horrible vision! Jack Skellington: That\'s splendid! ',1,6,NULL),(9,'2015-03-03 04:28:42','Victor Hugo Prononciation du titre dans sa version originale Écouter, né le 26 février 1802 à Besançon et mort le 22 mai 1885 à Paris, est un poète, dramaturge et prosateur romantique considéré comme ',1,7,NULL),(10,'2015-03-03 04:28:57','Il est également un romancier du peuple qui rencontre un grand succès populaire avec notamment Notre-Dame de Paris (1831), et plus encore avec Les Misérables (1862).',1,7,NULL),(11,'2015-03-03 04:29:12','Son œuvre multiple comprend aussi des discours politiques à la Chambre des pairs, à l\'Assemblée constituante et à l\'Assemblée législative, notamment sur la peine de mort, l’école ou l’Europe, des réci',1,7,NULL),(12,'2015-03-03 04:29:26','Ses choix, à la fois moraux et politiques7, durant la deuxième partie de sa vie, et son œuvre hors du commun ont fait de lui un personnage emblématique, que la Troisième République a honoré à sa mort ',1,7,NULL),(13,'2015-03-03 04:30:16','Victor, Marie Hugo9 est le fils du général d\'Empire Joseph Léopold Sigisbert Hugo (1773‑1828), créé comte, selon la tradition familiale, par Joseph Bonaparte, roi d\'Espagne et en garnison dans le Doub',1,7,10),(14,'2015-03-03 04:30:30','e et la mesure13. Il est encouragé par sa mère à qui il lit ses œuvres, ainsi qu’à son frère Eugène. Ses écrits sont relus et corrigés par un jeune maître d’études de la pension Cordier qui s’est pris',1,7,10),(15,'2015-03-03 04:31:13','葉問（1893年10月1日－1972年12月2日[註 1]）原名葉繼問，曾經改名葉溢，祖籍廣東南海羅村鎮聯星譚頭村，出生於佛山，為詠春發揚人，師承陳華順，於1950年代在香港發揚詠春拳，被讚譽為「一代宗師」。',1,8,NULL),(16,'2015-03-03 04:31:36','葉問生於光緒二十五年（1899年）廣東佛山桑園大街葉家莊，莊內有芸草書塾，葉問在此啟蒙開學。葉家莊左邊大祠堂租予詠春拳名師陳華順，所以在五歲那年得以跟隨陳華順習武，並得到二師兄吳仲素指導，從此對功夫極度熱愛。1913年陳華順中风而死，吳仲素遷到普君墟綫香街設武館，葉問跟随他學習。葉問衣食無憂，對詠春極富熱忱，閒來與二師兄吳仲素及幾位同好互相研習，亦師亦友。空閒時間，吳葉兩人時常在姚才姚林開設的咏春',1,8,NULL),(17,'2015-03-03 04:31:48','1938年日本军隊占领佛山，汪精衛政權南海縣長兼警務長李道軒強取桑園葉家庄作為官邸，改名軒盧[6]。 作为情报掩护於1943年至1945年间，到佛山富商周雨耕與周清泉父子在永安路139號的「联倡」花纱店，传授詠春',1,8,NULL),(18,'2015-03-03 04:32:00','1949年，中华人民共和国成立，葉問因先前曾加入國民黨中统组织並擔任國軍上校隊長，害怕被清查及連累家眷，暫時留下妻子及三名年幼兒女，乘夜利用通行證與大',1,8,NULL),(19,'2015-03-03 04:32:11','葉問來到香港後一直與家人保持聯絡，以安排家人日後來港定居。妻子及兒女亦曾於1950年到香港領取身份證後返回佛山，可惜中英同時於1951年元旦宣佈封鎖香港邊境，從此永遠分別。[3]',1,8,NULL),(20,'2015-03-03 04:32:46','來港之初，得到好友港九飯店職工總會祕書李民（天培）的介紹，先安頓在深水埗大南街之港九飯店職工總會寄居,當時梁相本為該會主席,梁相自幼習武,於工餘在會館授拳，教授蔡李佛、龍形摩橋,梁相得知葉問曾習武',1,8,NULL),(21,'2015-03-03 04:33:25','葉問宗師晚年最大的心願便是集合同門組織成立一個聯會以發揚詠春拳。詠春體育會在1966年向香港警務處註冊成立社團，於彌敦道成立，後遷往旺角水渠道的自置會址，1974年正式註冊成為非牟利的有限公司。',1,8,NULL),(22,'2015-03-03 04:35:25','Hernán Cortés Monroy Pizarro Altamirano (Medellín, Corona de Castilla, 1485-Castilleja de la Cuesta, Corona de Castilla, 2 de diciembre de 1547) fue un conquistador español que lideró la expedición qu',1,9,NULL),(23,'2015-03-03 04:35:50','Hernán Cortés se casó dos veces y tuvo once hijos documentados en seis relaciones diferentes. Su primera esposa, doña Catalina Juárez Marcaida, murió tras cinco años de matrimonio estéril el 1 de novi',1,9,NULL),(24,'2015-03-03 04:36:00','Martín Cortés, nacido en Coyoacán en 1522. Su madre fue La Malinche, la compañera y traductora indígena de Cortés. Fue legitimado junto con sus hermanos Catalina y Luis en una bula papal de Clemente V',1,9,21),(25,'2015-03-03 04:36:09','Luis Cortés, nacido en 1525, y es hijo de la española Antonia o Elvira Hermosillo, y quien también será legitimado junto con Martín y Catalina. Se casó con doña Guiomar Vázquez de Escobar, sobrina del',1,9,NULL),(26,'2015-03-03 04:36:22','María Cortés, hija de una princesa mexica cuyo nombre se ignora. Bernal Díaz del Castillo menciona que nació con alguna deformación.',1,9,NULL),(27,'2015-03-03 04:36:58','Can you do my  math homework?',1,10,NULL),(28,'2015-03-03 04:37:10','can you do my physics homework?',1,10,NULL),(29,'2015-03-03 04:37:24','can you do my economics homework?',1,10,5),(30,'2015-03-03 04:37:38','can you do my history homework?',1,10,NULL),(31,'2015-03-03 04:37:57','Can you do my English homework?',1,10,NULL),(32,'2015-03-03 04:38:11','Babysit my parents',1,10,NULL),(33,'2015-03-03 04:38:29','walk my dog please, tonight.',1,10,7),(34,'2015-03-03 04:39:01','Drive me around town',1,10,21),(35,'2015-03-03 04:39:32','Finish my programming homework',1,12,NULL),(37,'2015-03-03 23:19:50','Watch my unruly three children',1,4,21),(39,'2015-03-03 23:25:38','Watch my wonderful, well-behaved children',1,11,NULL),(40,'2015-03-03 23:33:50','<script>alert(\'desc\')</script>',1,21,9),(41,'2015-03-04 01:02:23','Someone please do my English homework tonight',1,10,NULL),(42,'2015-03-04 01:07:07','economics1',1,10,NULL),(43,'2015-03-04 01:17:59','Someone please do my English homework tonight',1,10,NULL),(44,'2015-03-04 01:39:02','English',1,10,NULL),(45,'2015-03-04 01:41:22','Babysitting on Saturday',1,10,NULL),(46,'2015-03-04 01:41:38','Babysitting on Saturday',1,10,NULL),(47,'2015-03-04 01:42:25','Do my economics homework for tomorrow',1,10,NULL);
---DELIMITER---
INSERT INTO requestoffer_message (requestoffer_id, message, timestamp, from_user_id, to_user_id) VALUES (28,'cameron says:Thanks so much for doing my physics homework, you can see the pics of it at http://<script>alert(\'message\')</script>//here','2015-03-03 23:42:14',10,4),(34,'cameron says:<script>alert(\'username\')</script>  will always help you, they say.  Fine, I\'ll ask you - where can you drive me?','2015-03-03 23:43:21',10,21),(34,'<script>alert(\'username\')</script> says:You had better believe that <script>alert(\'username\')</script> will always help, cause I will!  I will drive you anywhere.','2015-03-03 23:44:28',21,10),(37,'<script>alert(\'username\')</script> says:Let me get my hands on those unruly kids and I\'ll make \'em ruly!','2015-03-03 23:44:51',21,4),(37,'bob says:thanks for making \' em ruly, you rule.','2015-03-03 23:45:23',4,21);
---DELIMITER---
INSERT INTO requestoffer_service_request (service_request_id, requestoffer_id, user_id, date_created, date_modified, status) VALUES (1,29,4,'2015-03-03 23:29:08','2015-03-03 23:40:14',108),(2,28,4,'2015-03-03 23:29:55','2015-03-03 23:39:19',107),(3,31,5,'2015-03-03 23:30:41',NULL,106),(4,30,5,'2015-03-03 23:30:42',NULL,106),(5,29,5,'2015-03-03 23:30:44','2015-03-03 23:40:14',107),(6,28,5,'2015-03-03 23:30:46','2015-03-03 23:39:19',108),(7,27,5,'2015-03-03 23:30:48',NULL,106),(8,29,21,'2015-03-03 23:35:59','2015-03-03 23:40:14',108),(9,24,21,'2015-03-03 23:36:33','2015-03-03 23:37:30',107),(10,40,9,'2015-03-03 23:37:50','2015-03-03 23:38:14',107),(11,37,21,'2015-03-03 23:38:32','2015-03-03 23:38:52',107),(12,34,21,'2015-03-03 23:38:37','2015-03-03 23:39:33',107),(13,33,7,'2015-03-04 00:53:14','2015-03-04 00:53:52',107),(14,14,10,'2015-03-04 00:54:44','2015-03-04 00:56:10',107),(15,13,10,'2015-03-04 00:55:01','2015-03-04 00:55:37',107),(16,12,10,'2015-03-04 00:55:03','2015-03-04 00:55:12',107);
---DELIMITER---
INSERT INTO requestoffer_state (requestoffer_id, status, datetime) VALUES (1,76,'2015-03-03 04:22:09'),(2,76,'2015-03-03 04:22:51'),(3,76,'2015-03-03 04:23:39'),(4,76,'2015-03-03 04:24:39'),(5,76,'2015-03-03 04:25:40'),(6,76,'2015-03-03 04:26:07'),(7,76,'2015-03-03 04:27:13'),(8,76,'2015-03-03 04:27:31'),(9,76,'2015-03-03 04:28:42'),(10,76,'2015-03-03 04:28:57'),(11,76,'2015-03-03 04:29:12'),(12,76,'2015-03-03 04:29:26'),(13,77,'2015-03-03 04:30:16'),(14,78,'2015-03-03 04:30:30'),(15,76,'2015-03-03 04:31:13'),(16,76,'2015-03-03 04:31:36'),(17,76,'2015-03-03 04:31:48'),(18,76,'2015-03-03 04:32:00'),(19,76,'2015-03-03 04:32:11'),(20,76,'2015-03-03 04:32:46'),(21,76,'2015-03-03 04:33:25'),(22,76,'2015-03-03 04:35:25'),(23,76,'2015-03-03 04:35:50'),(24,78,'2015-03-03 04:36:00'),(25,76,'2015-03-03 04:36:09'),(26,76,'2015-03-03 04:36:22'),(27,76,'2015-03-03 04:36:58'),(28,76,'2015-03-03 04:37:10'),(29,78,'2015-03-03 04:37:24'),(30,76,'2015-03-03 04:37:38'),(31,76,'2015-03-03 04:37:57'),(32,76,'2015-03-03 04:38:11'),(33,77,'2015-03-03 04:38:29'),(34,78,'2015-03-03 04:39:01'),(35,109,'2015-03-03 04:39:32'),(37,77,'2015-03-03 23:19:50'),(39,109,'2015-03-03 23:25:38'),(40,78,'2015-03-03 23:33:50'),(41,109,'2015-03-04 01:02:23'),(42,109,'2015-03-04 01:07:07'),(43,109,'2015-03-04 01:17:59'),(44,109,'2015-03-04 01:39:02'),(45,109,'2015-03-04 01:41:22'),(46,76,'2015-03-04 01:41:38'),(47,109,'2015-03-04 01:42:25');
---DELIMITER---
INSERT INTO requestoffer_to_category (requestoffer_id, requestoffer_category_id) VALUES (1,143),(2,73),(3,74),(4,145),(5,144),(6,73),(7,72),(8,75),(9,74),(10,74),(11,74),(12,71),(13,74),(14,74),(15,75),(16,73),(17,72),(18,72),(19,74),(20,73),(21,145),(22,74),(23,74),(24,75),(25,72),(26,71),(27,71),(28,72),(29,73),(30,74),(31,75),(32,143),(33,144),(34,145),(35,71),(37,143),(39,143),(40,143),(41,75),(42,73),(43,75),(44,75),(45,143),(46,143),(47,73);
---DELIMITER---
INSERT INTO system_to_user_message (stu_message_id, requestoffer_id, text_id, timestamp, to_user_id, has_been_viewed) VALUES (1,29,148,'2015-03-03 23:29:08',10,0),(2,28,148,'2015-03-03 23:29:55',10,0),(3,31,148,'2015-03-03 23:30:41',10,0),(4,30,148,'2015-03-03 23:30:43',10,0),(5,29,148,'2015-03-03 23:30:44',10,0),(6,28,148,'2015-03-03 23:30:46',10,0),(7,27,148,'2015-03-03 23:30:48',10,0),(8,29,148,'2015-03-03 23:35:59',10,0),(9,24,148,'2015-03-03 23:36:33',9,0),(10,24,132,'2015-03-03 23:37:30',21,0),(11,40,148,'2015-03-03 23:37:50',21,0),(12,40,132,'2015-03-03 23:38:14',9,0),(13,37,148,'2015-03-03 23:38:32',4,0),(14,34,148,'2015-03-03 23:38:37',10,0),(15,37,132,'2015-03-03 23:38:52',21,0),(16,28,132,'2015-03-03 23:39:19',4,0),(17,34,132,'2015-03-03 23:39:33',21,0),(18,29,132,'2015-03-03 23:40:15',5,0),(19,28,131,'2015-03-04 00:18:12',10,0),(20,28,136,'2015-03-04 00:18:12',4,0),(21,33,148,'2015-03-04 00:53:14',10,0),(22,33,132,'2015-03-04 00:53:52',7,0),(23,14,148,'2015-03-04 00:54:44',7,0),(24,13,148,'2015-03-04 00:55:01',7,0),(25,12,148,'2015-03-04 00:55:03',7,0),(26,12,132,'2015-03-04 00:55:12',10,0),(27,13,132,'2015-03-04 00:55:37',10,0),(28,12,131,'2015-03-04 00:55:45',10,0),(29,12,136,'2015-03-04 00:55:45',7,0),(30,14,132,'2015-03-04 00:56:10',10,0);
---DELIMITER---
INSERT INTO user_rank_data_point (urdp_id, date_entered, judge_user_id, judged_user_id, requestoffer_id, meritorious, status_id) VALUES (1,'2015-03-03 23:37:30',9,21,24,NULL,1),(2,'2015-03-03 23:46:09',21,9,24,1,3),(3,'2015-03-03 23:46:09',21,9,40,1,3),(4,'2015-03-03 23:38:14',9,21,40,NULL,1),(5,'2015-03-04 00:18:12',4,21,37,1,3),(6,'2015-03-03 23:46:09',21,4,37,1,3),(7,'2015-03-04 00:58:12',10,4,28,1,3),(8,'2015-03-04 00:18:12',4,10,28,1,3),(9,'2015-03-04 00:58:17',10,21,34,1,3),(10,'2015-03-03 23:46:09',21,10,34,1,3),(11,'2015-03-04 00:58:05',10,5,29,1,3),(12,'2015-03-03 23:40:14',5,10,29,NULL,1),(13,'2015-03-04 00:54:10',10,7,33,1,3),(14,'2015-03-04 00:57:48',7,10,33,1,3),(15,'2015-03-04 00:55:45',7,10,12,1,3),(16,'2015-03-04 00:57:39',10,7,12,1,3),(17,'2015-03-04 00:55:55',7,10,13,1,3),(18,'2015-03-04 00:58:27',10,7,13,1,3),(19,'2015-03-04 00:56:10',7,10,14,NULL,1),(20,'2015-03-04 00:56:10',10,7,14,NULL,1);
---DELIMITER---
SET FOREIGN_KEY_CHECKS=1;
