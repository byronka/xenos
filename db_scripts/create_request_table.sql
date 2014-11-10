CREATE TABLE IF NOT EXISTS 
request ( 
  request_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  datetime DATETIME,
  description NVARCHAR(1000),
  points INT,
  status VARCHAR(100),
  title NVARCHAR(255),
  requesting_user INT NOT NULL,
  FOREIGN KEY FK_requesting_user_user_id (requesting_user) 
    REFERENCES user (user_id) 
    ON DELETE CASCADE
);
