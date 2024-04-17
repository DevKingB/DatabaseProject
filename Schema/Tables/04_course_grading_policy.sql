 CREATE TABLE IF NOT EXISTS `course_grading_policy` (
    `policy_id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `course_id` INT NOT NULL,
    `criteria_id` INT NOT NULL,
    `weight` DECIMAL(5,2) NOT NULL COMMENT 'Percentage weight of the grading criterion',
    CONSTRAINT `fk_cgp_to_course_id` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`),
    CONSTRAINT `fk_cgp_to_criteria_id` FOREIGN KEY (`criteria_id`) REFERENCES `grading_criteria` (`criteria_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Stores different policies for the grading criteria for courses';