CREATE TABLE IF NOT EXISTS 
  user (
    user_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    first_name NVARCHAR(100),
    last_name NVARCHAR(100),
    email NVARCHAR(200),
    password NVARCHAR(100)
  );
