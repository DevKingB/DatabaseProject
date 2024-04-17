-- Active: 1713288377970@@127.0.0.1@3306@gradebook
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
    DECLARE v_lowest_score DECIMAL(5,2);

    main_block: BEGIN

        -- Verify existence of student and course
        SELECT EXISTS(SELECT 1 FROM students WHERE student_id = p_student_id) INTO v_exist_student;
        SELECT EXISTS(SELECT 1 FROM courses WHERE course_id = p_course_id) INTO v_exist_course;
        IF v_exist_student = 0 OR v_exist_course = 0 THEN
            SET p_message = 'Error: Student or course does not exist.';
            LEAVE main_block;
        END IF;

        -- Verify enrollment
        SELECT EXISTS(SELECT 1 FROM enrollment WHERE student_id = p_student_id AND course_id = p_course_id) INTO v_assignments_graded_count;
        IF v_assignments_graded_count = 0 THEN
            SET p_message = 'Error: Student is not enrolled in the course.';
            LEAVE main_block;
        END IF;

        -- Count assignable and graded assignments
        SELECT COUNT(*) FROM assignment WHERE course_id = p_course_id AND criteria_id = p_criteria_id INTO v_category_assignments_count;
        SELECT COUNT(*) FROM studentsAssignments WHERE assignment_id IN (SELECT assignment_id FROM assignment WHERE course_id = p_course_id AND criteria_id = p_criteria_id) AND points_earned IS NOT NULL INTO v_assignments_graded_count;

        IF v_category_assignments_count = 0 OR v_assignments_graded_count = 0 THEN
            SET p_message = 'Error: No assignable or graded assignments in the specified category.';
            LEAVE main_block;
        END IF;

        -- Get the lowest score to potentially drop
        IF v_assignments_graded_count > 1 THEN
            SELECT MIN(sa.points_earned / a.total_points * cgp.weight) INTO v_lowest_score
            FROM studentsAssignments sa
            JOIN assignment a ON sa.assignment_id = a.assignment_id
            JOIN course_grading_policy cgp ON a.criteria_id = cgp.criteria_id
            WHERE sa.student_id = p_student_id AND a.course_id = p_course_id AND cgp.criteria_id = p_criteria_id;
        ELSE
            SET v_lowest_score = 0;
        END IF;

        -- Calculate the final grade excluding the lowest score if applicable
        SELECT SUM((sa.points_earned / a.total_points * cgp.weight) - (IF(cgp.criteria_id = p_criteria_id, v_lowest_score, 0))) INTO v_final_grade
        FROM studentsAssignments sa
        JOIN assignment a ON sa.assignment_id = a.assignment_id
        JOIN course_grading_policy cgp ON a.criteria_id = cgp.criteria_id
        WHERE sa.student_id = p_student_id AND a.course_id = p_course_id;

        -- Validate the total weight
        SELECT SUM(weight) INTO v_total_weight_used FROM course_grading_policy WHERE course_id = p_course_id;
        IF v_total_weight_used != 100 THEN
            SET p_message = 'Error: Total weight of grading criteria does not sum to 100.';
            LEAVE main_block;
        END IF;

        IF v_final_grade IS NULL THEN
            SET v_final_grade = 0.0;
            SET p_message = 'No effective grades computed.';
        ELSE
            SET v_final_grade = v_final_grade * (100 / v_total_weight_used);
            SET p_message = CONCAT('Grade calculation complete with the lowest score dropped for the specified category. Final grade adjusted based on available scores: ', CAST(v_final_grade AS CHAR));
        END IF;
        
        SELECT p_message, v_final_grade;
    END main_block;
END