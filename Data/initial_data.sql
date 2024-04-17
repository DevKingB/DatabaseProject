-- Active: 1713288377970@@127.0.0.1@3306@gradebook
DROP PROCEDURE GetAssignmentStats;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAssignmentStats`(
    IN assignmentName VARCHAR(255))
BEGIN
    DECLARE assignmentExists BOOL DEFAULT FALSE;
    DECLARE submissionCount INT;
    -- Input validation for null or empty assignment name
    IF assignmentName IS NULL OR assignmentName = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Assignment name cannot be null or empty.';
    ELSE
        -- Check if the assignment exists
        SELECT EXISTS(
            SELECT 1 
            FROM `assignment` 
            WHERE assignment_name = assignmentName
        ) INTO assignmentExists;
        IF assignmentExists THEN
            -- Check if there are any submissions for the assignment
            SELECT EXISTS(
                SELECT 1 
                FROM `studentsAssignments` 
                JOIN `assignment` ON studentsAssignments.assignment_id = assignment.assignment_id
                WHERE assignment.assignment_name = assignmentName
            ) INTO submissionCount;
            IF submissionCount THEN
                -- Calculate the statistics for the assignment         
                SELECT 
                    assignment.assignment_name AS 'Assignment Name',
                    COUNT(studentsAssignments.student_assignment_id) AS 'Total Submissions',
                    AVG(IFNULL(studentsAssignments.points_earned, 0)) AS 'Average Score',
                    MAX(studentsAssignments.points_earned) AS 'Highest Score',
                    MIN(studentsAssignments.points_earned) AS 'Lowest Score'
                FROM 
                    studentsAssignments
                    JOIN assignment ON studentsAssignments.assignment_id = assignment.assignment_id
                WHERE 
                    assignment.assignment_name = assignmentName 
                    AND studentsAssignments.points_earned IS NOT NULL
                GROUP BY 
                    assignment.assignment_name;
            ELSE
                -- No submission, return a message indicating no scores are available for the assignment
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No submissions for this assignment.';
            END IF;
        ELSE
            -- Assignment does not exist, return a message indicating the assignment was not found
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Assignment not found.';
        END IF;
    END IF;
END