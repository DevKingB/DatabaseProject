"# DatabaseProject" 
# Grade Book Database

This project aims to create a Grade Book Database to efficiently manage student grades for various courses taught by professors. The database allows for dynamic grading components and flexible assignment structures while ensuring accuracy and ease of use.

## Problem Statement

The objective is to design a system that tracks student grades across different courses. Each course is characterized by its department, course number, course name, semester, and year. The grading system includes various categories such as participation, homework, tests, and projects, with percentages totaling 100% and a maximum grade of 100. The number of assignments within each category is variable and subject to change. For example, a course may allocate grades as follows: 10% participation, 20% homework, 50% tests, and 20% projects. 

## Tasks

1. **Design the ER diagram**: Develop an Entity-Relationship (ER) diagram illustrating the database's structure, including attributes and keys.
2. **Create tables and insert values**: Write SQL commands to create tables and insert initial values.
3. **Display tables with inserted contents**: Present tables populated with initial data.
4. **Compute average/highest/lowest score of an assignment**: Implement functionality to calculate statistics on assignment scores.
5. **List all students in a given course**: Retrieve and display a list of students enrolled in a specific course.
6. **List all students in a course with their assignment scores**: Provide a comprehensive list of students enrolled in a course along with their scores for each assignment.
7. **Add an assignment to a course**: Enable addition of new assignments to existing courses.
8. **Change the percentages of grading categories for a course**: Modify the weightage of grading categories within a course.
9. **Add 2 points to all students' scores on an assignment**: Increase scores uniformly for all students on a specific assignment.
10. **Add 2 points to scores of students with last names containing 'Q'**: Specifically adjust scores for students with a certain characteristic.
11. **Compute grade for a student**: Calculate the overall grade for a student based on their performance in various assignments.
12. **Compute grade for a student, dropping lowest category score**: Determine the student's grade after excluding their lowest scoring category.

## Submission Requirements

### 1. ER Diagram
Include the ER diagram with attributes and primary/foreign keys clearly indicated.

### 2. SQL Commands
Provide SQL commands used for creating tables and inserting values.

### 3. Tables with Contents
Present tables populated with sample data.

### 4. Command Usage
Document the commands used for tasks 4 to 12.

### 5. Source Code
Include the source code for the database implementation.

### 6. README File
Create a README file containing instructions to compile and execute the code.

### 7. Test Cases and Results
Outline test cases utilized and the corresponding outcomes.

## Refined Database Schema

1. **Department Table**
   - department_id
   - department_name
   - department_code

2. **Course Table**
   - course_id
   - department_id
   - course_number
   - course_name
   - semester_offered
   - year_offered
   - student_capacity

3. **GradingComponent Table**
   - component_id
   - component_name

4. **CourseGradingPolicy Table**
   - policy_id
   - course_id
   - component_id
   - weight

5. **Assignment Table**
   - assignment_id
   - course_id
   - component_id
   - assignment_name
   - total_points

6. **Student Table**
   - student_id
   - first_name
   - last_name
   - email

7. **Enrollment Table**
   - enrollment_id
   - student_id
   - course_id
   - semester
   - year

8. **StudentAssignment Table**
   - student_assignment_id
   - assignment_id
   - student_id
   - points_earned
   - comments

## Design Considerations

- The schema prioritizes flexibility in grading components and assignment structures.
- It ensures streamlined management while accommodating dynamic changes in course requirements.