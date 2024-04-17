-- Active: 1713288377970@@127.0.0.1@3306@gradebook
DROP PROCEDURE IF EXISTS UpdateStudentScore;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateStudentScore`(
    IN p_assignmentName VARCHAR(255), 
    IN p_pointsAdjustments INT
)
BEGIN
    DECLARE v_assignmentId INT;
    -- Get the assignment ID
    SELECT assignment_id INTO v_assignmentId FROM assignment WHERE assignment_name = p_assignmentName;
    -- Check if the assignment exists
    IF v_assignmentId IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Assignment not found.';
    ELSE
        -- Update scores only for students whose last name contains a 'Q'
        UPDATE studentsAssignments 
        JOIN students ON studentsAssignments.student_id = students.student_id
        SET points_earned = points_earned + p_pointsAdjustments
        WHERE students.last_name LIKE '%Q%' 
          AND studentsAssignments.assignment_id = v_assignmentId;
        -- Check how many rows were affected
        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No eligible students found or points already updated.';
        ELSE
            SELECT CONCAT(ROW_COUNT(), ' students updated successfully.') AS Message;
        END IF;
    END IF;
END