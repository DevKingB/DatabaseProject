DROP PROCEDURE IF EXISTS ComputeGradeWithCategoryLowestDropped;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ComputeGradeWithCategoryLowestDropped`(
    IN p_student_id INT, 
    IN p_course_id INT, 
    IN p_criteria_id INT,  -- Specific grading criteria/category to potentially drop the lowest score
    OUT p_message TEXT)
BEGIN
    DECLARE v_final_grade DECIMAL(5,2) DEFAULT 0.0;
    DECLARE v_exist_student INT DEFAULT 0;
    DECLARE v_exist_course INT DEFAULT 0;
    DECLARE v_category_assignments_count INT DEFAULT 0;
    DECLARE v_assignments_graded_count INT DEFAULT 0;
    DECLARE v_total_weight_used DECIMAL(5,2) DEFAULT 0.0;
    -- Define a block label
    main_block: BEGIN

        -- Check for the existence of student and course
        SELECT EXISTS(SELECT 1 FROM students WHERE student_id = p_student_id) INTO v_exist_student;
        SELECT EXISTS(SELECT 1 FROM courses WHERE course_id = p_course_id) INTO v_exist_course;
        -- If student or course doesn't exist, set an error message and leave
        IF v_exist_student = 0 OR v_exist_course = 0 THEN
            SET p_message = 'Error: Student or course does not exist.';
            SELECT p_message, v_final_grade;
            LEAVE main_block;
        END IF;
        -- Check for the existence of any assignments in the specified category
        SELECT COUNT(*) FROM assignment WHERE course_id = p_course_id AND criteria_id = p_criteria_id INTO v_category_assignments_count;
        SELECT COUNT(*) FROM studentsAssignments WHERE assignment_id IN (SELECT assignment_id FROM assignment WHERE course_id = p_course_id AND criteria_id = p_criteria_id) AND points_earned IS NOT NULL INTO v_assignments_graded_count;
        -- Handle categories with insufficient data
        IF v_category_assignments_count = 0 OR v_assignments_graded_count = 0 THEN
            SET p_message = 'Error: No assignable or graded assignments in the specified category.';
            SELECT p_message, v_final_grade;
            LEAVE main_block;
        END IF;
        -- Calculate the weighted score for graded assignments, dropping the lowest score from the specified category
        SELECT SUM(v_category_contribution), SUM(cgp.weight) INTO v_final_grade, v_total_weight_used
        FROM (
            SELECT 
                cgp.criteria_id,
                IF(cgp.criteria_id = p_criteria_id AND v_assignments_graded_count > 1,
                   (SUM(sa.points_earned / a.total_points) - MIN(sa.points_earned / a.total_points)) * cgp.weight / (v_assignments_graded_count - 1),
                   SUM(sa.points_earned / a.total_points) * cgp.weight / v_assignments_graded_count
                ) * 100 AS v_category_contribution
            FROM course_grading_policy cgp
            JOIN assignment a ON a.course_id = cgp.course_id AND a.criteria_id = cgp.criteria_id
            LEFT JOIN students_assignments sa ON sa.assignment_id = a.assignment_id AND sa.student_id = p_student_id
            WHERE cgp.course_id = p_course_id AND sa.points_earned IS NOT NULL
            GROUP BY cgp.criteria_id
        ) AS weighted_scores;
        -- Set the final message based on grading completeness
        IF v_final_grade IS NULL THEN
            SET v_final_grade = 0.0;
            SET p_message = 'No effective grades computed.';
        ELSE
            SET v_final_grade = v_final_grade * (100 / v_total_weight_used); -- Adjust the grade to reflect only the categories that contributed
            SET p_message = CONCAT('Grade calculation complete with the lowest score dropped for the specified category. Final grade adjusted based on available scores: ', CAST(v_final_grade AS CHAR));
        END IF;
        -- Return the final grade and message
        SELECT p_message, v_final_grade;
    END main_block;
END