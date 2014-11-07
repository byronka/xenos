ALTER TABLE user 
ADD COLUMN (
  is_logged_in BOOL, 
  last_time_logged_in DATETIME,
  last_ip_logged_in VARCHAR(40)
)
