SET FOREIGN_KEY_CHECKS=0;

---DELIMITER---

/*------------
 
     users

 ------------*/

INSERT INTO user
(username, email, password, is_logged_in, last_time_logged_in, last_ip_logged_in, points)
VALUES
("bk","bk@coolnet", "password",1,"2014-11-11","198.24.24.26", 100),
("ds","ds@coolnet", "password",1,"2014-11-11","198.24.24.27", 100),
("<script>alert('wow')</script>","<script>alert('dude')</script>", "password",1,"2014-11-11","198.24.24.26", 100)


---DELIMITER---


/*------------
 
   REQUESTS

 ------------*/


INSERT INTO request 
(datetime, description, points, status, title, requesting_user_id) 
VALUES 
("2014-12-31 21:22:42", "a fine description for a request", 30, 1, "A great title", 1),
("2014-10-20 21:22:42", "Gotta job for ya", 10, 1, "Throw momma from the train", 1),
("2014-12-18 21:22:42", "rob the bank, get the money", 50, 1, "rob bank", 2),
("2014-8-27 21:22:42", "do my homework", 15, 1, "homework", 2),
("2014-9-18 21:22:42", "<script>alert('homework is bad')</script>", 15, 1, "<script>alert('I hate homework')</script>", 2),
("2012-1-8 5:44:00", "Do stuff, I don't care, just do it", 15, 1, "do stuff", 2),
("2010-2-24 2:13:20", "This is not the end of the end, nor is it the beginning of the end.  It is the end of the beginning", 15, 1, "This is the title", 2),
("2014-3-8 18:45:02", "Get me some illegal narcotics, ship them safely to my home", 15, 1, "get drugs", 3),
("2010-7-27 21:22:42", "description goes here", 15, 1, "homework A", 2),
("2011-6-20 21:22:42", "description goes here", 15, 1, "homework B", 2),
("2012-5-27 23:22:42", "description goes here", 15, 1, "homework C", 2),
("2013-4-10 23:59:59", "description goes here", 15, 1, "homework D", 2),
("2013-4-10 23:59:59", "description goes here", 15, 1, "homework E", 2),
("2013-4-10 23:59:59", "description goes here", 15, 1, "homework F", 2),
("2013-4-10 22:59:59", "description goes here", 15, 1, "homework G", 2),
("2013-4-10 21:59:59", "description goes here", 15, 1, "homework H", 2),
("2013-4-10 20:59:59", "description goes here", 15, 1, "homework I", 2),
("2013-4-10 23:59:59", "description goes here", 15, 1, "homework J", 2),
("2013-4-10 23:59:59", "description goes here", 15, 1, "homework K", 2),
("2013-4-10 23:59:59", "description goes here", 15, 1, "homework L", 2),
("2013-4-10 23:59:59", "description goes here", 15, 1, "homework M", 2),
("2013-4-10 23:59:59", "description goes here", 15, 1, "homework N", 2),
("2013-4-10 23:59:59", "description goes here", 15, 1, "homework O", 2),
("2013-4-10 23:59:59", "description goes here", 15, 1, "homework P", 2),
("2013-4-10 23:59:59", "description goes here", 15, 1, "homework Q", 2),
("2014-3-27 00:00:01", "description goes here", 15, 1, "homework R", 2);


---DELIMITER---
-- now we put our enums into the request_category table.
-- these are intentionally in all-caps to emphasize they are not
-- supposed to go straight to the client.  They must be localized first.
-- this should be easy to expand later.
INSERT INTO request_category (request_category_value, localization_value )
VALUES('MATH',71),('PHYSICS',72),('ECONOMICS',73),('HISTORY',74),('ENGLISH',75);



---DELIMITER---
-- Here we set up all the requests to have some categories.
INSERT INTO request_to_category (request_id, request_category_id)
VALUES(1,1),(1,3),(1,4),(2,1),(3,1),(3,2),(4,4),(5,2),(6,1),(7,4),(8,5),(9,5),(10,2),(11,2),(12,2),(13,2),(14,2),(15,2),(16,2),(17,2),(18,2),(19,2),(20,2),(21,2),(22,2),(23,2),(24,2),(25,2),(26,2);



---DELIMITER---
-- add some messages for some requests
INSERT INTO request_message (request_id, message, timestamp, user_id)
VALUES 
(1, "Hi there mom!","2014-12-18 21:22:42",1 ),
(1,"What do ya know?","2014-12-18 21:22:43",1 ),
(1,"this sure is fun!","2014-12-18 21:22:44",1 ),
(2,"<script>alert('neato words')</script>","2014-12-18 21:22:45",1 ),
(2,"byron: What we could do is to do something or other","2014-12-18 21:22:46",1 ),
(2,"dan: what do you think about this then?","2014-12-18 21:22:47",2 )


---DELIMITER---

SET FOREIGN_KEY_CHECKS=1;
