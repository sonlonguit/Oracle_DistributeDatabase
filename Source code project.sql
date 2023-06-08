DROP TABLE STUDENT_2;
CREATE TABLE STUDENT_2(
    student_id CHAR(8) PRIMARY KEY,
    student_name VARCHAR2(50),
    citizen_identity_number CHAR(10),
    dob DATE,
    gender CHAR(1),
    phone_number CHAR(10),
    email CHAR(50),
    department CHAR(7),
    class_name CHAR(15),
    current_year NUMBER,
    status CHAR(10),
    picture CHAR(255),
    nationality CHAR(25),
    address VARCHAR2(255),
    religion VARCHAR2(25),
    parent_name VARCHAR2(50),
    parent_phone_number CHAR(10)
);

DROP TABLE TEACHER_2;
CREATE TABLE TEACHER_2(
    teacher_id CHAR(8) PRIMARY KEY,
    citizen_identity_number VARCHAR(10),
    teacher_name VARCHAR2(50),
    gender CHAR(1),
    dob DATE,
    phone_number CHAR(10),
    email CHAR(50),
    department CHAR(7),
    nationality CHAR(25),
    address VARCHAR2(255),
    picture CHAR(255),
    religion VARCHAR2(25)
);

DROP TABLE SUBJECT_2;
CREATE TABLE SUBJECT_2(
    subject_id CHAR(10) PRIMARY KEY,
    name_vi VARCHAR2(50),
    name_en CHAR(50),
    credit NUMBER,
    department CHAR(7),
    pre_subject CHAR(10)
);

DROP TABLE COURSE_2;
CREATE TABLE COURSE_2(
    course_id CHAR(25) PRIMARY KEY,
    teacher_id CHAR(8),
    subject_id CHAR(10),
    date_start DATE,
    date_end DATE,
    course_capacity NUMBER,
    slot_counter NUMBER,
    lesson CHAR(5),
    course_time CHAR(3),
    course_language CHAR(25),
    room CHAR(10),
    semester CHAR(1),
    course_year NUMBER,
    is_open CHAR(1)
);

DROP TABLE REGISTRATION_2;
CREATE TABLE REGISTRATION_2(
    course_id CHAR(25),
    student_id CHAR(8),
    status CHAR(15),
    date_created DATE,
    date_edited DATE
);

-- ----------------- --
-- CREATE CONSTRAINT --
-- ----------------- --
ALTER TABLE SUBJECT_2 DROP CONSTRAINT FK_SUBJECT_PRE;
ALTER TABLE SUBJECT_2 ADD CONSTRAINT FK_SUBJECT_PRE FOREIGN KEY (pre_subject) REFERENCES SUBJECT_2(subject_id);

ALTER TABLE COURSE_2 DROP CONSTRAINT FK_COURSE_TEACHER;
ALTER TABLE COURSE_2 DROP CONSTRAINT FK_COURSE_SUBJECT;
ALTER TABLE COURSE_2 ADD CONSTRAINT FK_COURSE_TEACHER FOREIGN KEY (teacher_id) REFERENCES TEACHER_2(teacher_id);
ALTER TABLE COURSE_2 ADD CONSTRAINT FK_COURSE_SUBJECT FOREIGN KEY (subject_id) REFERENCES SUBJECT_2(subject_id);

ALTER TABLE REGISTRATION_2 DROP CONSTRAINT FK_REGISTRATION_STUDENT;
ALTER TABLE REGISTRATION_2 DROP CONSTRAINT FK_REGISTRATION_COURSE;
ALTER TABLE REGISTRATION_2 ADD CONSTRAINT FK_REGISTRATION_STUDENT FOREIGN KEY (student_id) REFERENCES STUDENT_2(student_id);
ALTER TABLE REGISTRATION_2 ADD CONSTRAINT FK_REGISTRATION_COURSE FOREIGN KEY (course_id) REFERENCES COURSE_2(course_id);



-----------------------------------------------------------------
----------------------INSERT-------------------------------------



select * from STUDENT_2;
delete from student_2;
insert into STUDENT_2 values('STU_5000', 'Nguyen Huu Bang','197005001', '' , 'M', '0912335639','stu0501@gm.uit.edu.vn', 'KTMT', 'KTMT2021', 1, 'Studying', '', '', '', '', '', '');
insert into STUDENT_2 values('STU_5001', 'Phan Thi Anh','197005002', '', 'F', '0912335452', 'stu00502@gm.uit.edu.vn', 'KH-KTTT', 'KTTT2019', 3, 'Studying', '', '', '', '', '', '');
insert into STUDENT_2 values('STU_5002', 'Cao Duy Linh','197005003', '', 'M', '0912335124', 'stu0503@gm.uit.edu.vn', 'MMT-TT', 'MMT-TT2018', 4, 'Studying', '', '', '', '', '', '');
insert into STUDENT_2 values('STU_5003', 'Pham Van Thang','197005004', '', 'M', '0912335112', 'stu0504@gm.uit.edu.vn', 'MMT-TT', 'MMT-TT2019', 3, 'Studying', '', '', '', '', '', '');



