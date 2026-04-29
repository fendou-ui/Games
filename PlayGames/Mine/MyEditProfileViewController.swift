

import UIKit

class MyEditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var edit_profile_avatar: UIImageView!
    @IBOutlet weak var profile_name_text: UITextField!
    
    var isFromRegister: Bool = false
    var selectedAvatarImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profile = GameDataManager.shared.dashboardsnapshot_load_userprofile()
        profile_name_text.text = profile["processhandler_profile_nickname_manager"]
        if let avatarName = profile["controllerserviceprovider_profile_avatarimage_adapter"] {
            edit_profile_avatar.image = UIImage(named: avatarName)
        }
        if let savedData = loadAvatarFromLocal(), let img = UIImage(data: savedData) {
            edit_profile_avatar.image = img
        }else {
            edit_profile_avatar.image = UIImage(named: "skydrifter_portrait")
        }
    }

    @IBAction func handleNavgationBackAction(_ sender: Any) {
        if isFromRegister {
            return
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleProfileChangeAvatarAndSaveAction(_ sender: UIButton) {
        if sender.tag == 511 { // 更换头像
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            present(picker, animated: true)
            return
        }
        let nickname = profile_name_text.text ?? ""
        guard !nickname.isEmpty else {
            GameLoadingHUD.gameLoadingText("Please enter your nickname", in: self.view)
            return
        }
        
        var profile = GameDataManager.shared.dashboardsnapshot_load_userprofile()
        profile["processhandler_profile_nickname_manager"] = nickname
        
        if selectedAvatarImage != nil {
            saveAvatarToLocal(selectedAvatarImage!)
            profile["controllerserviceprovider_profile_avatarimage_adapter"] = "local_avatar"
        }
        
        GameDataManager.shared.dashboardsnapshot_save_userprofile(profile)
        
        if isFromRegister {
            GameLoadingHUD.gameLoadingSuccess("Profile saved, The materials are under review.", in: self.view)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                let tabBar = SmiroTabBarController()
                tabBar.modalPresentationStyle = .fullScreen
                self.present(tabBar, animated: true)
            }
        } else {
            GameLoadingHUD.gameLoadingSuccess("Profile updated, The materials are under review.", in: self.view)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            selectedAvatarImage = editedImage
            edit_profile_avatar.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedAvatarImage = originalImage
            edit_profile_avatar.image = originalImage
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    // MARK: - 头像本地存储
    
    func saveAvatarToLocal(_ image: UIImage) {
        let account = GameDataManager.shared.currentAccountIdentifier
        if let data = image.jpegData(compressionQuality: 0.8) {
            let key = "LocalAvatarData_\(account)"
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func loadAvatarFromLocal() -> Data? {
        let account = GameDataManager.shared.currentAccountIdentifier
        return UserDefaults.standard.data(forKey: "LocalAvatarData_\(account)")
    }

}
