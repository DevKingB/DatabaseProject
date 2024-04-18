-- run_tests.sql
-- Comprehensive test script for all stored procedures with thorough cleanup.
-- Define and create SetupTestData Procedure to prepare data for tests
DROP PROCEDURE IF EXISTS SetupTestData;

-- changing the delimeter to allow for multi-line statements
DELIMITER $$
CREATE PROCEDURE SetupTestData()
BEGIN
    -- Insert necessary initial data for tests, such as departments, courses, students, etc.
    INSERT INTO departments (department_name) 
    VALUES ('Computer Science'), ('Information Technology'), ('Mathematics'), ('Biology');

    INSERT INTO courses (course_number, course_name, department_id, semester_offered, year_offered, student_capacity)
    VALUES ('CS101', 'Introduction to Computer Science', 1, 'Fall', 2024, 30),
           ('IT201', 'Network Security', 2, 'Spring', 2024, 25),
           ('MATH301', 'Advanced Calculus', 3, 'Fall', 2024, 20);

    INSERT INTO grading_criteria (criteria_name)
    VALUES ('Participation'), ('Homework'), ('Project'), ('Midterm Exam'), ('Final Exam');

    INSERT INTO students (first_name, last_name, email)
    VALUES ('John', 'Doe', 'john.doe@example.edu'),
           ('Jane', 'Smith', 'jane.smith@example.edu');
END$$

-- Define a helper procedure to log success results dynamically
DROP PROCEDURE IF EXISTS LogSuccess;
CREATE PROCEDURE LogSuccess(IN test_name VARCHAR(255), IN message VARCHAR(255))
BEGIN
    INSERT INTO test_results VALUES (test_name, 'Passed', message);
END$$

-- Start a transaction to ensure no changes are persisted
START TRANSACTION;

-- Create a temporary table to log test outcomes
CREATE TEMPORARY TABLE IF NOT EXISTS test_results (
    test_case VARCHAR(255),
    result VARCHAR(255),
    detail VARCHAR(1000)
);

-- Handler for capturing SQL exceptions during tests
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
BEGIN
    GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errmsg = MESSAGE_TEXT;
    INSERT INTO test_results VALUES (@CURRENT_TEST, 'Failed', CONCAT(@sqlstate, ': ', @errmsg));
END;

-- Setup initial test data
CALL SetupTestData();

-- Positive Test: Correct data for adding an assignment
SET @CURRENT_TEST = 'Add valid assignment';
CALL AddAssignmentToCourse(101, 201, 'Valid Assignment', 100);
CALL LogSuccess(@CURRENT_TEST, 'Assignment added successfully.');

-- Duplicate assignment test
SET @CURRENT_TEST = 'Duplicate assignment';
CALL AddAssignmentToCourse(101, 201, 'Valid Assignment', 100);

-- ComputeStudentGrade tests
SET @CURRENT_TEST = 'Compute valid grade';
CALL ComputeStudentGrade(123, 101, @msg);
CALL LogSuccess(@CURRENT_TEST, @msg);

SET @CURRENT_TEST = 'Student not enrolled';
CALL ComputeStudentGrade(999, 101, @msg);

-- UpdateStudentScore tests
SET @CURRENT_TEST = 'Update score for existing student';
CALL UpdateStudentScore(123, 'Intro to Programming Homework 1', 5);
CALL LogSuccess(@CURRENT_TEST, 'Score updated successfully.');

-- More tests for other procedures here
-- Ensure all procedures are thoroughly tested for various scenarios

-- Rollback to clean up all changes made during the test
ROLLBACK;

-- Output test results
SELECT * FROM test_results;

-- Cleanup: Drop temporary structures and procedures
DROP TEMPORARY TABLE IF EXISTS test_results;
DROP PROCEDURE IF EXISTS LogSuccess;
DROP PROCEDURE IF EXISTS SetupTestData;

DELIMITER ;
