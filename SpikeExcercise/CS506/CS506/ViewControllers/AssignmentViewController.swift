import UIKit

class AssignmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var currentAssignment: AssignmentModel = AssignmentModel();
    
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var assignmentNameLabel: UILabel!
    @IBOutlet weak var averageScore: UILabel!
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var myprofileButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var addreviewButton: UIButton!
    
    @IBAction func logout(_ sender: Any) {
        let defaults = UserDefaults.standard;
        defaults.removeObject(forKey: StorageKeys.email);
        defaults.removeObject(forKey: StorageKeys.userID);
        self.performSegue(withIdentifier: "Reload", sender: self)
    }
    var tableDataSource = [RatingMin]();
    var isLogged: Bool = false;
    
    override func viewDidLoad() {
        print("Did load");
        super.viewDidLoad()
        
        var navigationArray: [UIViewController] = self.navigationController?.viewControllers ?? [UIViewController]()
        //To get all UIViewController stack as Array
        
        //Swift navigation juju
        if (navigationArray.count > 0 && (navigationArray[navigationArray.count - 2] as? AddReviewViewController) != nil) {
            navigationArray.remove(at: navigationArray.count - 2);
            self.navigationController?.viewControllers = navigationArray
        }
        
        self.table.delegate = self;
        self.table.dataSource = self;
        
        if (self.isLogged) {
            self.loginButton.isHidden = true;
        } else {
            self.myprofileButton.isHidden = true;
            self.logoutButton.isHidden = true;
            self.addreviewButton.isHidden = true;
            
        }
        
        studentNameLabel.text? = self.currentAssignment.studentName;
        assignmentNameLabel.text? = self.currentAssignment.assignmentName;
        averageScore.text? = String(String(format: "%.1f", self.currentAssignment.averageScore));
        getRatings();
        // Do any additional setup after loading the view.
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
        
        
        cell.textLabel?.text = entry.getReviewName() //3.
        
        return cell //4.
    }
    
    
    func getRatings() {
        DatabaseManager().getRatings(year: currentAssignment.course.courseTerm[0], term: currentAssignment.course.courseTerm[1], course: currentAssignment.course.courseName, assignmentID: currentAssignment.assignmentID) {
            (ratings) in
            self.currentAssignment.ratingsList = ratings;
            
            let group = DispatchGroup();
            for i in self.currentAssignment.ratingsList {
                group.enter();
                DatabaseManager().getStudent(studentId: i.by) {
                    (student) in
                    
                    i.by = String(format: "%@ %@", student.Name, student.LastName);
                    group.leave();
                }
            }
            
            group.enter();
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
                DatabaseManager().GetAssignmentAverage(assignment: self.currentAssignment) {
                    (assignment) in
                    self.currentAssignment = assignment;
                    print(String(format: "%.2f", self.currentAssignment.averageScore));
                    self.averageScore.text = String(String(format: "%.2f", self.currentAssignment.averageScore));
                    group.leave();
                }
            }
            
            group.notify(queue: .main) {
                // do something here when loop finished
                self.tableDataSource = self.currentAssignment.ratingsList;
                self.table.reloadData();
            }
            print(ratings);
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if ((segue.destination as? ReviewViewController) != nil) {
        
            let reviewIndex = self.table.indexPathForSelectedRow;
            self.table.deselectRow(at: reviewIndex!, animated: true);
            
            let currentReview = self.tableDataSource[reviewIndex!.row];
            
            let rvc = segue.destination as! ReviewViewController;
            rvc.currentReview = currentReview;
            rvc.isLogged = self.isLogged;
        }
        
        if ((segue.destination as? AddReviewViewController) != nil) {
            var arvc = segue.destination as! AddReviewViewController;
            
            arvc.assignment = self.currentAssignment;
            
        }
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
