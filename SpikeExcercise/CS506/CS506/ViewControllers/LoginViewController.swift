import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBAction func login(_ sender: UIButton) {
        let email = emailField.text!;
        let password = passwordField.text!;
        
        Auth.auth().signIn(withEmail: email, password: password) {
            (user, error) in
            if error == nil {
                let defaults = UserDefaults.standard;
                defaults.set(user?.user.uid, forKey: StorageKeys.userID);
                defaults.set(user?.user.email, forKey: StorageKeys.email);
                self.performSegue(withIdentifier: "Login", sender: self);
            } else {
                //error
               self.handleError(error!)
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
