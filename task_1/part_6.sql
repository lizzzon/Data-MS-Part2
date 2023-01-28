CREATE OR REPLACE FUNCTION calculate(month_celery DECIMAL, per INT)
    RETURNS DECIMAL AS $$
DECLARE price DECIMAL;
BEGIN
    price := ((1 + (per::DECIMAL / 100)) * 12 * month_celery);
    RETURN price;
END
$$ language 'plpgsql' STRICT;


CREATE OR REPLACE FUNCTION part_6(month_celery DECIMAL, per INT)
    RETURNS DECIMAL AS $$
BEGIN
    IF (month_celery > 0 AND per > 0) THEN
        RETURN calculate(month_celery, per);
    ELSE
        RAISE NOTICE 'month_celery and per must be > 0';
        RETURN 0.0;
    END IF;
END
$$ language 'plpgsql' STRICT;


SELECT part_6(100, 10);
SELECT part_6(0, 0);
SELECT part_6(-100, 50);