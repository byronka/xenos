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
  pcode1 VARCHAR(30),
  pcode2 VARCHAR(30)
)
RETURNS DOUBLE DETERMINISTIC READS SQL DATA
BEGIN

    IF pcode1 IS NULL OR pcode1 = '' OR pcode2 IS NULL OR pcode2 = '' THEN 
      RETURN NULL;
    END IF;

    SELECT latitude, longitude INTO @lat_first, @long_first
    FROM postal_codes
    WHERE postal_code = pcode1;

    SELECT latitude, longitude INTO @lat_second, @long_second
    FROM postal_codes
    WHERE postal_code = pcode2;

    SET @lat_first_rad = dec_deg_to_rad(@lat_first);
    SET @lat_second_rad = dec_deg_to_rad(@lat_second);

    SET @long_first_rad = dec_deg_to_rad(@long_first);
    SET @long_second_rad = dec_deg_to_rad(@long_second);

    SET @delta_long = @long_second_rad - @long_first_rad;
    SET @earth_radius = 3958.76; -- earth radius in miles approximately

    SET @distance = 
        ACOS
          ( 
          SIN(@lat_first_rad) *
          SIN(@lat_second_rad) + 
          COS(@lat_first_rad) *
          COS(@lat_second_rad) * 
          COS(@delta_long) 
          ) * @earth_radius;

    RETURN @distance;
END

