
import UIKit
import AVFoundation

class CreateOnlineViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var online_room_covert: UIImageView! // 封面
    @IBOutlet weak var room_slogan_label: UILabel!
    @IBOutlet weak var room_slogan_ltextView: UITextView!
    
    var selectedVideoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        room_slogan_ltextView.layer.cornerRadius = 8
        room_slogan_ltextView.layer.masksToBounds = true
        room_slogan_ltextView.delegate = self
    }

    // 选择直播间的视频
    @IBAction func chooseOnlineRoomVideoClick(_ sender: Any) {
        let scheduler_picker_signal = UIImagePickerController()
        scheduler_picker_signal.sourceType = .photoLibrary
        scheduler_picker_signal.mediaTypes = ["public.movie"]
        scheduler_picker_signal.delegate = self
        scheduler_picker_signal.allowsEditing = true
        scheduler_picker_signal.modalPresentationStyle = .fullScreen
        present(scheduler_picker_signal, animated: true)
    }
    
    // 发布
    @IBAction func createOnlineRoomClick(_ sender: Any) {
        let slogan = room_slogan_ltextView.text ?? ""
        guard !slogan.isEmpty else {
            GameLoadingHUD.gameLoadingText("Please enter a room description", in: self.view)
            return
        }
        guard selectedVideoURL != nil else {
            GameLoadingHUD.gameLoadingText("Please select a video", in: self.view)
            return
        }
        
        let scheduler_profile_sign = GameDataManager.shared.dashboardsnapshot_load_userprofile()
        let coins = Int(scheduler_profile_sign["executor_wallet_coinsbalance_observerlistenerdelegate"] ?? "0") ?? 0
        
        if coins < 99 {
            GameLoadingHUD.gameLoadingText("Insufficient coins, 99 coins required to publish.", in: self.view)
            return
        }
        
        var executor_updatedProfile = scheduler_profile_sign
        executor_updatedProfile["executor_wallet_coinsbalance_observerlistenerdelegate"] = "\(coins - 99)"
        GameDataManager.shared.dashboardsnapshot_save_userprofile(executor_updatedProfile)
        
        GameLoadingHUD.gameLoadingShow("Creating… Please wait", in: self.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            GameLoadingHUD.gameLoadingSuccess("Submitted successfully, the live room is under review.", in: self.view)
            self.online_room_covert.image = UIImage(named: "")
            self.room_slogan_ltextView.text = ""
            self.room_slogan_label.text = "Please enter"
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let videoURL = info[.mediaURL] as? URL {
            selectedVideoURL = videoURL
            generateThumbnail(from: videoURL)
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func generateThumbnail(from url: URL) {
        let asset = AVAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let time = CMTime(seconds: 1, preferredTimescale: 60)
        DispatchQueue.global().async {
            if let cgImage = try? generator.copyCGImage(at: time, actualTime: nil) {
                let thumbnail = UIImage(cgImage: cgImage)
                DispatchQueue.main.async {
                    self.online_room_covert.image = thumbnail
                }
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        room_slogan_label.text = ""
        if room_slogan_ltextView.text.count == 0 {
            room_slogan_label.text = "Please enter"
        }
    }
}
