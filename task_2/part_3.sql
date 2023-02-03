CREATE OR REPLACE FUNCTION cascade_delete()
RETURNS TRIGGER AS $cascade_delete$
    BEGIN
        DELETE FROM students WHERE group_id = OLD.id;
        RETURN OLD;
    END;
$cascade_delete$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER cascade_delete_table
BEFORE DELETE ON groups
FOR EACH ROW EXECUTE FUNCTION cascade_delete();

---TEST---
SELECT * FROM students;
DELETE FROM groups WHERE id = 2;
SELECT * FROM students;