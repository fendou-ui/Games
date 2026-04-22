
import UIKit

class LoginAndRegisterVC: UIViewController {

    @IBOutlet weak var login_register_bg: UIImageView!
    @IBOutlet weak var email_textFiled: UITextField!
    @IBOutlet weak var password_textFiled: UITextField!
    @IBOutlet weak var select_login_image: UIImageView!
    @IBOutlet weak var select_register_image: UIImageView!
    @IBOutlet weak var login_button: UIButton!
    @IBOutlet weak var register_button: UIButton!
    @IBOutlet weak var tap_login_register: UIButton!
    @IBOutlet weak var select_eye_button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login_button.isSelected = true
        select_login_image.image = UIImage(named: "select_login")
        login_register_bg.image = UIImage(named: "bg_register")
        select_register_image.image = UIImage(named: "")
        password_textFiled.isSecureTextEntry = true
        select_eye_button.isSelected = true
    }
    
    @IBAction func loginAndRegisterClick(_ sender: UIButton) {
        select_login_image.image = UIImage(named: "")
        select_register_image.image = UIImage(named: "")
        login_button.isSelected = false
        register_button.isSelected = false
        if sender.tag == 333 {
            login_button.isSelected = true
            select_login_image.image = UIImage(named: "select_login")
            login_register_bg.image = UIImage(named: "bg_register")
        }else {
            register_button.isSelected = true
            select_register_image.image = UIImage(named: "select_register")
            login_register_bg.image = UIImage(named: "bg_login")
            
        }
    }
    
    @IBAction func tapCloseEyeAndOpenEyeClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        password_textFiled.isSecureTextEntry = sender.isSelected
    }
    
    
    @IBAction func tapEnterAndRegisterClick(_ sender: Any) {
   
    }
    
    @IBAction func tapAppleButtonClick(_ sender: Any) {
        
    }
    
    @IBAction func selectPrivacyAndTermsClick(_ sender: UIButton) {
        if sender.tag == 311 {
            sender.isSelected = !sender.isSelected
        }
        else if sender.tag == 312 {
            
        }
        else {
            
        }
    }
    
    
}
