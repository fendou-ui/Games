
import UIKit

class MyProfileViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func handleUserSettingAction(_ sender: Any) {
        let setVC = MySettingViewController()
        setVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(setVC, animated: true)
    }
    
    @IBAction func profileOtherButtonAction(_ sender: UIButton) {
        if sender.tag == 511 {
            let profileVC = MyEditProfileViewController()
            profileVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(profileVC, animated: true)
        }
        else if sender.tag == 512 {
            let myWallte = MyWallteRechagreViewController()
            myWallte.modalPresentationStyle = .fullScreen
            present(myWallte, animated: true, completion: nil)
        }
        else if sender.tag == 515 {
            let fanslist = MyFollowingBlackListViewController()
            fanslist.otherTag = 2
            navigationController?.pushViewController(fanslist, animated: true)
        }
        else if sender.tag == 516 {
            let followerlist = MyFollowingBlackListViewController()
            followerlist.otherTag = 3
            navigationController?.pushViewController(followerlist, animated: true)
        }
    }
    
}
