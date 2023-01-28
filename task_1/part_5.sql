CREATE OR REPLACE PROCEDURE insert_data(current_val INT)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO my_table (val) VALUES (current_val);
END;
$$;


CREATE OR REPLACE PROCEDURE update_data(current_id INT, new_val INT)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE my_table SET val = new_val WHERE id = current_id;
END;
$$;


CREATE OR REPLACE PROCEDURE delete_data(current_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM my_table WHERE id = current_id;
END;
$$;


CALL insert_data(10);
CALL update_data(2, 11);
CALL delete_data(3);