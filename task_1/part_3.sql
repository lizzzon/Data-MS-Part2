CREATE OR REPLACE FUNCTION part_3()
    RETURNS VARCHAR AS $$
DECLARE even_number INT;
DECLARE odd_number INT;
BEGIN
    even_number := (SELECT COUNT(*) FROM my_table WHERE (val % 2) = 0);
    odd_number := (SELECT COUNT(*) FROM my_table WHERE (val % 2) = 1);
    IF (even_number > odd_number) THEN
        RETURN 'TRUE';
    ELSIF (even_number < odd_number) THEN
        RETURN 'FALSE';
    ELSE
        RETURN 'EQUAL';
    END IF;
END
$$ language 'plpgsql' STRICT;

SELECT part_3()