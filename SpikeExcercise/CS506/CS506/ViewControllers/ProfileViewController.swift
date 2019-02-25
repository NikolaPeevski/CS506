import UIKit

class ProfileViewController: UIViewController {

    @IBAction func logout(_ sender: Any) {
        let defaults = UserDefaults.standard;
        defaults.removeObject(forKey: StorageKeys.email);
        defaults.removeObject(forKey: StorageKeys.userID);
        self.performSegue(withIdentifier: "Reload", sender: self);
    }
    
    var profile: ProfileModel = ProfileModel();
    

    @IBOutlet weak var currentTerm: UILabel!
    @IBOutlet weak var currentStudent: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var addCourse: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad();
        
        DatabaseManager().GetProfile(uid: UserDefaults.standard.value(forKey: StorageKeys.userID) as! String) {
        (profile) in
            self.profile = profile;
            
            
            self.email.text?.append(profile.email);
            self.firstName.text?.append(profile.firstName);
            self.lastName.text?.append(profile.lastName);
            self.email.text?.append(UserDefaults.standard.value(forKey: StorageKeys.email) as! String);
            self.currentTerm.text?.append(profile.currentTerm.joined(separator: " "))
        }
    }

}
