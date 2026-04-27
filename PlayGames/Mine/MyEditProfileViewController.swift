//

import UIKit

class MyEditProfileViewController: UIViewController {

    @IBOutlet weak var edit_profile_avatar: UIImageView!
    @IBOutlet weak var profile_name_text: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func handleNavgationBackAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleProfileChangeAvatarAndSaveAction(_ sender: UIButton) {
        
    }
    

}
