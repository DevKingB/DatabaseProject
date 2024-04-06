CREATE TABLE IF NOT EXISTS `departments` (
    `department_id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT 'Unique identifier for each department',
    `department_name` varchar(255) NOT NULL COMMENT 'Name of the department',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'The date and time when the record was created',
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'The date and time when the record was last updated'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Stores department details';