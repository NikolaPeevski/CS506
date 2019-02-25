import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var currentTermField: UITextField!
    @IBAction func signUp(_ sender: Any) {
        
        let email = emailField.text!;
        let password = passwordField.text!;
        
        Auth.auth().createUser(withEmail: email, password: password) {
            (user, error) in
            if error == nil {
                let defaults = UserDefaults.standard;
                defaults.set(user?.user.uid, forKey: StorageKeys.userID);
                defaults.set(user?.user.email, forKey: StorageKeys.email);
                DatabaseManager().RegisterUser(uid: user?.user.uid ?? "", firstName: self.firstNameField.text ?? "", lastName: self.lastNameField.text ?? "", currentTerm: self.currentTermField.text ?? "") {
                    () in
                    self.performSegue(withIdentifier: "SignUp", sender: self);
                }
            } else {
                //error
                self.handleError(error!)
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
