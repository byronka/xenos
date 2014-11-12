/*------------
 
     users

 ------------*/

INSERT INTO user
(first_name, last_name, email, password, is_logged_in, last_time_logged_in, last_ip_logged_in)
VALUES
("byron","katz","bk@coolnet", "password",1,"2014-11-11","198.24.24.26")

---DELIMITER---

INSERT INTO user
(first_name, last_name, email, password, is_logged_in, last_time_logged_in, last_ip_logged_in)
VALUES
("dan","simone","ds@coolnet", "password",1,"2014-11-11","198.24.24.27")

---DELIMITER---


/*------------
 
   requests

 ------------*/


---DELIMITER---

INSERT INTO request 
(datetime, description, points, status, title, requesting_user) 
VALUES 
(NOW(), "a fine description for a request", 3, "ACTIVE", "A great title", 1);

---DELIMITER---

INSERT INTO request 
(datetime, description, points, status, title, requesting_user) 
VALUES 
(NOW(), "Gotta job for ya", 3, "ACTIVE", "Throw momma from the train", 1);

