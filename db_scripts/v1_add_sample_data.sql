/*------------
 
     users

 ------------*/

INSERT INTO user
(first_name, last_name, email, password, is_logged_in, last_time_logged_in, last_ip_logged_in)
VALUES
("byron","katz","bk@coolnet", "password",1,"2014-11-11","198.24.24.26"),
("dan","simone","ds@coolnet", "password",1,"2014-11-11","198.24.24.27")

---DELIMITER---


/*------------
 
   requests

 ------------*/


---DELIMITER---

INSERT INTO request 
(datetime, description, points, status, title, requesting_user_id) 
VALUES 
(NOW(), "a fine description for a request", 30, 1, "A great title", 1),
(NOW(), "Gotta job for ya", 10, 1, "Throw momma from the train", 1),
(NOW(), "rob the bank, get the money", 50, 1, "rob bank", 2),
(NOW(), "do my homework", 15, 1, "homework", 2);


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
VALUES(1,1),(2,1),(3,1),(4,1);
