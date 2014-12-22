/*------------
 
     users

 ------------*/

INSERT INTO user
(first_name, last_name, email, password, is_logged_in, last_time_logged_in, last_ip_logged_in, points)
VALUES
("byron","katz","bk@coolnet", "password",1,"2014-11-11","198.24.24.26", 100),
("<script>alert('dude')</script>","<script>alert('boy')</script>","dude", "password",1,"2014-11-11","198.24.24.26", 100),
("dan","simone","ds@coolnet", "password",1,"2014-11-11","198.24.24.27", 100)

---DELIMITER---


/*------------
 
   requests

 ------------*/


---DELIMITER---

INSERT INTO request 
(datetime, description, points, status, title, requesting_user_id) 
VALUES 
("2014-12-18 21:22:42", "a fine description for a request", 30, 1, "A great title", 1),
("2014-12-18 21:22:42", "Gotta job for ya", 10, 1, "Throw momma from the train", 1),
("2014-12-18 21:22:42", "rob the bank, get the money", 50, 1, "rob bank", 2),
("2014-12-18 21:22:42", "do my homework", 15, 1, "homework", 2),
("2014-12-18 21:22:42", "<script>alert('homework is bad')</script>", 15, 1, "<script>alert('I hate homework')</script>", 2);


---DELIMITER---
-- now we put our enums into the request_category table.
-- these are intentionally in all-caps to emphasize they are not
-- supposed to go straight to the client.  They must be localized first.
-- this should be easy to expand later.
INSERT INTO request_category (request_category_value)
VALUES('MATH'),('PHYSICS'),('ECONOMICS'),('HISTORY'),('ENGLISH');

---DELIMITER---
-- Here we set up all the requests to have some categories.
INSERT INTO request_to_category (request_id, request_category_id)
VALUES(1,1),(1,3),(1,4),(2,1),(3,1),(3,2),(4,4);



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

