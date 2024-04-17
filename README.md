# Grade Book Database Project
TEAM: Brandon Clarke, Ryan Taylor, Matthew Getachew
## Overview
This project implements a grade book database to manage student grades across various courses taught by a professor. The database supports multiple grading categories, dynamic assignment allocations, and comprehensive grade computations.

## Features
- **Course Management**: Track courses along with their department, number, name, semester, and year.
- **Grading System**: Flexible grading system based on participation, homework, tests, and projects.
- **Dynamic Assignment Handling**: Add or modify assignments and their grading weights dynamically.
- **Grade Calculations**: Compute average, highest, and lowest scores for assignments, and individual student grades with options to drop the lowest scores.

## Getting Started

### Prerequisites
- MySQL Server (Version 5.7 or newer)
- MySQL Client or any compatible database management tool

### Installation
1. Clone the repository:
```bash
   git clone https://github.com/DevKingB/DatabaseProject.git
```
2. Navigate to the project directory:
```bash
   cd gradebook
```
### Database Setup
1. Create the database and tables:
```bash
    mysql -u username -p < sql/create_tables.sql
```
2. Insert initial data
```bash
    mysql -u username -p < sql/insert_data.sql
```

### Usage
To interact with the database, use the provided SQL scripts for various operations:

Viewing Tables: 'mysql -u username -p < sql/view_tables.sql'
Adding Assignments: Edit 'sql/add_assignment.sql' as needed and run:
```bash
    mysql -u username -p < sql/add_assignment.sql
```
Modifying Category Percentages: Edit 'sql/change_percentages.sql' and execute:
```bash
    mysql -u username -p < sql/change_percentages.sql
```
Updating Scores: For adding points across different scenarios, use:
```bash
   mysql -u username -p < sql/update_scores.sql
```

### Running Tests
To execute the test cases:
1. Run the test script to validate all functionalities:
```bash
   mysql -u username -p < sql/run_tests.sql
```
2. Check the test results:
```bash
   mysql -u username -p < sql/view_test_results.sql
```
