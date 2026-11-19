package com.student.profile.controller;

import com.student.profile.model.Student;
import com.student.profile.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/students")
public class StudentController {

    @Autowired
    private StudentService studentService;

    @GetMapping
    public List<Student> getAllStudents() {
        return studentService.getAllStudents();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Student> getStudentById(@PathVariable Long id) {
        return studentService.getStudentById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public Student createStudent(@RequestBody Student student) {
        return studentService.saveStudent(student);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Student> updateStudent(@PathVariable Long id, @RequestBody Student studentDetails) {
        return studentService.getStudentById(id).map(student -> {
            student.setStudentId(studentDetails.getStudentId());
            student.setStudentName(studentDetails.getStudentName());
            student.setEmailAddress(studentDetails.getEmailAddress());
            student.setCourseName(studentDetails.getCourseName());
            student.setProgrammingScore(studentDetails.getProgrammingScore());
            student.setMathematicsScore(studentDetails.getMathematicsScore());
            student.setTechnicalSkills(studentDetails.getTechnicalSkills());
            Student updatedStudent = studentService.saveStudent(student);
            return ResponseEntity.ok(updatedStudent);
        }).orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteStudent(@PathVariable Long id) {
        if (studentService.getStudentById(id).isPresent()) {
            studentService.deleteStudent(id);
            return ResponseEntity.ok().build();
        }
        return ResponseEntity.notFound().build();
    }
}
