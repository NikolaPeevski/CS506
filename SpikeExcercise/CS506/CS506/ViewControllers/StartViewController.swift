//
//  StartViewController.swift
//  CS506
//
//  Created by Nikola Peevski on 21/02/2019.
//  Copyright © 2019 Nikola Peevski. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class StartViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var pickerDataSource = [String]();
    var lastPerformArgument: NSString? = nil
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerDataSource.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
//        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.getCoursesBySemester), object: self.lastPerformArgument)
//        self.lastPerformArgument = self.pickerDataSource[row] as NSString;
//        self.perform(#selector(self.getCoursesBySemester(semester:)), with: lastPerformArgument, afterDelay: 1.0)

        return pickerDataSource[row];
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        getCoursesBySemester(semester: pickerDataSource[row]);
    }
    
    func getCoursesBySemester(semester: String) {
        print("Doing things %@", semester);
    }
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        DatabaseManager().getSemesters { (semesters) in
            self.pickerDataSource = semesters;
            print(self.pickerDataSource.count);
            //[pickerView.relo reloadAllComponents];
            self.pickerView.reloadAllComponents();
            if (!semesters[0].isEmpty) {
                self.getCoursesBySemester(semester: semesters[0]);
                }
            for i in self.pickerDataSource {
                print(i);
            }
        };

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
