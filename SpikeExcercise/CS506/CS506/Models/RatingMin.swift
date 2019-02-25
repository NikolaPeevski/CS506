//
//  RatingMin.swift
//  CS506
//
//  Created by Nikola Peevski on 23/02/2019.
//  Copyright © 2019 Nikola Peevski. All rights reserved.
//

import Foundation

class RatingMin {
    var by: String = "";
    var grade: String = "";
    var comment: String = "";
    
    func getReviewName() -> String {
        return String(format: "%@", self.by);
    }
}
