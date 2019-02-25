//
//  assignmentModelMin.swift
//  CS506
//
//  Created by Nikola Peevski on 23/02/2019.
//  Copyright © 2019 Nikola Peevski. All rights reserved.
//

import Foundation

class AssignmentModelMin {
    var assignmentID: String = "";
    var assignmentName: String = "";
    var studentId: String = "";
    var studentName: String = "";
    var averageScore: Double = 0;
    
    func getAssignmentName() -> String {
        return String(format: "%@ %@", self.assignmentName, self.studentName);
    }
}
