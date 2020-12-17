import UIKit

class AddReviewViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var commentTextView: UITextView!
    
    var assignment: AssignmentModel = AssignmentModel();
    var course: CourseModel = CourseModel(courseName: "", courseTerm: [String]());
    
    let pickerData: [String] = ["A","B","C","D","F"]
    var currentRow: Int = 0;

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row];
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentRow = row;
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.delegate = self;
        self.picker.dataSource = self;
        

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation
    
    @IBAction func AddReview(_ sender: Any) {
        
        let review:RatingMin = RatingMin();
        review.by = UserDefaults.standard.value(forKey: StorageKeys.userID) as! String;
        review.comment = self.commentTextView.text ?? "";
        review.grade = self.pickerData[self.currentRow];

        
        DatabaseManager().AddReview(review: review, assignment: self.assignment) {
            () in
            self.performSegue(withIdentifier: "GoBack", sender: self);
        }
        
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let avc = segue.destination as! AssignmentViewController;
        avc.isLogged = true;
        avc.currentAssignment = self.assignment;
        
        
        var navigationArray = self.navigationController?.viewControllers //To get all UIViewController stack as Array
        navigationArray!.remove(at: (navigationArray?.count)! - 2)
        self.navigationController?.viewControllers = navigationArray!
        
        
    }

}
