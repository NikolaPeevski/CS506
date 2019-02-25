import UIKit

class AddAssignmentViewController: UIViewController {
    
    var course: CourseModel = CourseModel(courseName: "", courseTerm: [String]());
    @IBOutlet weak var assignmentName: UITextField!
    
    @IBAction func addAssignment(_ sender: Any) {
        if (assignmentName.text == "") {
            return;
        }
        let assignment: AssignmentModelMin = AssignmentModelMin();
        assignment.assignmentName = assignmentName.text!;
        assignment.studentId = UserDefaults.standard.value(forKey: StorageKeys.userID) as! String;
        
        DatabaseManager().AddAssignment(assignment: assignment, course: self.course) {
            () in
            self.performSegue(withIdentifier: "GoBack", sender: self);
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let cvc = segue.destination as! CourseViewController;
        cvc.isLogged = true;
        cvc.currentCourse = self.course;
        cvc.currentCourse.courseTerm = cvc.currentCourse.courseTerm.reversed();
        
        
        var navigationArray = self.navigationController?.viewControllers //To get all UIViewController stack as Array
        navigationArray!.remove(at: (navigationArray?.count)! - 2)
        self.navigationController?.viewControllers = navigationArray!
        
        
    }

}
