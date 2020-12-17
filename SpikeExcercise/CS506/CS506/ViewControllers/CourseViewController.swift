import UIKit

class CourseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentCourse = CourseModel(courseName: "", courseTerm: [String]());
    var tableDataSource: [AssignmentModelMin] = [AssignmentModelMin]();
    var isLogged: Bool = false;
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var average: UILabel!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var myprofileButton: UIButton!
    @IBOutlet weak var addassignmentButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func logout(_ sender: Any) {
        let defaults = UserDefaults.standard;
        defaults.removeObject(forKey: StorageKeys.email);
        defaults.removeObject(forKey: StorageKeys.userID);
        self.performSegue(withIdentifier: "Reload", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        var navigationArray: [UIViewController] = self.navigationController?.viewControllers ?? [UIViewController]()
        //To get all UIViewController stack as Array
        
        //Swift navigation juju
        if (navigationArray.count > 0 && (navigationArray[navigationArray.count - 2] as? AddAssignmentViewController) != nil) {
            navigationArray.remove(at: navigationArray.count - 2);
            self.navigationController?.viewControllers = navigationArray
        }
        
        self.table.delegate = self;
        self.table.dataSource = self;
        self.courseName.text = String.init(format: "Course %@", self.currentCourse.courseName);
        if (self.isLogged) {
            self.loginButton.isHidden = true;
        } else {
            self.logoutButton.isHidden = true;
            self.myprofileButton.isHidden = true;
            self.addassignmentButton.isHidden = true;
        }
        self.getCourseDetails();
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableDataSource.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row);
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell")! //1.cellReuseIdentifier
        
        let entry = self.tableDataSource[indexPath.row] //2.
        
        
        cell.textLabel?.text = entry.getAssignmentName() //3.
        
        return cell //4.
    }
    
    
    func getCourseDetails() {
        
        DatabaseManager().getCourseDetails(year: self.currentCourse.courseTerm[1], term: self.currentCourse.courseTerm[0], course: self.currentCourse.courseName) { (courseDetails) in
            self.currentCourse = courseDetails;
            
            self.tableDataSource = self.currentCourse.assingmensList;
            _ = self.average.text?.popLast();
            let group = DispatchGroup();
            for i in self.currentCourse.assingmensList {
                group.enter();
                DatabaseManager().getStudent(studentId: i.studentId) {
                    (student) in
                    i.studentName = String(format: "%@ %@", student.Name, student.LastName);
                    group.leave();
                }
            }
            group.notify(queue: .main) {
                // do something here when loop finished
            
            self.average.text?.append(String(format: "%.2f", self.currentCourse.average));
            self.average.reloadInputViews();
            self.table.reloadData();
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if ((segue.destination as? AssignmentViewController) != nil) {
            let assignmentIndex = self.table.indexPathForSelectedRow;
            self.table.deselectRow(at: assignmentIndex!, animated: true);
            let currentAssignment = self.tableDataSource[assignmentIndex!.row];
            
            let avc = segue.destination as! AssignmentViewController;
            let assignment = AssignmentModel();
            
            assignment.assignmentName = currentAssignment.assignmentName;
            assignment.studentId = currentAssignment.studentId;
            assignment.studentName = currentAssignment.studentName;
            assignment.assignmentID = currentAssignment.assignmentID;
            assignment.averageScore = currentAssignment.averageScore;
            
            assignment.course = currentCourse;
            avc.currentAssignment = assignment;
            avc.isLogged = self.isLogged;
        }
        
        if ((segue.destination as? AddAssignmentViewController) != nil) {
            let aavc = segue.destination as! AddAssignmentViewController;
            
            aavc.course = self.currentCourse;

        }
    }

}
