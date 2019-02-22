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

class StartViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    var pickerDataSource = [String]();
    var lastPerformArgument: NSString? = nil
    var tableDataSource = [String]();
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerDataSource.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row];
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.getCoursesBySemester(semester: pickerDataSource[row]);
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableDataSource.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row);
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell")! //1.cellReuseIdentifier
        
        let text = self.tableDataSource[indexPath.row] //2.
        
        cell.textLabel?.text = text //3.
        
        return cell //4.
    }
    
    func getCoursesBySemester(semester: String) {
        //0 - Semester Year
        //1 - Semester Term
        let sem = semester.split(separator: " ");
        DatabaseManager().getCourses(year: String(sem[1]), term: String(sem[0])) { (courses) in
            print(courses.count)
            for course in courses {
                print(course);
            }
            self.tableDataSource = courses;
            self.table.reloadData();
            
        };
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        self.table.dataSource = self;
        self.table.delegate = self;
        DatabaseManager().getSemesters { (semesters) in
            self.pickerDataSource = semesters;
            print(self.pickerDataSource.count);
            //[pickerView.relo reloadAllComponents];
            self.pickerView.reloadAllComponents();
            if (!semesters[0].isEmpty) {
                self.getCoursesBySemester(semester: semesters[0]);
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
