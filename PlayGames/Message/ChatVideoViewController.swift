
import UIKit
import AVFoundation

class ChatVideoViewController: UIViewController {

    @IBOutlet weak var chat_name_label: UILabel!
    @IBOutlet weak var chat_shoot_view: UIView!
    @IBOutlet weak var chat_video_close_button: UIButton!
    var report_black_view = PlayReportBlackView()
    
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var chatTargetNickname: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIReportBlackView()
        
        let friendsList = GameDataManager.shared.rosterconnection_current_friendslist_retrieve()
        let isFriend = friendsList.contains(where: { $0["nickname"] == chatTargetNickname })
        if !isFriend {
            GameLoadingHUD.gameLoadingText("You can only video chat after becoming friends.", in: self.view)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.dismiss(animated: true, completion: nil)
            }
            return
        }
        
        chat_name_label.text = chatTargetNickname
        setupCamera()
        startShakeAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startShakeAnimation()
    }
    
    func startShakeAnimation() {
        let shake = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        shake.values = [-0.08, 0.08, -0.06, 0.06, -0.04, 0.04, 0.0]
        shake.duration = 0.5
        shake.repeatCount = .infinity
        chat_video_close_button.layer.add(shake, forKey: "shakeAnimation")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = chat_shoot_view.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession?.stopRunning()
    }
    
    func setupCamera() {
        let session = AVCaptureSession()
        session.sessionPreset = .high
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            return
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        let preview = AVCaptureVideoPreviewLayer(session: session)
        preview.videoGravity = .resizeAspectFill
        preview.frame = chat_shoot_view.bounds
        chat_shoot_view.layer.addSublayer(preview)
        
        captureSession = session
        previewLayer = preview
        
        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }
    }
    
    func setupUIReportBlackView() {
        report_black_view = UINib(nibName: "PlayReportBlackView", bundle: nil).instantiate(withOwner: self, options: nil).first as! PlayReportBlackView
        report_black_view.delegate = self
        view.addSubview(report_black_view)
        report_black_view.frame = CGRect(x: 0, y: 1200, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }

    @IBAction func handleUserCenterNavReturnClick(_ sender: UIButton) {
        if sender.tag == 512 {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            UIView.animate(withDuration: 0.31) {
                self.report_black_view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }
        }
    }
    
    @IBAction func chatVideoCallEndClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ChatVideoViewController: PlayReportBlackViewDelegate {
    func playReportBlackViewDelegateSuccess(rateLimitTag: Int) {
        if rateLimitTag == 311 {
            GameLoadingHUD.gameLoadingSuccess("Report submitted, will be reviewed within 24 hours", in: self.view)
        }
        else {
//            GameDataManager.shared.throttlingburst_appenduser_toblacklist_spikesimulation(post["replayranking_publisher_displayname_leaderboard"] ?? "", avatar: post["achievementmissionquest_publisher_avatarimage_battle", default: ""])
        }
    }
}
