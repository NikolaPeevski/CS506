import UIKit

class AddCourseViewController: UIViewController {

    var course: CourseModel = CourseModel(courseName: "", courseTerm: [String]());
    
    @IBOutlet weak var courseName: UITextField!
    
    @IBAction func addCourse(_ sender: Any) {
        if (courseName.text == "") {
            return;
        }
        
        course.courseName = courseName.text!;
        
        DatabaseManager().AddCourse(course: self.course) {
            () in
            self.performSegue(withIdentifier: "GoBack", sender: self);
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
