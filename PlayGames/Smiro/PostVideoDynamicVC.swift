
import UIKit
import AVFoundation

class PostVideoDynamicVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var tap_add_video_button: UIButton!
    @IBOutlet weak var post_video_photo_imageView: UIImageView!
    @IBOutlet weak var please_enter_label: UILabel!
    @IBOutlet weak var please_enter_textView: UITextView!
    var handshake_tag_watchdog: Int = 1 // 1、为视频 2、为动态
    
    var selectedVideoURL: URL?
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        please_enter_textView.layer.cornerRadius = 8
        please_enter_textView.layer.masksToBounds = true
        please_enter_textView.delegate = self
        
        if handshake_tag_watchdog == 2 {
            tap_add_video_button.setImage(UIImage(named: "tap_select_picture"), for: .normal)
        }
    }
    
    @IBAction func animateGameCommunityPopupViewPresentationWithSpringEffect(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // 选择视频或者动态
    @IBAction func post_selectAddPhotoWithVideoClick(_ sender: UIButton) {
        let scheduler_picker_signal = UIImagePickerController()
        scheduler_picker_signal.sourceType = .photoLibrary
        scheduler_picker_signal.delegate = self
        scheduler_picker_signal.allowsEditing = true
        if handshake_tag_watchdog == 1 {
            scheduler_picker_signal.mediaTypes = ["public.movie"]
        } else {
            scheduler_picker_signal.mediaTypes = ["public.image"]
        }
        scheduler_picker_signal.modalPresentationStyle = .fullScreen
        present(scheduler_picker_signal, animated: true)
    }
    
    // 发布视频或者动态
    @IBAction func post_videoAndPhotoTextViewClick(_ sender: UIButton) {
        let desc = please_enter_textView.text ?? ""
        guard !desc.isEmpty else {
            GameLoadingHUD.gameLoadingText("Please enter a description", in: self.view)
            return
        }
        
        if handshake_tag_watchdog == 1 {
            guard selectedVideoURL != nil else {
                GameLoadingHUD.gameLoadingText("Please select a video", in: self.view)
                return
            }
        } else {
            guard selectedImage != nil else {
                GameLoadingHUD.gameLoadingText("Please select an image", in: self.view)
                return
            }
        }
        
        let currentProfile = GameDataManager.shared.dashboardsnapshot_load_userprofile()
        let coins = Int(currentProfile["executor_wallet_coinsbalance_observerlistenerdelegate"] ?? "0") ?? 0
        
        if coins < 55 {
            GameLoadingHUD.gameLoadingText("Insufficient coins, 55 coins required to publish.", in: self.view)
            return
        }
        
        var updatedProfile = currentProfile
        updatedProfile["executor_wallet_coinsbalance_observerlistenerdelegate"] = "\(coins - 55)"
        GameDataManager.shared.dashboardsnapshot_save_userprofile(updatedProfile)
        
        let typeText = handshake_tag_watchdog == 1 ? "video" : "post"
        GameLoadingHUD.gameLoadingShow("Publishing \(typeText)… Please wait", in: self.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            GameLoadingHUD.gameLoadingSuccess("Submitted successfully, the \(typeText) is under review.", in: self.view)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if handshake_tag_watchdog == 1 {
            if let videoURL = info[.mediaURL] as? URL {
                selectedVideoURL = videoURL
                generateThumbnail(from: videoURL)
            }
        } else {
            if let editedImage = info[.editedImage] as? UIImage {
                selectedImage = editedImage
                post_video_photo_imageView.image = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                selectedImage = originalImage
                post_video_photo_imageView.image = originalImage
            }
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
                    self.post_video_photo_imageView.image = thumbnail
                }
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        please_enter_label.text = ""
        if please_enter_textView.text.count == 0 {
            please_enter_label.text = "Please enter"
        }
    }
}
