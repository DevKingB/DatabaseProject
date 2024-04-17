CREATE TABLE IF NOT EXISTS `courses` (
    `course_id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `course_number` VARCHAR(255) NOT NULL COMMENT 'Unique course number or code',
    `course_name` VARCHAR(255) NOT NULL COMMENT 'Descriptive name of the course',
    `department_id` INT NOT NULL COMMENT 'Reference to the department offering the course',
    `semester_offered` ENUM('Fall', 'Spring', 'Summer') COMMENT 'Semester when the course is offered',
    `year_offered` YEAR COMMENT 'Year when the course is offered',
    `student_capacity` INT COMMENT 'Maximum number of students allowed to enroll',
    CONSTRAINT `fk_courses_department_id` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;