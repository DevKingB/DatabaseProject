-- Active: 1713146534487@@127.0.0.1@3306@gradebook
DROP PROCEDURE IF EXISTS UpdateStudentScore;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateStudentScore`(IN studentId INT, IN assignmentName VARCHAR(255), IN pointsAdjustments INT)
BEGIN
    DECLARE assignmentId INT;
    -- Get the assignment ID
    SELECT assignment_id INTO assignmentId FROM assignment WHERE assignment_name = assignmentName;
    -- Check if the assignment exists
    IF assignmentId IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Assignment not found.';
    ELSE
        -- Check if the student has a record for this assignment
        IF EXISTS(SELECT 1 FROM studentsAssignments WHERE student_id = studentId AND assignment_id = assignmentId) THEN
            -- Update the student's score
            UPDATE studentsAssignments
            SET points_earned = points_earned + pointsAdjustments
            WHERE student_id = studentId AND assignment_id = assignmentId;
        ELSE
            -- The student does not have a record for this assignment, so create one
            INSERT INTO studentsAssignments(student_id, assignment_id, points_earned)
            VALUES(studentId, assignmentId, pointsAdjustments);
        END IF;
    END IF;
END