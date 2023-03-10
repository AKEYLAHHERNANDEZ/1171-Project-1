
--PROJECT 1 PHASE 1 

DROP TABLE IF EXISTS faculties CASCADE;
DROP TABLE IF EXISTS programs CASCADE;
DROP TABLE IF EXISTS instructors CASCADE;
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS pre_requisites CASCADE;
DROP TABLE IF EXISTS course_programs CASCADE;


--Faculties Table

CREATE TABLE faculties
(
faculty_id VARCHAR(4) PRIMARY KEY,
faculty_name VARCHAR(100) NOT NULL,
faculty_description TEXT NOT NULL
);

-- Programs Table

CREATE TABLE programs 
(
program_id CHAR(4) PRIMARY KEY,
faculty_id VARCHAR(4),
program_name VARCHAR(50) NOT NULL,
program_location VARCHAR(50),
program_description TEXT NOT NULL,
FOREIGN KEY (faculty_id)
REFERENCES faculties(faculty_id)
);

--instructors Table

CREATE TABLE instructors 
(
instructor_id INT PRIMARY KEY,
email VARCHAR (50),
instructor_name VARCHAR (50),
office_location VARCHAR (50),
telephone CHAR (20),
degree VARCHAR(5)
);

-- Courses Table

CREATE TABLE courses 
(
course_id INT PRIMARY KEY,
code CHAR ( 8 ) NOT NULL,
year INT NOT NULL,
semester INT NOT NULL,
section VARCHAR (10) NOT NULL,
title VARCHAR ( 100 ) NOT NULL,
credits INT NOT NULL,
modality VARCHAR ( 50 ) NOT NULL,
modality_type VARCHAR(20) NOT NULL,
instructor_id INT NOT NULL,
class_venue	VARCHAR(100),
communicatioin_tool	VARCHAR(25),                  
course_platform	VARCHAR(25),
field_trips	VARCHAR(3) check(field_trips in ('Yes','No')),
resources_required TEXT NOT NULL,
resources_recommended TEXT NOT NULL,
resources_other TEXT NOT NULL,
description TEXT NOT NULL,
outline_url TEXT NOT NULL,
UNIQUE (code, year, semester, section),
FOREIGN KEY (instructor_id)
REFERENCES instructors (instructor_id)
);
  
--Pre_Requisites

CREATE TABLE pre_requisites
(
course_id INT NOT NULL,
prereq_id VARCHAR(8) NOT NULL,
PRIMARY KEY (prereq_id,course_id),
FOREIGN KEY (course_id)
REFERENCES courses (course_id)
);

--course_programs Table 

CREATE TABLE course_programs
(
course_id int NOT NULL,
program_id CHAR(4) NOT NULL,
FOREIGN KEY (program_id)
REFERENCES programs (program_id),
FOREIGN KEY (course_id)
REFERENCES courses (course_id)
);   





--Link data files 
--1.
\COPY faculties
FROM '/home/akeylah/Project1/faculties.csv'
DELIMITER ','
CSV HEADER;

--2.
\COPY programs
FROM '/home/akeylah/Project1/programs.csv'
DELIMITER ','
CSV HEADER;

--3.
\COPY instructors
FROM '/home/akeylah/Project1/instructors.csv'
DELIMITER ','
CSV HEADER;


--4.
\COPY courses
FROM '/home/akeylah/Project1/courses.csv'
DELIMITER ','
CSV HEADER;

--5.

\COPY pre_requisites
FROM '/home/akeylah/Project1/pre_reqs.csv'
DELIMITER ','
CSV HEADER;

--6.
\COPY course_programs
FROM '/home/akeylah/Project1/courses_programs.csv'
DELIMITER ','
CSV HEADER;




--Display tables
--1. 
SELECT*
FROM faculties;

--2. 
SELECT*
FROM programs;

--3. 
SELECT*
FROM instructors;

--4. 
SELECT*
FROM courses;

--5. 
SELECT*
FROM pre_requisites;

--6. 
SELECT*
FROM course_programs;





--All Queries 

--3.What faculties at UB end in S?
SELECT faculty_id, faculty_name
FROM faculties
WHERE faculty_id
LIKE '%S';

--4. What programs are offered in Belize City?
SELECT program_id, program_name ,program_location
FROM programs
WHERE program_location = 'Belize City';

--5. What courses does Mrs. Vernelle Sylvester teach?//check
SELECT C.course_id,C.code,C.year,C.section, C.title,I.instructor_id,I.instructor_name
FROM courses AS C
JOIN instructors AS I
ON C.instructor_id=I.instructor_id
WHERE I.instructor_name = 'Vernelle Sylvester'
GROUP BY C.course_id, I.instructor_id;

--6. Which instructors have a Masters Degree?
SELECT instructor_id, instructor_name, degree
FROM instructors
WHERE degree = 'M.Sc.';

--7. What are the prerequisites for Programming 2? //wrong 
SELECT c1.course_id,c1.code,c1.year,c1.section,pr.course_id,c1.title,pr.prereq_id
FROM courses c1
JOIN pre_requisites pr ON c1.course_id = pr.course_id
JOIN courses c2 ON pr.prereq_id = c2.code
WHERE c1.title = 'Priciples of Programming 2';

--8. List the program_name and code, year, semester section and title for all courses.
SELECT  c.code, c.year, c.semester, c.section, c.title
FROM courses c
JOIN course_programs cp ON c.course_id = cp.course_id
JOIN programs p ON cp.program_id = p.program_id;

--9. List the program_name and code, year, semester section 
--and title for all courses in the AINT Program.
SELECT C.code, C.year,C.semester, C.section, C.title, P.program_name
FROM programs AS P INNER JOIN course_programs AS CP 
ON P.program_id=CP.program_id INNER JOIN courses AS C ON C.course_id=CP.course_id 
WHERE P.program_id='AINT'; 

--10. List the faculty_name and code, year, semester
--section and title for all courses offered by FST.

SELECT C.code, C.year,C.semester,C.section,C.title,P.program_name,F.faculty_id
FROM faculties AS F  INNER JOIN programs AS P 
ON F.faculty_id=P.faculty_id INNER JOIN course_programs AS CP
ON P.program_id=CP.program_id INNER JOIN courses AS C 
ON CP.course_id=C.course_id 
WHERE F.faculty_id='FST';



