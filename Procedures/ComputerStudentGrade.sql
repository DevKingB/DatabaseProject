-- Active: 1713288377970@@127.0.0.1@3306@gradebook
DROP PROCEDURE IF EXISTS ComputeStudentGrade;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ComputeStudentGrade`(
    IN p_student_id INT, 
    IN p_course_id INT, 
    OUT p_message TEXT)
BEGIN
    DECLARE v_final_grade DECIMAL(5,2) DEFAULT 0.0;
    DECLARE v_total_weight_used DECIMAL(5,2) DEFAULT 0.0;
    DECLARE v_does_student_exist INT DEFAULT 0;
    DECLARE v_does_course_exist INT DEFAULT 0;
    DECLARE v_is_student_enrolled INT DEFAULT 0;
    START TRANSACTION;
    -- Label for begin block for structured exception handling
    main_block: BEGIN
        -- Check if the student exists
        SELECT EXISTS(SELECT 1 FROM students WHERE student_id = p_student_id) INTO v_does_student_exist;
        -- Check if the course exists
        SELECT EXISTS(SELECT 1 FROM courses WHERE course_id = p_course_id) INTO v_does_course_exist;
        -- Exit if the student or course does not exist
        IF v_does_student_exist = 0 OR v_does_course_exist = 0 THEN
            SET p_message = 'Error: Student or course does not exist.';
            SELECT p_message, v_final_grade;
            ROLLBACK;
            LEAVE main_block;
        END IF;
        -- Check if the student is enrolled in the course
        SELECT EXISTS(SELECT 1 FROM enrollment WHERE student_id = p_student_id AND course_id = p_course_id) INTO v_is_student_enrolled;
        IF v_is_student_enrolled = 0 THEN
            SET p_message = 'Error: Student is not enrolled in the course.';
            SELECT p_message, v_final_grade;
            ROLLBACK;
            LEAVE main_block;
        END IF;
        -- Calculate the total weight of all assignments to ensure they sum to 100
        SELECT SUM(weight) INTO v_total_weight_used FROM course_grading_policy WHERE course_id = p_course_id;
        IF v_total_weight_used != 100 THEN
            SET p_message = 'Error: Total weight of assignments does not sum to 100.';
            SELECT p_message, v_final_grade;
            ROLLBACK;
            LEAVE main_block;
        END IF;
        -- Calculate the weighted score for assignments
        SELECT SUM(v_category_contribution) INTO v_final_grade
        FROM (
            SELECT 
                cgp.criteria_id,
                SUM(IF(a.total_points = 0 OR sa.points_earned IS NULL, 0, 
                       (sa.points_earned / a.total_points) * cgp.weight)) AS v_category_contribution
            FROM course_grading_policy cgp
            JOIN assignment a ON a.course_id = cgp.course_id AND a.criteria_id = cgp.criteria_id
            LEFT JOIN studentsassignments sa ON sa.assignment_id = a.assignment_id AND sa.student_id = p_student_id
            WHERE cgp.course_id = p_course_id
            GROUP BY cgp.criteria_id
        ) AS weighted_scores;
        -- Check if there are any graded assignments
        IF v_final_grade IS NULL THEN
            SET v_final_grade = 0.0;
            SET p_message = 'No graded assignments available.';
        ELSE
            SET v_final_grade = v_final_grade * (100 / v_total_weight_used);
            SET p_message = CONCAT('Grade calculation complete. Adjusted final grade based on available scores: ', CAST(v_final_grade AS CHAR));
        END IF;
        SELECT p_message, v_final_grade;
    END main_block;  -- Ensure proper closure of the main_block

    COMMIT;
END