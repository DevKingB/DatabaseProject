-- Active: 1713146534487@@127.0.0.1@3306@gradebook
DROP PROCEDURE IF EXISTS GetStudentScoresInCourse;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetStudentScoresInCourse`(IN courseNumber VARCHAR(255))
BEGIN
    DECLARE courseId INT;
    -- Attempt to get the course_id first
    SELECT course_id INTO courseId FROM courses WHERE course_number = courseNumber LIMIT 1;
    -- Check if the course was found
    IF courseId IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Course not found.';
    ELSE
        -- Check for students enrolled in the course
        IF (SELECT COUNT(DISTINCT student_id) FROM enrollment WHERE course_id = courseId) = 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No students enrolled in this course.';
        ELSE
            -- Check for assignments associated with the course
            IF (SELECT COUNT(DISTINCT assignment_id) FROM assignment WHERE course_id = courseId) = 0 THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No assignments found for this course.';
            ELSE
                -- Get the student names and their scores on each assignment
                SELECT
                    students.first_name,
                    students.last_name,
                    assignment.assignment_name,
                    studentsAssignments.points_earned -- Keep NULL to represent ungraded assignments
                FROM
                    students
                JOIN
                    enrollment ON students.student_id = enrollment.student_id
                JOIN
                    courses ON enrollment.course_id = courses.course_id
                LEFT JOIN
                    studentsAssignments ON students.student_id = studentsAssignments.student_id
                LEFT JOIN 
                    assignment ON studentsAssignments.assignment_id = assignment.assignment_id
                    AND assignment.course_id = courses.course_id
                WHERE
                    courses.course_number = courseNumber
                ORDER BY
                    students.last_name, students.first_name, assignment.assignment_name;
            END IF;
        END IF;
    END IF;
END