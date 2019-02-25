//
//  courseModel.swift
//  CS506
//
//  Created by Nikola Peevski on 23/02/2019.
//  Copyright © 2019 Nikola Peevski. All rights reserved.
//

import Foundation

class CourseModel {
    
    var courseName: String = "";
    var courseTerm: [String] = [String]();
    var average: Double = 0;
    var assingmensList: [AssignmentModelMin] = [AssignmentModelMin]();
    
    init(courseName: String, courseTerm: [String]) {
        self.courseName = courseName;
        self.courseTerm = courseTerm;
    }
}
