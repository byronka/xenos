DROP FUNCTION IF EXISTS dec_deg_to_rad;   

---DELIMITER---

-- converts decimal degrees to radians.  Pretty basic.

CREATE FUNCTION dec_deg_to_rad
(
  degree_value DOUBLE
)
RETURNS DOUBLE DETERMINISTIC
BEGIN
  RETURN (PI()/180) * degree_value;
END

---DELIMITER---

DROP FUNCTION IF EXISTS calc_approx_dist;   

---DELIMITER---

-- given two postal codes, get distance in miles
-- uses spherical law of cosines.  Approximately correct, seems performant.
-- gives distance as crow flies.  Should probably make that clear to user.

CREATE FUNCTION calc_approx_dist
(
  the_country_id_1 INT,
  the_postal_code_id_1 INT,
  the_country_id_2 INT,
  the_postal_code_id_2 INT
)
RETURNS DOUBLE DETERMINISTIC READS SQL DATA
BEGIN
    DECLARE lat_first, lat_second DOUBLE;
    DECLARE long_first, long_second DOUBLE; 
    DECLARE lat_first_rad, lat_second_rad DOUBLE;
    DECLARE long_first_rad, long_second_rad DOUBLE;
    DECLARE delta_long DOUBLE;
    DECLARE earth_radius DOUBLE;
    DECLARE distance DOUBLE;

    IF the_country_id_1 IS NULL OR 
      the_country_id_2 IS NULL OR 
      the_postal_code_id_1 IS NULL OR 
      the_postal_code_id_2 IS NULL
      THEN RETURN NULL;
    END IF;

    SELECT pcla.latitude, pclo.longitude INTO lat_first, long_first
    FROM postal_code_latitude pcla
    JOIN postal_code_longitude pclo 
      ON pclo.postal_code_id = pcla.postal_code_id 
        AND pclo.country_id = pcla.country_id
    WHERE pclo.postal_code_id = the_postal_code_id_1 
      AND pclo.country_id = the_country_id_1;

    SELECT pcla.latitude, pclo.longitude INTO lat_second, long_second
    FROM postal_code_latitude pcla
    JOIN postal_code_longitude pclo 
      ON pclo.postal_code_id = pcla.postal_code_id 
        AND pclo.country_id = pcla.country_id
    WHERE pclo.postal_code_id = the_postal_code_id_2 
      AND pclo.country_id = the_country_id_2;

    SET lat_first_rad = dec_deg_to_rad(lat_first);
    SET lat_second_rad = dec_deg_to_rad(lat_second);

    SET long_first_rad = dec_deg_to_rad(long_first);
    SET long_second_rad = dec_deg_to_rad(long_second);


    SET delta_long = long_second_rad - long_first_rad;
    SET earth_radius = 3958.76; -- earth radius in miles approximately

    SET distance = 
        ACOS
          ( 
          SIN(lat_first_rad) *
          SIN(lat_second_rad) + 
          COS(lat_first_rad) *
          COS(lat_second_rad) * 
          COS(delta_long) 
          ) * earth_radius;

  RETURN distance;
END

