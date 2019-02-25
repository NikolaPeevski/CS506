//
//  databaseManager.swift
//  CS506
//
//  Created by Nikola Peevski on 21/02/2019.
//  Copyright © 2019 Nikola Peevski. All rights reserved.
//

import Foundation
import Firebase

class DatabaseManager {
    
    var ref: DatabaseReference!;
    
    init() {
        self.ref = Database.database().reference();
    }
    
    func getConnection() -> DatabaseReference {
        return self.ref;
    }
    
    func getSemesters(completion: @escaping ([String]) -> Void) {
        var res = [String]();
        
        let semesterRef = DatabaseManager().getConnection().child("Semesters");
        semesterRef.observeSingleEvent(of: .value) { snapshot in
            
            for rest in snapshot.children.reversed() as! [DataSnapshot] {
                if (rest.hasChildren()) {
                    for child in rest.children.reversed() as! [DataSnapshot] {
                        res.append(String(format: "%@  %@",child.value as! String, rest.key));
                    }
                }
            }
            completion(res);
        }
    }
    
    func getCourses(year: String, term: String, completion: @escaping ([String]) -> Void) {
        var res = [String]();
        
        let coursesRef = DatabaseManager().getConnection().child("Courses");
        
        coursesRef.observeSingleEvent(of: .value) {
            snapshot in
            
            for course in snapshot.children.allObjects as! [DataSnapshot] {
                let taoughtIn = course.childSnapshot(forPath: "TaughtIn");
                
                if (taoughtIn.hasChildren()) {
                    for cYear in taoughtIn.children.allObjects as! [DataSnapshot] {
                        if (cYear.key == year) {
                            if (cYear.hasChildren()) {
                                for cTerm in cYear.children.allObjects as! [DataSnapshot] {
                                    if ((cTerm.key) == term) {
                                        res.append(course.key);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            completion(res);
        }
    }
    
    func getCourseDetails(year: String, term: String, course: String, completion: @escaping (CourseModel) -> Void) {
        print(year, term, course);
        var res = CourseModel(courseName: course, courseTerm: [year,term]);
        let connection = DatabaseManager().getConnection();
        let courseRef = connection.child(String(format: "Courses/%@", course));
        
        courseRef.observeSingleEvent(of: .value) {
            snapshot in
            
            let taughtIn = snapshot.childSnapshot(forPath: "TaughtIn");
            
            if (taughtIn.hasChildren()) {
                for cYear in taughtIn.children.allObjects as! [DataSnapshot] {
                    if (cYear.key == year) {
                        if (cYear.hasChildren()) {
                            for cTerm in cYear.children.allObjects as! [DataSnapshot] {
                                if (cTerm.key == term) {
                                    if (cTerm.hasChildren()) {
                                        res.average = cTerm.childSnapshot(forPath: "Average").value as? Double ?? 0;                                                                                
                                        for assignment in cTerm.childSnapshot(forPath: "Assignments")
                                            .children.allObjects as! [DataSnapshot] {
                                                let _assignment = AssignmentModelMin();
                                                _assignment.assignmentName = assignment.childSnapshot(forPath: "Name").value as! String;
                                                _assignment.studentId = assignment.childSnapshot(forPath: "Student").value as! String;
                                                _assignment.assignmentID = assignment.key;
                                                _assignment.averageScore = assignment.childSnapshot(forPath: "Average").value as! Double;

                                                res.assingmensList.append(_assignment);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            completion(res);
        }
    }
    
    func getStudent(studentId: String, completion: @escaping (StudentModel) -> Void) {
        let student = StudentModel();
        let connection = DatabaseManager().getConnection();
        let studentRef = connection.child(String(format: "Users/%@", studentId));
        
        studentRef.observeSingleEvent(of: .value) {
            studentData in
            
            student.Name = studentData.childSnapshot(forPath: "Name").value as! String;
            student.LastName = studentData.childSnapshot(forPath: "LastName").value as! String;
            student.id = studentId;
            
            completion(student);
        }
    }
    
    func getRatings(year: String, term: String, course: String, assignmentID: String, completion: @escaping ([RatingMin]) -> Void) {
        var res = [RatingMin]();
        let connection = DatabaseManager().getConnection();
        
        let ratingsRef = connection.child(String(format: "Courses/%@/TaughtIn/%@/%@/Assignments/%@/Rating", course,year,term, assignmentID));
        
        ratingsRef.observeSingleEvent(of: .value) {
            ratings in
            print(ratings.childrenCount);
            if (!ratings.hasChildren()) {
                completion(res);
            }
            for rating in ratings.children.allObjects as! [DataSnapshot] {
                var rate: RatingMin = RatingMin();
                rate.by = rating.childSnapshot(forPath: "Name").value as! String;
                rate.grade = rating.childSnapshot(forPath: "Grade").value as! String;
                rate.comment = rating.childSnapshot(forPath: "Comment").value as! String;
                res.append(rate);
            }
            completion(res);
        }
    }
    func AddSemester(year: String, term: String, completion: @escaping () -> Void) {
        
        let connection = DatabaseManager().getConnection();
        
        let yearRef = connection.child(String(format: "Semesters/%@", year));
        
        yearRef.observeSingleEvent(of: .value) {
            semesters in
            let sem = [String(format: "%d", semesters.childrenCount + 1) : term];
            yearRef.updateChildValues(sem);
            
            completion();
        }
        
    }
    
    func AddCourse(course: CourseModel, completion: @escaping () -> Void) {
        
        let connection = DatabaseManager().getConnection();
        
        let courseRef = connection.child(String(format:"Courses/%@", course.courseName));
        
        courseRef.observeSingleEvent(of: .value) {
            (_course) in
            
            if (_course.hasChildren()) {
                //Just add term
                let node = String(format: "TaughtIn/%@/%@/Assignments/Average", course.courseTerm[1], course.courseTerm[0])
                let child = [
                    node: 0
                    ] as [String : Any]
                courseRef.updateChildValues(child);
                completion();
            } else {
                let node = String(format: "TaughtIn/%@/%@/Assignments/Average", course.courseTerm[1], course.courseTerm[0]);
                let child = [
                    "Name": course.courseName,
                    node: 0,
                    "Description": ""
                    ] as [String : Any]
                courseRef.updateChildValues(child);
                completion();
            }
        }
    }
    
    func AddAssignment(assignment: AssignmentModelMin, course: CourseModel, completion: @escaping () -> Void) {
        
        let connection = DatabaseManager().getConnection();
        
        let courseRef = connection.child(String(format:"Courses/%@/TaughtIn/%@/%@/Assignments", course.courseName,course.courseTerm[0], course.courseTerm[1]));
        
        courseRef.observeSingleEvent(of: .value) {
            (_course) in
            
            let key = _course.childrenCount + 1;
            
            let assignment = [
                String(format: "%d/Rating", key): "",
                String(format: "%d/Name", key): assignment.assignmentName,
                String(format: "%d/Student", key): assignment.studentId,
                String(format: "%d/Average", key): 0
                ] as [String : Any]
            
            courseRef.updateChildValues(assignment);
            completion();
        }
    }
    
    func AddReview(review: RatingMin, assignment: AssignmentModel, completion: @escaping () -> Void) {
        
        let connection = DatabaseManager().getConnection();
        
        let assignmentRef = connection.child(String(format:"Courses/%@/TaughtIn/%@/%@/Assignments/%@/Rating", assignment.course.courseName, assignment.course.courseTerm[0], assignment.course.courseTerm[1], assignment.assignmentID));
        
        assignmentRef.observeSingleEvent(of: .value) {
            (_assignment) in
            
            let key = _assignment.childrenCount + 1;
            
            let rating = [
                String(format: "%d/Comment", key): review.comment,
                String(format: "%d/Grade", key): review.grade,
                String(format: "%d/Name", key): review.by
                ] as [String : Any]
            
            assignmentRef.updateChildValues(rating);
            completion();
        }
    }
    
    func GetProfile(uid:String, completion: @escaping (ProfileModel) -> Void) {
        
        let connection = DatabaseManager().getConnection();
        
        let profileRef = connection.child(String(format:"Users/%@", uid));
        
        profileRef.observeSingleEvent(of: .value) {
            (_user) in
            
            let user = ProfileModel();
            user.currentTerm = (_user.childSnapshot(forPath: "CurrentTerm").value as! String).split(separator: " ").map(String.init);
            user.firstName = _user.childSnapshot(forPath: "Name").value as! String;
            user.lastName = _user.childSnapshot(forPath: "LastName").value as! String;
            
            completion(user);
        }
    }
    
    func RegisterUser(uid:String, firstName: String, lastName: String, currentTerm: String, completion: @escaping () -> Void) {
        
        let connection = DatabaseManager().getConnection();
        
        let profileRef = connection.child(String(format:"Users/%@", uid));
        
        profileRef.observeSingleEvent(of: .value) {
            (_user) in
            
            let profile = [
                "Name": firstName,
                "LastName": lastName,
                "CurrentTerm": currentTerm
            ]
            profileRef.updateChildValues(profile);
            
            completion();
        }
    }
}
