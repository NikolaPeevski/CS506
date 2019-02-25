import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class StartViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    var pickerDataSource = [String]();
    var lastPerformArgument: NSString? = nil
    var tableDataSource = [String]();
    var currentRow = 0;
    var isLogged:Bool = false;
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var myProfileButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var loginbutton: UIButton!
    @IBOutlet weak var addSemesterButton: UIButton!
    @IBOutlet weak var addCourseButton: UIButton!
    
    
    @IBAction func logout(_ sender: Any) {
        let defaults = UserDefaults.standard;
        defaults.removeObject(forKey: StorageKeys.email);
        defaults.removeObject(forKey: StorageKeys.userID);
        self.performSegue(withIdentifier: "Reload", sender: self);
    }
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
        self.currentRow = row;
        self.getCoursesBySemester(semester: pickerDataSource[row]);
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableDataSource.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell")!;
        
        let text = self.tableDataSource[indexPath.row];
        
        cell.textLabel?.text = text;
        
        return cell;
    }
    
    func getCoursesBySemester(semester: String) {
        
        let sem = semester.split(separator: " ");
        DatabaseManager().getCourses(year: String(sem[1]), term: String(sem[0])) { (courses) in
            
            self.tableDataSource = courses;
            self.table.reloadData();
            
        };
    }
    
    
    override func viewDidLoad() {
        
        let defaults = UserDefaults.standard;
        if let _ = defaults.string(forKey: StorageKeys.userID) {
            self.loginbutton.isHidden = true;
            self.isLogged = true;
        } else {
            self.myProfileButton.isHidden = true;
            self.logoutButton.isHidden = true;
            self.addCourseButton.isHidden = true;
            self.addSemesterButton.isHidden = true;
        }
        
        
        super.viewDidLoad();
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        self.table.dataSource = self;
        self.table.delegate = self;
        DatabaseManager().getSemesters { (semesters) in
            self.pickerDataSource = semesters;
            self.pickerView.reloadAllComponents();
            if (!semesters[0].isEmpty) {
                self.getCoursesBySemester(semester: semesters[0]);
                }
        };

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if ((segue.destination as? CourseViewController) != nil) {
        
            let courseIndex = self.table.indexPathForSelectedRow;
            
            let courseViewController = segue.destination as! CourseViewController;
            let course = CourseModel(courseName: self.tableDataSource[courseIndex!.row],
                                     courseTerm: self.pickerDataSource[self.currentRow].split(separator: " ").map(String.init) );
            courseViewController.currentCourse = course;
            courseViewController.isLogged = self.isLogged;
            self.table.deselectRow(at: courseIndex!, animated: true)
        }
        
        if ((segue.destination as? AddCourseViewController) != nil) {
            
            
            let acvc = segue.destination as! AddCourseViewController;
            let course = CourseModel(courseName: "",
                                     courseTerm: self.pickerDataSource[self.currentRow].split(separator: " ").map(String.init) );
            acvc.course = course;
        }

    }

}
