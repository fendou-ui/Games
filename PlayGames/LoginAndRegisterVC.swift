
import UIKit
import AuthenticationServices

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
    
    var isPrivacy: Bool = false
    
    /**
     测试账号：playgames@gmail.com
     密码：123456
     */
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
        if isPrivacy == false {
            GameLoadingHUD.gameLoadingError("Please check and select the agreement", in: self.view)
            return
        }
        let email = email_textFiled.text ?? ""
        let password = password_textFiled.text ?? ""
        
        guard !email.isEmpty, !password.isEmpty else {
            GameLoadingHUD.gameLoadingText("Please enter email and password", in: self.view)
            return
        }
        
        if login_button.isSelected {
            gameLoginAccount(email: email, password: password)
        } else {
            gameRegisterAccount(email: email, password: password)
        }
    }
    
    @IBAction func tapAppleButtonClick(_ sender: Any) { // 苹果登录
        if isPrivacy == false {
            GameLoadingHUD.gameLoadingError("Please check and select the agreement", in: self.view)
            return
        }
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    @IBAction func selectPrivacyAndTermsClick(_ sender: UIButton) {
        if sender.tag == 311 {
            sender.isSelected = !sender.isSelected
            isPrivacy = sender.isSelected
        }
        else if sender.tag == 312 {
            
        }
        else {
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func gameRegisterAccount(email: String, password: String) {
        var accounts = UserDefaults.standard.dictionary(forKey: "GameRegisteredAccounts") as? [String: String] ?? [:]
        
        if accounts[email] != nil {
            GameLoadingHUD.gameLoadingText("This account already exists, please log in", in: self.view)
            return
        }
        
        accounts[email] = password
        UserDefaults.standard.set(accounts, forKey: "GameRegisteredAccounts")
        
        GameLoadingHUD.gameLoadingSuccess("Registration successful", in: self.view)
        UserDefaults.standard.set(email, forKey: "CurrentLoggedInAccount")
        gameAccountRegisterAndLoginSuccess()
    }
    
    func gameLoginAccount(email: String, password: String) {
        let accounts = UserDefaults.standard.dictionary(forKey: "GameRegisteredAccounts") as? [String: String] ?? [:]
        
        guard let savedPassword = accounts[email] else {
            GameLoadingHUD.gameLoadingError("Account not found, please register first", in: self.view)
            return
        }
        
        guard savedPassword == password else {
            GameLoadingHUD.gameLoadingError("Wrong password", in: self.view)
            return
        }
        
        GameLoadingHUD.gameLoadingSuccess("Login successful", in: self.view)
        UserDefaults.standard.set(email, forKey: "CurrentLoggedInAccount")
        gameAccountRegisterAndLoginSuccess()
    }
    
    func gameAccountRegisterAndLoginSuccess() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let tabBar = SmiroTabBarController()
            tabBar.modalPresentationStyle = .fullScreen
            self.present(tabBar, animated: true)
        }
    }
    
}

// Apple 登录
extension LoginAndRegisterVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userID = credential.user
            let email = credential.email ?? ""
            let fullName = [credential.fullName?.givenName, credential.fullName?.familyName]
                .compactMap { $0 }
                .joined(separator: " ")
            
            UserDefaults.standard.set(userID, forKey: "CurrentLoggedInAccount")
            UserDefaults.standard.set(userID, forKey: "GameAppleUserID")
            UserDefaults.standard.set(email, forKey: "GameAppleUserEmail")
            UserDefaults.standard.set(fullName, forKey: "GameAppleUserName")
            
            GameLoadingHUD.gameLoadingSuccess("Login successful", in: self.view)
            gameAccountRegisterAndLoginSuccess()
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        GameLoadingHUD.gameLoadingError("Apple login failed", in: self.view)
    }
}
