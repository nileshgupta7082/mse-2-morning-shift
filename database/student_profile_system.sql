-- Schema and sample data matching src/main/java/com/student/profile/Student.java

CREATE DATABASE IF NOT EXISTS student_db;
USE student_db;

CREATE TABLE IF NOT EXISTS students (
    id BIGINT NOT NULL AUTO_INCREMENT,
    student_id VARCHAR(255) NOT NULL,
    student_name VARCHAR(255) NOT NULL,
    email_address VARCHAR(255) NOT NULL,
    course_name VARCHAR(255),
    programming_score DOUBLE,
    mathematics_score DOUBLE,
    PRIMARY KEY (id),
    CONSTRAINT uk_students_student_id UNIQUE (student_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS student_technical_skills (
    student_pk BIGINT NOT NULL,
    skill VARCHAR(255),
    CONSTRAINT fk_student_technical_skills_student
        FOREIGN KEY (student_pk) REFERENCES students (id) ON DELETE CASCADE
) ENGINE=InnoDB;

INSERT INTO students (
    student_id, student_name, email_address, course_name,
    programming_score, mathematics_score
)
SELECT seed.student_id, seed.student_name, seed.email_address, seed.course_name,
       seed.programming_score, seed.mathematics_score
FROM (
    SELECT '101' AS student_id, 'Alice Johnson' AS student_name,
           'alice@university.edu' AS email_address, 'Computer Science' AS course_name,
           95.00 AS programming_score, 92.00 AS mathematics_score
    UNION ALL SELECT '102', 'Bob Smith', 'bob@university.edu',
           'Information Technology', 42.00, 82.00
    UNION ALL SELECT '103', 'Charlie Brown', 'charlie@university.edu',
           'Computer Science', 78.00, 74.00
    UNION ALL SELECT '104', 'David Miller', 'david@university.edu',
           'Data Science', 45.00, 40.00
    UNION ALL SELECT '105', 'Eve Adams', 'eve@university.edu',
           'Computer Science', 85.00, 85.00
) AS seed
WHERE NOT EXISTS (
    SELECT 1 FROM students existing WHERE existing.student_id = seed.student_id
);

INSERT INTO student_technical_skills (student_pk, skill)
SELECT s.id, seed.skill
FROM (
    SELECT '101' AS student_id, 'Python' AS skill
    UNION ALL SELECT '101', 'SQL'
    UNION ALL SELECT '102', 'Python'
    UNION ALL SELECT '102', 'Java'
    UNION ALL SELECT '103', 'SQL'
    UNION ALL SELECT '103', 'Java'
    UNION ALL SELECT '104', 'Python'
    UNION ALL SELECT '105', 'C++'
) AS seed
JOIN students s ON s.student_id = seed.student_id
WHERE NOT EXISTS (
    SELECT 1
    FROM student_technical_skills existing
    WHERE existing.student_pk = s.id AND existing.skill = seed.skill
);

-- Average score and performance category
SELECT student_id, student_name,
       ROUND((mathematics_score + programming_score) / 2, 2) AS average_score,
       CASE
           WHEN (mathematics_score + programming_score) / 2 >= 85 THEN 'Excellent'
           WHEN (mathematics_score + programming_score) / 2 >= 70 THEN 'Good'
           WHEN (mathematics_score + programming_score) / 2 >= 50 THEN 'Satisfactory'
           ELSE 'Needs Improvement'
       END AS performance_category
FROM students
WHERE mathematics_score IS NOT NULL AND programming_score IS NOT NULL;

-- Stronger subject
SELECT student_id, student_name, mathematics_score, programming_score,
       CASE
           WHEN mathematics_score > programming_score THEN 'Mathematics'
           WHEN programming_score > mathematics_score THEN 'Programming'
           ELSE 'Both are Equal'
       END AS stronger_subject
FROM students
WHERE mathematics_score IS NOT NULL AND programming_score IS NOT NULL;

-- Search examples
SELECT * FROM students WHERE student_id = '101';
SELECT * FROM students WHERE email_address = 'bob@university.edu';
SELECT * FROM students WHERE course_name = 'Computer Science';
SELECT * FROM students
WHERE student_id = '101'
   OR email_address = 'bob@university.edu'
   OR course_name = 'Data Science';

-- Merit list
SELECT DENSE_RANK() OVER (
           ORDER BY (mathematics_score + programming_score) / 2 DESC
       ) AS merit_rank,
       student_id, student_name, course_name,
       ROUND((mathematics_score + programming_score) / 2, 2) AS average_score
FROM students
WHERE mathematics_score IS NOT NULL AND programming_score IS NOT NULL
ORDER BY average_score DESC;

-- Students who share a technical skill
SELECT skills.skill, GROUP_CONCAT(s.student_name ORDER BY s.student_name) AS students_with_skill,
       COUNT(*) AS total_students
FROM student_technical_skills skills
JOIN students s ON s.id = skills.student_pk
GROUP BY skills.skill
HAVING COUNT(*) > 1;

SELECT skills.skill, s1.student_name AS student_1, s2.student_name AS student_2
FROM student_technical_skills skills
JOIN student_technical_skills other
  ON other.skill = skills.skill AND other.student_pk > skills.student_pk
JOIN students s1 ON s1.id = skills.student_pk
JOIN students s2 ON s2.id = other.student_pk
ORDER BY skills.skill, student_1, student_2;

-- Programming score below 50 with mathematics score of at least 75
SELECT student_id, student_name, mathematics_score, programming_score
FROM students
WHERE programming_score < 50 AND mathematics_score >= 75;
