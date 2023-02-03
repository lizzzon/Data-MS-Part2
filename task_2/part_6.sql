TRUNCATE TABLE students;
TRUNCATE TABLE groups;

CREATE OR REPLACE FUNCTION group_c_val()
RETURNS TRIGGER AS $unique_test$
    BEGIN
        IF (TG_OP = 'INSERT') THEN
            UPDATE groups SET c_val = c_val + 1
                WHERE id = NEW.group_id;
            RETURN NEW;
        ELSIF (TG_OP = 'UPDATE') THEN
            IF NEW.group_id != OLD.group_id THEN
                UPDATE groups SET c_val = c_val - 1
                    WHERE id = OLD.group_id;
                UPDATE groups SET c_val = c_val + 1
                    WHERE id = NEW.group_id;
            END IF;
            RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
            UPDATE groups SET c_val = c_val - 1
                    WHERE id = OLD.group_id;
            RETURN NEW;
        END IF;
    END;
$unique_test$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER group_c_val_updater
BEFORE INSERT OR UPDATE OR DELETE ON students
FOR EACH ROW EXECUTE FUNCTION group_c_val();

---TEST---
INSERT INTO groups(id, group_name, c_val) VALUES (1, '043501', 0);
INSERT INTO groups(id, group_name, c_val) VALUES (2, '043502', 0);
INSERT INTO groups(id, group_name, c_val) VALUES (3, '043503', 0);

INSERT INTO students(student_name, group_id) VALUES ('1', 1);
INSERT INTO students(student_name, group_id) VALUES ('2', 1);
INSERT INTO students(student_name, group_id) VALUES ('3', 2);
INSERT INTO students(student_name, group_id) VALUES ('4', 2);
INSERT INTO students(student_name, group_id) VALUES ('4', 3);
INSERT INTO students(student_name, group_id) VALUES ('5', 3);
INSERT INTO students(student_name, group_id) VALUES ('6', 1);