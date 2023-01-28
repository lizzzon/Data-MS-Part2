CREATE OR REPLACE FUNCTION part_4(current_id INT)
    RETURNS VARCHAR AS $$
DECLARE current_val INT;
BEGIN
    current_val := (SELECT val::varchar(5) FROM my_table WHERE id = current_id);
    RETURN CONCAT('INSERT INTO my_table (val) VALUES (', current_val, ');');
END
$$ language 'plpgsql' STRICT;

SELECT part_4(2)