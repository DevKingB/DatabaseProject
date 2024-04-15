-- Active: 1713146534487@@127.0.0.1@3306@gradebook
DROP PROCEDURE IF EXISTS AdjustCategoryWeights;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AdjustCategoryWeights`(
    IN p_course_id INT,
    IN p_primary_category_id INT,
    IN p_new_weight DECIMAL(5,2),
    IN p_adjust_category_id INT
)
BEGIN
    DECLARE v_current_weight DECIMAL(5,2);
    DECLARE v_adjust_weight DECIMAL(5,2);
    DECLARE v_weight_difference DECIMAL(5,2);
    DECLARE v_total_weight DECIMAL(5,2);
    DECLARE v_adjust_new_weight DECIMAL(5,2);
    -- Start a new transaction
    START TRANSACTION;
    -- Get current weight of the primary category
    SELECT weight INTO v_current_weight FROM course_grading_policy 
    WHERE course_id = p_course_id AND criteria_id = p_primary_category_id;
    -- Calculate the difference that needs to be adjusted
    SET v_weight_difference = p_new_weight - v_current_weight;
    -- Get the current weight of the category to adjust
    SELECT weight INTO v_adjust_weight FROM course_grading_policy 
    WHERE course_id = p_course_id AND criteria_id = p_adjust_category_id;
    -- Calculate the new weight for the adjusting category
    SET v_adjust_new_weight = v_adjust_weight - v_weight_difference;
    -- Validate the new weights are within the valid range
    IF p_new_weight < 0 OR p_new_weight > 100 OR v_adjust_new_weight < 0 OR v_adjust_new_weight > 100 THEN
        -- Rollback the transaction if the weights are not valid
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Adjusted category weights must be between 0 and 100.';
    ELSE
        -- Update the weights in the database
        UPDATE course_grading_policy 
        SET weight = p_new_weight
        WHERE course_id = p_course_id AND criteria_id = p_primary_category_id;
        UPDATE course_grading_policy 
        SET weight = v_adjust_new_weight
        WHERE course_id = p_course_id AND criteria_id = p_adjust_category_id;
        -- Verify total weights
        SELECT SUM(weight) INTO v_total_weight FROM course_grading_policy WHERE course_id = p_course_id;
        IF v_total_weight <> 100 THEN
            -- Rollback the transaction if the total weights do not sum up to 100
            ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Total weights do not sum up to 100%. Adjustments required.';
        ELSE
            -- Commit the transaction if all is well
            COMMIT;
            SELECT 'Weights adjusted successfully. Total weights now sum up to 100%.';
        END IF;
    END IF;
END