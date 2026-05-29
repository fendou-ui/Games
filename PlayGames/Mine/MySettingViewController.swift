
import UIKit

class MySettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var mySettes: [[String: String]] = [[String: String]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        settingMetedata()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MySettingTableViewCell", bundle: nil), forCellReuseIdentifier: "set")
    }
    // https://docs.google.com/document/d/163lAGA_h07sbQkuGs6ZBIucpN_umuppRFdTlREbBewA/edit?usp=sharing
    
    //用户协议：https://docs.google.com/document/d/1h3NDNrcpCkT413QawVD9Tyu6Zb38z1YqjGXwQsDvzLg/edit?usp=sharing
    
    //隐私协议：https://docs.google.com/document/d/1GlYwAN0uc-Cx0HICzthyjIVV-3kWNRNOfziY9X37cSo/edit?usp=sharing
    
    // lvsevbsook@gmail.com

    
    func settingMetedata() {
        mySettes = [
            ["image_icon": "dfmniqwe", "item_name": "Video with likes"],
            ["image_icon": "sdfnjksdf", "item_name": "Blacklist"],
            ["image_icon": "mjcxhnvjsdh", "item_name": "Privacy agreement"],
            ["image_icon": "cmxvnjs", "item_name": "User agreement"],
            ["image_icon": "qwndsjkfer", "item_name": "Contact Us"],
            ["image_icon": "qwnjkdsnfr", "item_name": "Community guidelines"],
            ["image_icon": "sdjfhwer", "item_name": "Deletion of account"],
        ]
    }

    @IBAction func handleNavgationBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleExitLogOutAction(_ sender: Any) {
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive) { _ in
            UserDefaults.standard.removeObject(forKey: "CurrentLoggedInAccount")
            let loginVC = UINavigationController(rootViewController: LoginAndRegisterVC())
            loginVC.modalPresentationStyle = .fullScreen
            if let window = GameDataManager.shared.coordinatordispatcherKeyWindow {
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
                    window.rootViewController = loginVC
                }
            }
        })
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySettes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "set", for: indexPath) as! MySettingTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let dict = mySettes[indexPath.item]
        cell.set_image_icon.image = UIImage(named: dict["image_icon", default: ""])
        cell.set_label.text = dict["item_name"]
        if dict["item_name"] == "Deletion of account" {
            cell.set_label.textColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = mySettes[indexPath.item]
        if dict["item_name"] == "Video with likes" {
            self.navigationController?.pushViewController(MyLikeVideoViewController(), animated: true)
        }
        else if dict["item_name"] == "Blacklist" {
            let blacklist = MyFollowingBlackListViewController()
            blacklist.otherTag = 1
            navigationController?.pushViewController(blacklist, animated: true)
        }
        else if dict["item_name"] == "Contact Us" {
            showContactUsPopup()
        }
        else if dict["item_name"] == "Deletion of account" {
            showDeleteAccountAlert()
        }
        else if dict["item_name"] == "Privacy agreement" {
            openAgreementPage(.privacy)
        }
        else if dict["item_name"] == "User agreement" {
            openAgreementPage(.terms)
        }
        else if dict["item_name"] == "Community guidelines" {
            openAgreementPage(.communityGuidelines)
        }
    }
    
    private func openAgreementPage(_ page: GameAgreementPage) {
        let webVC = GameAgreementWebViewController(page: page)
        webVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    func showDeleteAccountAlert() {
        let alert = UIAlertController(title: "Delete Account", message: "This will permanently delete your account and all associated data. This action cannot be undone.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            let account = GameDataManager.shared.currentAccountIdentifier
            
            var accounts = UserDefaults.standard.dictionary(forKey: "GameRegisteredAccounts") as? [String: String] ?? [:]
            accounts.removeValue(forKey: account)
            UserDefaults.standard.set(accounts, forKey: "GameRegisteredAccounts")
            
            UserDefaults.standard.removeObject(forKey: "AccountUserProfileStorage_\(account)")
            UserDefaults.standard.removeObject(forKey: "AccountFriendsListStorage_\(account)")
            UserDefaults.standard.removeObject(forKey: "CurrentLoggedInAccount")
            
            GameLoadingHUD.gameLoadingSuccess("Account deleted", in: self.view)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                let loginVC = UINavigationController(rootViewController: LoginAndRegisterVC())
                loginVC.modalPresentationStyle = .fullScreen
                if let window = GameDataManager.shared.coordinatordispatcherKeyWindow {
                    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
                        window.rootViewController = loginVC
                    }
                }
            }
        })
        present(alert, animated: true)
    }
    
    func showContactUsPopup() {
        let email = "lvsevbsook@gmail.com"
        
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.alpha = 0
        overlay.tag = 8888
        
        let card = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 220))
        card.center = overlay.center
        card.backgroundColor = .white
        card.layer.cornerRadius = 20
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.2
        card.layer.shadowOffset = CGSize(width: 0, height: 8)
        card.layer.shadowRadius = 24
        card.tag = 9999
        
        let iconLabel = UILabel(frame: CGRect(x: 0, y: 24, width: 300, height: 36))
        iconLabel.text = "✉️"
        iconLabel.font = UIFont.systemFont(ofSize: 32)
        iconLabel.textAlignment = .center
        card.addSubview(iconLabel)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 64, width: 300, height: 24))
        titleLabel.text = "Contact Us"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        titleLabel.textAlignment = .center
        card.addSubview(titleLabel)
        
        let emailBg = UIView(frame: CGRect(x: 30, y: 100, width: 240, height: 44))
        emailBg.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 248/255, alpha: 1.0)
        emailBg.layer.cornerRadius = 12
        card.addSubview(emailBg)
        
        let emailLabel = UILabel(frame: CGRect(x: 12, y: 0, width: 216, height: 44))
        emailLabel.text = email
        emailLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        emailLabel.textColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1.0)
        emailLabel.textAlignment = .center
        emailBg.addSubview(emailLabel)
        
        let copyBtn = UIButton(frame: CGRect(x: 30, y: 160, width: 115, height: 42))
        copyBtn.setTitle("Copy", for: .normal)
        copyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        copyBtn.setTitleColor(.white, for: .normal)
        copyBtn.backgroundColor = UIColor(red: 101/255, green: 84/255, blue: 255/255, alpha: 1.0)
        copyBtn.layer.cornerRadius = 21
        copyBtn.addTarget(self, action: #selector(contactUsCopyEmail), for: .touchUpInside)
        card.addSubview(copyBtn)
        
        let closeBtn = UIButton(frame: CGRect(x: 155, y: 160, width: 115, height: 42))
        closeBtn.setTitle("Close", for: .normal)
        closeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        closeBtn.setTitleColor(UIColor(red: 101/255, green: 84/255, blue: 255/255, alpha: 1.0), for: .normal)
        closeBtn.backgroundColor = UIColor(red: 238/255, green: 235/255, blue: 255/255, alpha: 1.0)
        closeBtn.layer.cornerRadius = 21
        closeBtn.addTarget(self, action: #selector(contactUsClosePopup), for: .touchUpInside)
        card.addSubview(closeBtn)
        
        overlay.addSubview(card)
        view.addSubview(overlay)
        
        card.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            overlay.alpha = 1
            card.transform = .identity
        }
    }
    
    @objc func contactUsCopyEmail() {
        UIPasteboard.general.string = "lvsevbsook@gmail.com"
        GameLoadingHUD.gameLoadingSuccess("Email copied", in: self.view)
    }
    
    @objc func contactUsClosePopup() {
        if let overlay = view.viewWithTag(8888) {
            UIView.animate(withDuration: 0.2, animations: {
                overlay.alpha = 0
            }) { _ in
                overlay.removeFromSuperview()
            }
        }
    }
    
}
