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

