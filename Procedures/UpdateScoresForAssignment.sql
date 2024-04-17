-- Active: 1713288377970@@127.0.0.1@3306@gradebook
DROP PROCEDURE IF EXISTS UpdateScoresForAssignment;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateScoresForAssignment`(
    IN assignmentName VARCHAR(255), 
    IN pointsAdjustments INT
)
BEGIN
    DECLARE v_assignment_id INT;  -- Declaration moved to the top of the BEGIN block.

    IF assignmentName IS NULL OR assignmentName = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Assignment name cannot be null or empty.';
    ELSEIF pointsAdjustments IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Points adjustments cannot be null.';
    ELSE
        -- Check if the assignment exists and retrieve its ID
        SELECT assignment_id INTO v_assignment_id FROM assignment WHERE assignment_name = assignmentName;
        IF v_assignment_id IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Assignment not found.';
        ELSE
            -- Update the scores for all students on this assignment
            -- Ensuring that the final score does not go below zero
            UPDATE studentsAssignments
            SET points_earned = GREATEST(0, points_earned + pointsAdjustments)
            WHERE assignment_id = v_assignment_id;
        END IF;
    END IF;
END