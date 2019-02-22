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
            print(snapshot.childrenCount) // I got the expected number of items
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
        print(year, term, "blabla");
        coursesRef.observeSingleEvent(of: .value) {
            snapshot in
            
            for course in snapshot.children.allObjects as! [DataSnapshot] {
                let taoughtIn = course.childSnapshot(forPath: "TaughtIn");
                
                if (taoughtIn.hasChildren()) {
                    for cYear in taoughtIn.children.allObjects as! [DataSnapshot] {
                        if (cYear.key == year) {
                            if (cYear.hasChildren()) {
                                for cTerm in cYear.children.allObjects as! [DataSnapshot] {
                                    if ((cTerm.value as! String) == term) {
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
}
