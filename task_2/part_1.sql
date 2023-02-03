CREATE TABLE groups (
    id              int,
    group_name      varchar(32),
    c_val           int
);

CREATE TABLE students (
    id              int,
    student_name    varchar(32),
    group_id        int
);