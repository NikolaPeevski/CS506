import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet weak var byLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var commentLabel: UITextView!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var myprofileButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBAction func logout(_ sender: Any) {
        let defaults = UserDefaults.standard;
        defaults.removeObject(forKey: StorageKeys.email);
        defaults.removeObject(forKey: StorageKeys.userID);
        self.performSegue(withIdentifier: "Reload", sender: self)
    }
    var currentReview: RatingMin = RatingMin();
    var isLogged: Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.byLabel.text? = self.currentReview.by;
        self.gradeLabel.text? = self.currentReview.grade;
        self.commentLabel.text? = self.currentReview.comment;
        
        if (self.isLogged) {
            self.loginButton.isHidden = true;
        } else {
            self.myprofileButton.isHidden = true;
            self.logoutButton.isHidden = true;
        }
        // Do any additional setup after loading the view.
    }

}
