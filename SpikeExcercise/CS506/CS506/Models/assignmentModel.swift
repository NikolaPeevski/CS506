//
//  assignmentModel.swift
//  CS506
//
//  Created by Nikola Peevski on 23/02/2019.
//  Copyright © 2019 Nikola Peevski. All rights reserved.
//

import Foundation

class AssignmentModel {
    var assignmentID: String = "";
    var assignmentName: String = "";
    var studentId: String = "";
    var studentName: String = "";
    var averageScore: Double = 0;
    var course: CourseModel = CourseModel(courseName: "", courseTerm: [String]());
    var ratingsList: [RatingMin] = [RatingMin]();
}