select * from TEACHER_2;
delete from teacher_2;
insert into TEACHER_2 values('TCH_0501', '298735414', 'Dinh Le Nhiet Ba', 'F', '', '', 'tch0501@gm.uit.edu.vn', 'KTMT', ' ', ' ', '', '');
insert into TEACHER_2 values('TCH_0502', '298712454', 'Tu Phuong Nien', 'M', '', '', 'tch0502@gm.uit.edu.vn', 'KH-KTTT', ' ', ' ', '', '');
insert into TEACHER_2 values('TCH_0503', '298719100', 'Tran Bao Chi', 'M', '', '', 'tch0503@gm.uit.edu.vn', 'MMT-TT ', ' ', ' ', '', '');



select * from SUBJECT_2;
insert into SUBJECT_2 values('NT101', 'An toan mang may tinh', 'Network security ', 4, 'MMT-TT', '');
insert into SUBJECT_2 values('CE115', 'Thiet ke mang', 'Network design', 3, 'KTMT', '');
insert into SUBJECT_2 values('IE103', 'Quan ly thong tin ', 'Information management ', 3, 'KH-KTTT', '');
insert into SUBJECT_2 values('NT334', 'Phuong phap chung ky thuat so', 'Digital forensics', 4, 'MMT-TT ', 'NT101');


-- ------- --
-- TRIGERS --
-- ------- --
-- Update course slot counter
CREATE OR REPLACE TRIGGER Update_Course_Counter
AFTER INSERT ON REGISTRATION_2
FOR EACH ROW
BEGIN
    update COURSE_2
    set COURSE_2.slot_counter = COURSE_2.slot_counter + 1
    where COURSE_2.course_id = :NEW.course_id;
END;

-- Update course status
CREATE OR REPLACE TRIGGER Update_Course_Status
BEFORE UPDATE ON COURSE_2
FOR EACH ROW
BEGIN
    if :NEW.slot_counter = :NEW.course_capacity then
        :NEW.is_open := 'F';
    end if;
END;


-- ---------- --
-- PROCEDURES --
-- ---------- --

-- Teacher create a course

create or replace procedure createCourse(v_course_id in char,v_teacher_id in char, v_subject_id in char, v_start in date, v_end in date, v_capacity in number, v_lesson in char, v_time in char, v_lang in char, v_room in char, v_semester in number, v_year in number)
As
    count_teacher int;
    count_subject int;
Begin
    select count(teacher_id) into count_teacher from TEACHER_2 where teacher_id = v_teacher_id;
    select count(subject_id) into count_subject from SUBJECT_2 where subject_id = v_subject_id;
    if count_teacher=1 and count_subject=1 then
        insert into COURSE_2 values(v_course_id,v_teacher_id,v_subject_id,v_start,v_end, v_capacity,0,v_lesson,v_time,v_lang,v_room,v_semester,v_year,'T');
    else
        dbms_output.put_line('Teacher or Subject was not found');
    end if;
    COMMIT;
End;



-- ---------- --
-- PROCEDURES --
-- ---------- --

-- Procedure create registration
create or replace procedure enrollCourse(v_course_id in char,v_student_id in char)
As
    count_student int;
    count_course int;
    course_current_slot int;
    course_capacity int;
    count_registration int;
    pre_subject_id char(10);
    is_course_open char(1) := 'T';
    temp int;
    check_pre_subject int;
