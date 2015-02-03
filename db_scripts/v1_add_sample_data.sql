SET FOREIGN_KEY_CHECKS=0;

---DELIMITER---

/*------------
 
     users

 ------------*/

INSERT INTO user
( username, email , password                                                         , points , language , is_logged_in , date_created        , salt                , last_time_logged_in , last_ip_logged_in , rank , is_admin )
VALUES
( 'bob'    , NULL  ,'389EA2EDD0D01B416CCA07D7E5EB36D7E98A4D7406F98559AAE0082CD4943C2A',    100 ,        1 ,         NULL ,'2015-01-31 04:05:54','4647350076936507137', NULL                , NULL              ,   50 ,        0 ),
( 'sally'  , NULL  ,'F8447927FF83B47E084D430ABABC66FC1A47BBCF6DBA4D60A8FE40CCE7E7E7DA',    100 ,        1 ,         NULL ,'2015-01-31 04:06:03','7526054207525219118', NULL                , NULL              ,   50 ,        0 ),
( 'alice'  , NULL  ,'F60370D4FEEB445A3170329052A5F6377F15749524AF7F2C789DB5DA66D5EC15',    100 ,        1 ,         NULL ,'2015-01-31 04:06:12','8343535681861390929', NULL                , NULL              ,   50 ,        0 ),
( "<script>alert('wow')</script>" , NULL  ,'4F45715CCBCBB506795356D085AC349BC02CB49BADA070E5F1F544F9CB04F6B7',    100 ,        1 ,            1 ,'2015-01-31 04:06:21','1683430133699830866','2015-01-31 04:08:09','127.0.0.1'        ,   50 ,        0 );

-- password for everyone is "password"


---DELIMITER---


/*------------
 
   REQUESTOFFERS

 ------------*/


INSERT INTO requestoffer 
(datetime, description, points, status, title, requestoffering_user_id) 
VALUES 
("2014-12-31 21:22:42",   "a fine description for a requestoffer", 30, 76, "A great title", 4),
("2014-10-20 21:22:42",   "Gotta job for ya", 10, 76, "Throw momma from the train", 4),
("2014-12-18 21:22:42",   "rob the bank, get the money", 50, 76, "rob bank", 5),
("2014-8-27 21:22:42",    "do my homework", 15, 76, "homework", 5),
("2014-9-18 21:22:42",    "<script>alert('homework is bad')</script>", 15, 76, "<script>alert('I hate homework')</script>", 5),
("2012-1-8 5:44:00",      "Do stuff, I don't care, just do it", 15, 76, "do stuff", 5),
("2010-2-24 2:13:20",     "This is not the end of the end, nor is it the beginning of the end.  It is the end of the beginning", 15, 76, "This is the title", 5),
("2014-3-8 18:45:02",     "Get me some illegal narcotics, ship them safely to my home", 15, 76, "get drugs", 5),
("2010-7-27 21:22:42",    "description goes here", 15, 76, "homework A", 5),
("2011-6-20 21:22:42",    "description goes here", 15, 76, "homework B", 5),
("2012-5-27 23:22:42",    "description goes here", 15, 76, "homework C", 5),
("2013-4-10 23:59:59",    "description goes here", 15, 76, "homework D", 5),
("2013-4-10 23:59:59",    "description goes here", 15, 76, "homework E", 5),
("2013-4-10 23:59:59",    "description goes here", 15, 76, "homework F", 5),
("2013-4-10 22:59:59",    "description goes here", 15, 76, "homework G", 5),
("2013-4-10 21:59:59",    "description goes here", 15, 76, "homework H", 5),
("2013-4-10 20:59:59",    "description goes here", 15, 76, "homework I", 5),
("2013-4-10 23:59:59",    "description goes here", 15, 76, "homework J", 5),
("2013-4-10 23:59:59",    "description goes here", 15, 76, "homework K", 5),
("2013-4-10 23:59:59",    "description goes here", 15, 76, "homework L", 5),
("2013-4-10 23:59:59",    "description goes here", 15, 76, "homework M", 5),
("2013-4-10 23:59:59",    "description goes here", 15, 76, "homework N", 5),
("2013-4-10 23:59:59",    "description goes here", 15, 76, "homework O", 5),
("2013-4-10 23:59:59",    "description goes here", 15, 76, "homework P", 5),
("2013-4-10 23:59:59",    "description goes here", 15, 76, "homework Q", 5),
("2014-3-27 00:00:01",    "description goes here", 15, 76, "homework R", 5);




---DELIMITER---
-- Here we set up all the requestoffers to have some categories.
INSERT INTO requestoffer_to_category (requestoffer_id, requestoffer_category_id)
VALUES
(1,71),
(1,73),
(1,74),
(2,71),
(3,71),
(3,72),
(4,74),
(5,72),
(6,71),
(7,74),
(8,75),
(9,75),
(10,72),
(11,72),
(12,72),
(13,72),
(14,72),
(15,72),
(16,72),
(17,72),
(18,72),
(19,72),
(20,72),
(21,72),
(22,72),
(23,72),
(24,72),
(25,72),
(26,72);



---DELIMITER---
-- add some messages for some requestoffers
INSERT INTO requestoffer_message (requestoffer_id, message, timestamp, user_id)
VALUES 
(1, "Hi there mom!","2014-12-18 21:22:42",4 ),
(1, "What do ya know?","2014-12-18 21:22:43",4 ),
(1, "this sure is fun!","2014-12-18 21:22:44",4 ),
(2, "<script>alert('neato words')</script>","2014-12-18 21:22:45",4 ),
(2, "byron: What we could do is to do something or other","2014-12-18 21:22:46",4 ),
(2, "dan: what do you think about this then?","2014-12-18 21:22:47",5 )


---DELIMITER---

SET FOREIGN_KEY_CHECKS=1;
