import UIKit

class AddSemesterViewController: UIViewController {

    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var termField: UITextField!
    
    @IBAction func addSemester(_ sender: Any) {
        if (yearField.text == "" || termField.text == "") {
            return;
        }
        
        DatabaseManager().AddSemester(year:yearField.text!, term: termField.text!) {
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