Begin
    select count(student_id) into count_student from STUDENT_2 where student_id = v_student_id;
    select count(course_id) into count_course from COURSE_2 where course_id = v_course_id;
    if count_student > 0 and count_course > 0 then
        select slot_counter into course_current_slot from COURSE_2 where course_id = v_course_id;
        select course_capacity into course_capacity from COURSE_2 where course_id = v_course_id;
        if (course_capacity - course_current_slot) > 0 then
                -- Course available
            select count(*) into count_registration from REGISTRATION_2 where course_id = v_course_id and student_id = v_student_id and status = 'Processing';
            if count_registration=0 then
                -- Haven't registered yet
                select pre_subject into pre_subject_id from SUBJECT_2 where (select subject_id from COURSE_2 where course_id = v_course_id) = subject_id;
                if pre_subject_id is null then
                    insert into REGISTRATION_2 values(v_course_id,v_student_id,'Processing',to_date(sysdate,'yyyy-mm-dd hh24:mi:ss'),null);
                    dbms_output.put_line('Enroll success');
                else
                    for course_item in (select * from course_2 where subject_id = pre_subject_id)
                    loop
                        select count(*) into temp from registration_2 where course_item.course_id = course_id and student_id = v_student_id and (status = 'Complete' or status = 'Processing');
                        if temp > 0 then
                            check_pre_subject := check_pre_subject + 1;
                        end if;
                    end loop;
                    if check_pre_subject > 0 then
                        insert into REGISTRATION_2 values(v_course_id,v_student_id,'Processing',to_date(sysdate,'yyyy-mm-dd hh24:mi:ss'),null);
                        dbms_output.put_line('Enroll success');
                    else
                        dbms_output.put_line('Must pass pre subject');
                    end if;
                end if;
            else
                dbms_output.put_line('Already registered');
            end if;
        else
            dbms_output.put_line('Full slot');
        end if;
    elsif count_student > 0 and count_course = 0 then
        select count(*) into count_course from C##DUC.COURSE_1@DUC_DBL where course_id = v_course_id; 
        if count_course > 0 then
            select slot_counter into course_current_slot from C##DUC.COURSE_1@DUC_DBL where course_id = v_course_id;
            select course_capacity into course_capacity from C##DUC.COURSE_1@DUC_DBL where course_id = v_course_id;
            if (course_capacity - course_current_slot) > 0 then
                    -- Course available
                select count(*) into count_registration from C##DUC.REGISTRATION_1@DUC_DBL where course_id = v_course_id and student_id = v_student_id and status = 'Processing';
                if count_registration=0 then
                    -- Haven't registered yet
                    select pre_subject into pre_subject_id from C##DUC.SUBJECT_1@DUC_DBL where (select subject_id from C##DUC.COURSE_1@DUC_DBL where course_id = v_course_id) = subject_id;
                    if pre_subject_id is null then
                        insert into C##DUC.REGISTRATION_1@DUC_DBL values(v_course_id,v_student_id,'Processing',to_date(sysdate,'yyyy-mm-dd hh24:mi:ss'),null);
                        dbms_output.put_line('Enroll success');
                    else
                        for course_item in (select * from C##DUC.COURSE_1@DUC_DBL where subject_id = pre_subject_id)
                        loop
                            select count(*) into temp from C##DUC.REGISTRATION_1@DUC_DBL where course_item.course_id = course_id and student_id = v_student_id and (status = 'Complete' or status = 'Processing');
                            if temp > 0 then
                                check_pre_subject := check_pre_subject + 1;
                            end if;
                        end loop;
                        if check_pre_subject > 0 then
                            insert into C##DUC.REGISTRATION_1@DUC_DBL values(v_course_id,v_student_id,'Processing',to_date(sysdate,'yyyy-mm-dd hh24:mi:ss'),null);
                            dbms_output.put_line('Enroll success');
                        else
                            dbms_output.put_line('Must pass pre subject');
                        end if;
                    end if;
                else
                    dbms_output.put_line('Already registered');
                end if;
            else
                dbms_output.put_line('Full slot');
            end if;
        else
            dbms_output.put_line('Student or Course was not found');
        end if;
    else
        dbms_output.put_line('Student or Course was not found');
    end if;
    COMMIT;
End;









-- -------------------DEMO PROJECT -----------------
SET SERVEROUTPUT ON;
-- Step 1: Show data
select * from subject_2;
select * from course_2;
select * from registration_2;
select * from student_2;
select * from teacher_2;

select * from C##DUC.subject_1@DUC_DBL;
select * from C##DUC.course_1@DUC_DBL;
select * from C##DUC.registration_1@DUC_DBL;
select * from C##DUC.student_1@DUC_DBL;
select * from C##DUC.teacher_1@DUC_DBL;


-- Step 2: T?o course
select * from course_2;
select * from C##DUC.COURSE_1@DUC_DBL;

Begin
createCourse('CE115.M11','TCH_0100','CE115',TO_DATE('September 06, 2021', 'MONTH DD, YYYY'),TO_DATE('December 26, 2021', 'MONTH DD, YYYY'),2,'678','Thu','English','E4.3','2',2021);
End;

select * from course_2 UNION select * from C##DUC.COURSE_1@DUC_DBL;

-- Step 3: Registration course
-- Registration 1 student
Begin
enrollCourse('CE115.M11','STU_0103');
End;

-- Registration course site khác
Begin
enrollCourse('IT001.M11','STU_0100');
End;
-- Full slot
Begin
enrollCourse('SE402.M12','STU_0100');
End;
-- course not found
Begin
enrollCourse('CE115.M13','STU_0101');
End;

-- Step 4: Show data Registration 2 site
insert into registration_1@DUC_DBL(course_id, student_id, status, date_created, date_edited) values('CS4343.M11','STU_0002', 'Processing',TO_DATE('December 26, 2021', 'MONTH DD, YYYY'),'');
-- Show courses
select * from registration;
select * from C##DUC.REGISTRATION_1@DUC_DBL;

-- Show chung
select * from registration_2 UNION select * from C##DUC.registration_1@DUC_DBL where course_id = 'IT001.M11';




