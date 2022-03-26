DELIMITER //

CREATE FUNCTION degreesToRadians ( degrees DOUBLE)
RETURNS DOUBLE
DETERMINISTIC

BEGIN
   DECLARE deg1 DOUBLE;
   SET deg1 = PI() / 180.0;
   RETURN degrees * deg1;
END; //

DELIMITER ;
