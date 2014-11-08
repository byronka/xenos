DELIMITER //
CREATE PROCEDURE register_user_cookie
(IN user_id_param INT) 
BEGIN 
DELETE FROM guid_to_user WHERE user_id = user_id_param; 
INSERT guid_to_user (guid, user_id) VALUES (UUID(),user_id_param);  
END//
DELIMITER ;
