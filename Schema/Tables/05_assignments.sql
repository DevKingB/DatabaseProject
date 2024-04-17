CREATE TABLE IF NOT EXISTS `assignment` (
    `assignment_id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT 'Unique identifier for each assignment',
    `course_id` INT NOT NULL COMMENT 'References the course to which the assignment belongs',
    `criteria_id` INT NOT NULL COMMENT 'References the grading criterion applicable to the assignment',
    `assignment_name` VARCHAR(255) NOT NULL COMMENT 'The name or title of the assignment',
    `total_points` DECIMAL(5,2) NOT NULL COMMENT 'The total points achievable for the assignment',
    CONSTRAINT `fk_assignment_to_course_id` FOREIGN KEY (`course_id`) REFERENCES `courses`(`course_id`),
    CONSTRAINT `fk_assignment_to_criteria_id` FOREIGN KEY (`criteria_id`) REFERENCES `grading_criteria`(`criteria_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Stores information about individual assignments for courses, including grading criteria and points';