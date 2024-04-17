CREATE TABLE IF NOT EXISTS `students` (
    `student_id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT 'Unique identifier for each student',
    `first_name` VARCHAR(255) NOT NULL COMMENT 'The first name of the student',
    `last_name` VARCHAR(255) NOT NULL COMMENT 'The last name of the student',
    `email` VARCHAR(255) UNIQUE COMMENT 'The unique email address of the student'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Stores information about students';