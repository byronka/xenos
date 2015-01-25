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
("2014-12-31 21:22:42", "a fine description for a request", 30, 1, "A great title", 4),
("2014-10-20 21:22:42", "Gotta job for ya", 10, 1, "Throw momma from the train", 4),
("2014-12-18 21:22:42", "rob the bank, get the money", 50, 1, "rob bank", 5),
("2014-8-27 21:22:42", "do my homework", 15, 1, "homework", 5),
("2014-9-18 21:22:42", "<script>alert('homework is bad')</script>", 15, 1, "<script>alert('I hate homework')</script>", 5),
("2012-1-8 5:44:00", "Do stuff, I don't care, just do it", 15, 1, "do stuff", 5),
("2010-2-24 2:13:20", "This is not the end of the end, nor is it the beginning of the end.  It is the end of the beginning", 15, 1, "This is the title", 5),
("2014-3-8 18:45:02", "Get me some illegal narcotics, ship them safely to my home", 15, 1, "get drugs", 5),
("2010-7-27 21:22:42", "description goes here", 15, 1, "homework A", 5),
("2011-6-20 21:22:42", "description goes here", 15, 1, "homework B", 5),
("2012-5-27 23:22:42", "description goes here", 15, 1, "homework C", 5),
("2013-4-10 23:59:59", "description goes here", 15, 1, "homework D", 5),
("2013-4-10 23:59:59", "description goes here", 15, 1, "homework E", 5),
("2013-4-10 23:59:59", "description goes here", 15, 1, "homework F", 5),
("2013-4-10 22:59:59", "description goes here", 15, 1, "homework G", 5),
("2013-4-10 21:59:59", "description goes here", 15, 1, "homework H", 5),
("2013-4-10 20:59:59", "description goes here", 15, 1, "homework I", 5),
("2013-4-10 23:59:59", "description goes here", 15, 1, "homework J", 5),
("2013-4-10 23:59:59", "description goes here", 15, 1, "homework K", 5),
("2013-4-10 23:59:59", "description goes here", 15, 1, "homework L", 5),
("2013-4-10 23:59:59", "description goes here", 15, 1, "homework M", 5),
("2013-4-10 23:59:59", "description goes here", 15, 1, "homework N", 5),
("2013-4-10 23:59:59", "description goes here", 15, 1, "homework O", 5),
("2013-4-10 23:59:59", "description goes here", 15, 1, "homework P", 5),
("2013-4-10 23:59:59", "description goes here", 15, 1, "homework Q", 5),
("2014-3-27 00:00:01", "description goes here", 15, 1, "homework R", 5);




---DELIMITER---
-- Here we set up all the requests to have some categories.
INSERT INTO request_to_category (request_id, request_category_id)
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
