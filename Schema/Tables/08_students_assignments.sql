CREATE TABLE IF NOT EXISTS `studentsAssignments` (
    `student_assignment_id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT 'Unique identifier for each student assignment record',
    `assignment_id` INT NOT NULL COMMENT 'References the assignment associated with this record',
    `student_id` INT NOT NULL COMMENT 'References the student associated with this record',
    `points_earned` DECIMAL(5,2) COMMENT 'The number of points the student earned for the assignment; allows for up to 999.99 points, including fractional points',
    `comments` TEXT DEFAULT NULL,
    CONSTRAINT `fk_studentsAssignments_to_assignment_id` FOREIGN KEY (`assignment_id`) REFERENCES `assignment` (`assignment_id`),
    CONSTRAINT `fk_studentsAssignments_to_student_id` FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;