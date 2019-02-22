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
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                if (rest.hasChildren()) {
                    for child in rest.children.allObjects as! [DataSnapshot] {
                        res.append(String(format: "%@  %@",child.value as! String, rest.key));
                    }
                }
            }
            completion(res);
        }
    }
}
