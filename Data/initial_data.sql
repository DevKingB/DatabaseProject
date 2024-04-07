-- Start transaction
START TRANSACTION;

-- Inserting data into departments
-- This statement is inserting department names into the 'departments' table.
INSERT INTO departments (`department_name`) 
VALUES ('Engineering'), ('Information Technology'), ('Mathematics'), ('Computer Science'), ('Physics'), ('Chemistry');

-- Inserting data into courses
-- This statement is inserting course details into the 'courses' table.
-- The JOIN operation is used to combine rows from two or more tables, based on a related column between them.
-- Here, it's used to get the department_id from the 'departments' table where the department_name matches.
INSERT INTO courses (`course_number`, `course_name`, `department_id`, `semester_offered`, `year_offered`, `student_capacity`) 
SELECT course_number, course_name, department_id, semester_offered, year_offered, student_capacity
FROM (
    SELECT 'CS100' as course_number, 'Introduction to Computer Science' as course_name, 'Computer Science' as department_name, 'Fall' as semester_offered, 2024 as year_offered, 30 as student_capacity
    UNION ALL
    SELECT 'MATH101', 'Calculus I', 'Mathematics', 'Summer', 2024, 30
    UNION ALL
    SELECT 'PHYS101', 'Physics I', 'Physics', 'Summer', 2024, 30
    UNION ALL
    SELECT 'CHEM101', 'Chemistry I', 'Chemistry', 'Fall', 2024, 30
    UNION ALL
    SELECT 'ENG201', 'Thermodynamics', 'Engineering', 'Spring', 2024, 30
    UNION ALL
    SELECT 'ENG301', 'Fluid Mechanics', 'Engineering', 'Fall', 2024, 25
    UNION ALL
    SELECT 'IT101', 'Fundamentals of Information Technology', 'Information Technology', 'Summer', 2024, 40
    UNION ALL
    SELECT 'IT201', 'Database Systems', 'Information Technology', 'Spring', 2024, 35
    UNION ALL
    SELECT 'IT301', 'Computer Networks', 'Information Technology', 'Fall', 2024, 30
) AS tmp
JOIN departments ON departments.department_name = tmp.department_name;

-- Inserting data into grading_criteria
-- This statement is inserting grading criteria names into the 'grading_criteria' table.
INSERT INTO grading_criteria(`criteria_name`) 
VALUES ('Participation'), ('Homework'), ('Exams'), ('Project'), ('Quizzes');

-- Inserting data into course_grading_policy
-- This statement is inserting course grading policy details into the 'course_grading_policy' table.
-- The JOIN operation is used to combine rows from two or more tables, based on a related column between them.
-- Here, it's used to get the course_id from the 'courses' table where the course_number matches and the criteria_id from the 'grading_criteria' table where the criteria_name matches.
INSERT INTO course_grading_policy(`course_id`, `criteria_id`, `weight`) 
SELECT course_id, criteria_id, weight
FROM (
    SELECT 'CS100' as course_number, 'Participation' as criteria_name, 10 as weight
    UNION ALL
    SELECT 'CS100', 'Homework', 25
    UNION ALL
    SELECT 'CS100', 'Project', 30
    UNION ALL
    SELECT 'CS100', 'Exams', 35
) AS tmp
JOIN courses ON courses.course_number = tmp.course_number
JOIN grading_criteria ON grading_criteria.criteria_name = tmp.criteria_name;

-- Inserting data into students
-- This statement is inserting student details into the 'students' table.
INSERT INTO students (`first_name`, `last_name`, `email`) 
VALUES ('John', 'Doe', 'john.doe@example.com'), ('Jane', 'Smith', 'jane.smith@example.com'), ('Emily', 'Jones', 'emily.jones@example.com'), ('Michael', 'Brown', 'michael.brown@example.com'), ('Jessica', 'Davis', 'jessica.davis@example.com');

-- Inserting data into assignment
-- This statement is inserting assignment details into the 'assignment' table.
-- The JOIN operation is used to combine rows from two or more tables, based on a related column between them.
-- Here, it's used to get the course_id from the 'courses' table where the course_number matches and the criteria_id from the 'grading_criteria' table where the criteria_name matches.
INSERT INTO `assignment` (`course_id`, `criteria_id`, `assignment_name`, `total_points`) 
SELECT course_id, criteria_id, assignment_name, total_points
FROM (
    SELECT 'ENG201' as course_number, 'Homework' as criteria_name, 'Thermodynamic Basics HW1' as assignment_name, 10 as total_points
    UNION ALL
    SELECT 'ENG201', 'Quizzes', 'Bridge Design Quiz', 30
    UNION ALL
    SELECT 'CS100', 'Exams', 'Midterm Exam', 75
    UNION ALL
    SELECT 'IT201', 'Homework', 'Database System HW1', 100
    UNION ALL
    SELECT 'IT301', 'Project', 'Network Traceroute Project', 100
) AS tmp
JOIN courses ON courses.course_number = tmp.course_number
JOIN grading_criteria ON grading_criteria.criteria_name = tmp.criteria_name;

-- Inserting data into studentsAssignments
-- This statement is inserting student assignment details into the 'studentsAssignments' table.
-- The JOIN operation is used to combine rows from two or more tables, based on a related column between them.
-- Here, it's used to get the assignment_id from the 'assignment' table where the assignment_name matches and the student_id from the 'students' table where the email matches.
INSERT INTO `studentsAssignments` (`assignment_id`, `student_id`, `points_earned`, `comments`) 
SELECT assignment_id, student_id, points_earned, comments
FROM (
    SELECT 'Thermodynamic Basics HW1' as assignment_name, 'john.doe@example.com' as email, 9 as points_earned, 'Good work' as comments
    UNION ALL
    SELECT 'Bridge Design Quiz', 'jane.smith@example.com', 25, 'Excellent'
    UNION ALL
    SELECT 'Midterm Exam', 'emily.jones@example.com', 55, 'Needs improvement'
    UNION ALL
    SELECT 'Database System HW1', 'michael.brown@example.com', 92, 'Well done'
    UNION ALL
    SELECT 'Network Traceroute Project', 'jessica.davis@example.com', 88, 'Good job'
) AS tmp
JOIN assignment ON assignment.assignment_name = tmp.assignment_name
JOIN students ON students.email = tmp.email;

-- Inserting data into enrollment
-- This statement is inserting student enrollment details into the 'enrollment' table.
-- The JOIN operation is used to combine rows from two or more tables, based on a related column between them.
-- Here, it's used to get the student_id from the 'students' table where the email matches and the course_id from the 'courses' table where the course_name matches.
INSERT INTO `enrollment` (`student_id`, `course_id`, `semester`, `year`) 
SELECT student_id, course_id, semester, year
FROM (
    SELECT 'john.doe@example.com' as email, 'Thermodynamics' as course_name, 'Fall' as semester, 2022 as year
    UNION ALL
    SELECT 'jane.smith@example.com', 'Structural Engineering', 'Spring', 2023
    UNION ALL
    SELECT 'emily.jones@example.com', 'Database Systems', 'Summer', 2022
    UNION ALL
    SELECT 'michael.brown@example.com', 'Network Engineering', 'Fall', 2023
    UNION ALL
    SELECT 'jessica.davis@example.com', 'Software Engineering', 'Spring', 2022
) AS tmp
JOIN students ON students.email = tmp.email
JOIN courses ON courses.course_name = tmp.course_name;

-- Rollback transaction
-- This statement is used to rollback the transaction, undoing all the changes made in the transaction.
ROLLBACK;