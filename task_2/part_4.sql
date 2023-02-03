CREATE TABLE logging (
    new_id          INT,
    old_id          INT,
    new_name        VARCHAR(32),
    old_name        VARCHAR(32),
    new_group_id    INT,
    old_group_id    INT,
    logs            VARCHAR(8),
    time_stamp      TIMESTAMP
);

CREATE OR REPLACE FUNCTION user_logs()
RETURNS TRIGGER AS $logging$
    BEGIN
        IF (TG_OP = 'INSERT') THEN
            INSERT INTO logging(new_id, new_name, new_group_id, logs, time_stamp)
                VALUES (NEW.id, NEW.student_name, NEW.group_id,
                        'INSERT', current_timestamp);
            RETURN NEW;
        ELSIF (TG_OP = 'UPDATE') THEN
            INSERT INTO logging(new_id, old_id, new_name, old_name,
                                new_group_id, old_group_id, logs, time_stamp)
                VALUES (NEW.id, OLD.id, NEW.student_name, OLD.student_name, NEW.group_id, OLD.group_id,
                        'UPDATE', current_timestamp);
            RETURN NULL;
        ELSIF (TG_OP = 'DELETE') THEN
            INSERT INTO logging(old_id, old_name, old_group_id, logs, time_stamp)
                VALUES (OLD.id, OLD.student_name, OLD.group_id,
                        'DELETE', current_timestamp);
            RETURN OLD;
        END IF;
    END
$logging$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER student_logging
AFTER INSERT OR UPDATE OR DELETE ON students
FOR EACH ROW EXECUTE FUNCTION user_logs();

---TEST---
INSERT INTO students(student_name, group_id) VALUES('Sasha', 2);
INSERT INTO students(student_name, group_id) VALUES('Misha', 5);

UPDATE students SET group_id = 5 WHERE student_name = 'Sasha';
UPDATE students SET group_id = 6 WHERE student_name = 'Misha';

DELETE FROM students WHERE student_name = 'Sasha' or student_name = 'Misha';
DELETE FROM groups WHERE id = 2;