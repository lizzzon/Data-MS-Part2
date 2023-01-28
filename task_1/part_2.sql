DO $$
BEGIN
    FOR cnt IN 1..10000 loop
        INSERT INTO my_table (val) VALUES (
            floor(random() * (1000-1+1) + 1)::int
        );
    END loop;
END; $$;