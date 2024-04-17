CREATE TABLE IF NOT EXISTS `grading_criteria` (
    `criteria_id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT 'Unique identifier for each grading criterion',
    `criteria_name` VARCHAR(255) NOT NULL UNIQUE COMMENT 'Name of the grading criterion'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Stores different grading criteria for courses';