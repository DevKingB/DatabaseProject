-- Active: 1713146534487@@127.0.0.1@3306@gradebook
DROP PROCEDURE IF EXISTS GetStudentsInCourse;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetStudentsInCourse`(
    IN courseNumber VARCHAR(255))
BEGIN
    DECLARE courseExists BOOLEAN;
    DECLARE studentsEnrolled BOOLEAN;
    -- Check if the course exists using EXISTS for efficient true/false return
    SELECT EXISTS(SELECT 1 FROM courses WHERE course_number = courseNumber) INTO courseExists;
    IF NOT courseExists THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Course does not exist.';
    END IF;
    -- Check if there are any students enrolled in the course using EXISTS
    SELECT EXISTS(
        SELECT 1
        FROM enrollment
        JOIN courses ON enrollment.course_id = courses.course_id
        WHERE courses.course_number = courseNumber
    ) INTO studentsEnrolled;
    -- Proceed with data retrieval only if students are enrolled
    IF studentsEnrolled THEN
        -- Retrieve the first and last names of all students enrolled in the course
        SELECT students.first_name, students.last_name
        FROM students
        JOIN enrollment ON students.student_id = enrollment.student_id
        JOIN courses ON enrollment.course_id = courses.course_id
        WHERE courses.course_number = courseNumber;
    ELSE
        -- Signal to the application that no students are enrolled in the course
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No students are enrolled in the course.';
    END IF;
END