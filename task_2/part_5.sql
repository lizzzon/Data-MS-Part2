CREATE OR REPLACE PROCEDURE restore_student(rest_time timestamp)
LANGUAGE plpgsql AS $$
DECLARE loggs CURSOR FOR SELECT *
                          FROM logging
                          WHERE time_stamp > rest_time
                          ORDER BY time_stamp DESC;
    BEGIN
        FOR entry_log in loggs loop
            CASE entry_log.logs
                WHEN 'UPDATE' THEN
                    UPDATE students SET
                        id = entry_log.old_id,
                        student_name = entry_log.old_name,
                        group_id = entry_log.old_group_id
                    WHERE id = entry_log.new_id;
                WHEN 'INSERT' THEN
                    DELETE FROM students WHERE id = entry_log.new_id;
                WHEN 'DELETE' THEN
                    INSERT INTO students(id, student_name, group_id)
                        VALUES (entry_log.old_id,
                                entry_log.old_name,
                                entry_log.old_group_id);
            END CASE;
        END loop;
    END;
$$;

CREATE OR REPLACE PROCEDURE restore_student_data(need_time timestamp)
LANGUAGE plpgsql AS $$
    BEGIN
        CALL restore_student(current_timestamp - need_time);
    END;
$$;

CALL restore_student(to_timestamp('2023-01-30 16:55:00', 'YYYY-MM-DD HH24:MI:SS')::timestamp);
