# Student Profile and Skill Development Management System

A Spring Boot application built to manage student personal information, academic scores, and technical skill interests.

## Prerequisites
- Java 17+
- Maven
- MySQL Database

## Database Setup
Run `database/student_profile_system.sql` in MySQL Workbench or a MySQL client.
It creates the `student_db` database used by the application, the tables mapped
by the `Student` entity, and sample data.

## Running the Application
1. Set your MySQL credentials as environment variables. In PowerShell:
   ```powershell
   $env:DB_USERNAME = "root"
   $env:DB_PASSWORD = "your_mysql_password"
   ```
2. Run the application using Maven:
   ```bash
   mvn spring-boot:run
   ```
   On Windows without Maven installed, run `run.bat` or `mvnw.cmd spring-boot:run`.
   The Maven Wrapper downloads the configured Maven distribution on its first run.
3. Test the REST endpoints:
   - `GET /api/students`
   - `POST /api/students`
   - `GET /api/students/{id}`
   - `PUT /api/students/{id}`
   - `DELETE /api/students/{id}`
