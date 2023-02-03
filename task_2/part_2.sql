---------Unique STUDENTS ID trigger---------

CREATE OR REPLACE FUNCTION unique_id_students()
RETURNS TRIGGER AS $unique_test$
DECLARE students_id CURSOR FOR SELECT id FROM students;
    BEGIN
        FOR insert_student_id in students_id loop
            IF (insert_student_id.id = NEW.id) THEN
                RAISE 'Duplicate student ID: %', insert_student_id USING ERRCODE = 'unique_violation';
            END IF;
        END loop;
        RETURN NEW;
    END
$unique_test$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER student_unique_id_checker
BEFORE INSERT ON students
FOR EACH ROW EXECUTE FUNCTION unique_id_students();

---------Unique GROUPS ID trigger---------

CREATE OR REPLACE FUNCTION unique_id_groups()
RETURNS TRIGGER AS $unique_test$
DECLARE groups_id CURSOR FOR SELECT id FROM groups;
    BEGIN
        FOR insert_group_id in groups_id loop
            IF (insert_group_id.id = NEW.id) THEN
                RAISE 'Duplicate group ID: %', insert_group_id USING ERRCODE = 'unique_violation';
            END IF;
        END loop;
        RETURN NEW;
    END
$unique_test$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER group_unique_id_checker
BEFORE INSERT ON groups
FOR EACH ROW EXECUTE FUNCTION unique_id_groups();

---------STUDENTS AutoIncrement---------

CREATE OR REPLACE FUNCTION students_autoincrement()
RETURNS TRIGGER AS $autoincrement_test$
DECLARE max_id INT := 0;
    BEGIN
        SELECT max(id) INTO max_id FROM students;
        IF (max_id IS NULL) THEN
            max_id := 0;
        END IF;
        NEW.id := max_id + 1;
        RETURN NEW;
    END;
$autoincrement_test$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER students_autoincrement_checker
BEFORE INSERT OR UPDATE ON students
FOR EACH ROW EXECUTE FUNCTION students_autoincrement();

---------GROUPS AutoIncrement---------

CREATE OR REPLACE FUNCTION groups_autoincrement()
RETURNS TRIGGER AS $autoincrement_test$
DECLARE max_id INT := 0;
    BEGIN
        SELECT max(id) INTO max_id FROM groups;
        IF (max_id IS NULL) THEN
            max_id := 0;
        END IF;
        NEW.id := max_id + 1;
        RETURN NEW;
    END;
$autoincrement_test$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER groups_autoincrement_checker
BEFORE INSERT OR UPDATE ON groups
FOR EACH ROW EXECUTE FUNCTION groups_autoincrement();

---------Unique test GROUP.NAME---------

CREATE OR REPLACE FUNCTION unique_group_name()
RETURNS TRIGGER AS $unique_name_test$
DECLARE unique_group_name CURSOR FOR SELECT group_name FROM groups;
    BEGIN
        FOR unique_name in unique_group_name loop
            IF (unique_name.group_name = NEW.group_name) THEN
                RAISE 'Duplicate group name: %', unique_name USING ERRCODE = 'unique_violation';
            END IF;
        END LOOP;
        RETURN NEW;
    END;
$unique_name_test$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER groups_name_unique_checker
BEFORE INSERT ON groups
FOR EACH ROW EXECUTE FUNCTION unique_group_name();

---------TEST FUNCTIONS ---------

---Students unique id---
INSERT INTO students(id, student_name, group_id) VALUES (1, 'Kate', 2);
INSERT INTO students(id, student_name, group_id) VALUES (1, 'Liza', 3);

---Groups unique id---
INSERT INTO groups(id, group_name, c_val) VALUES (1, 'math', 22);
INSERT INTO groups(id, group_name, c_val) VALUES (1, 'russ', 30);

---Students autoincrement---
INSERT INTO students(student_name, group_id) VALUES ('Kate', 2);
INSERT INTO students(student_name, group_id) VALUES ('Liza', 3);

---Groups autoincrement---
INSERT INTO groups(group_name, c_val) VALUES ('math', 22);
INSERT INTO groups(group_name, c_val) VALUES ('russ', 30);

---Unique group name---
INSERT INTO groups(group_name, c_val) VALUES ('math', 22);