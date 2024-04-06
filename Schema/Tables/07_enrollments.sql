CREATE TABLE IF NOT EXISTS `enrollment` (
    `enrollment_id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `student_id` INT NOT NULL,
    `course_id` INT NOT NULL,
    `semester` ENUM('Fall', 'Spring', 'Summer') COMMENT 'The semester during which the student is enrolled in the course',
    `year` YEAR COMMENT 'The year during which the student is enrolled in the course',
    CONSTRAINT `fk_enrollment_to_student_id` FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`),
    CONSTRAINT `fk_enrollment_to_course_id` FOREIGN KEY (`course_id`) REFERENCES `courses`(`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Tracks student enrollments in courses, including the semester and year of enrollment';