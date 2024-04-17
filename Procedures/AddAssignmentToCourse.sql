-- Active: 1713288377970@@127.0.0.1@3306@gradebook
DROP PROCEDURE IF EXISTS AddAssignmentToCourse;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddAssignmentToCourse`(
    IN _course_id INT,
    IN _criteria_id INT,
    IN _assignment_name VARCHAR(255),
    IN _total_points DECIMAL(5,2)
)
BEGIN
    -- Validate inputs
    IF _assignment_name IS NULL OR TRIM(_assignment_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Assignment name cannot be null or empty.';
    ELSEIF NOT EXISTS (SELECT 1 FROM courses WHERE course_id = _course_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: The specified course does not exist.';
    ELSEIF NOT EXISTS (SELECT 1 FROM grading_criteria WHERE criteria_id = _criteria_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: The specified grading criteria does not exist.';
    ELSEIF _total_points < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Total points cannot be negative.';
    ELSE
        -- Check for duplicate assignment name within the same course and criteria
        IF EXISTS (SELECT 1 FROM assignment 
                   WHERE course_id = _course_id AND 
                         criteria_id = _criteria_id AND 
                         assignment_name = _assignment_name) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: An assignment with the specified name already exists for this course and criteria.';
        ELSE
            -- Proceed with adding the assignment if all checks pass
            INSERT INTO assignment(course_id, criteria_id, assignment_name, total_points)
            VALUES (_course_id, _criteria_id, _assignment_name, _total_points);
            -- Check if the insert was successful
            IF ROW_COUNT() = 0 THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Failed to add the assignment.';
            ELSE
                SELECT 'Assignment added successfully.' AS Message;
            END IF;
        END IF;
    END IF;
END