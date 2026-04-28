
import UIKit
import AVFoundation

class OpenPlayerVideoVC: UIViewController {

    @IBOutlet weak var open_player_avatar_imageView: UIImageView!
    @IBOutlet weak var open_player_name_label: UILabel!
    @IBOutlet weak var open_player_follow_button: UIButton!
    @IBOutlet weak var open_player_content_label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var open_player_textFiled: UITextField!
    @IBOutlet weak var open_player_like_button: UIButton!
    
    var shortVideoData: [String: String] = [:]
    private var shortVideoPlayer: AVPlayer?
    private var shortVideoPlayerLayer: AVPlayerLayer?
    var report_black_view = PlayReportBlackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        open_player_avatar_imageView.layer.borderColor = UIColor.white.cgColor
        let nickname = shortVideoData["uploadercreator_video_publishernickname_channel"] ?? ""
        if GameDataManager.shared.handshakeresponse_isfriendrequest_sent_already(nickname) {
            open_player_follow_button.isEnabled = false
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "OnlineTableViewCell", bundle: nil), forCellReuseIdentifier: "online")
        
        if let avatarName = shortVideoData["profileiconbadge_video_publisheravatar_verification"] {
            open_player_avatar_imageView.image = UIImage(named: avatarName)
        }
        open_player_name_label.text = shortVideoData["uploadercreator_video_publishernickname_channel"]
        open_player_content_label.text = shortVideoData["captionsubtitle_video_description_overlay"]
        
        setupShortVideoPlayer()
        setupUIReportBlackView()
        
        let videoFilename = shortVideoData["streamplayback_video_filename_buffering"] ?? ""
        if GameDataManager.shared.interactionpulse_isvideo_liked_signal(videoFilename) {
            open_player_like_button.setBackgroundImage(UIImage(named: "open_play_mp4_like_yellow"), for: .normal)
        }
    }
    
    func setupUIReportBlackView() {
        report_black_view = UINib(nibName: "PlayReportBlackView", bundle: nil).instantiate(withOwner: self, options: nil).first as! PlayReportBlackView
        report_black_view.delegate = self
        view.addSubview(report_black_view)
        report_black_view.frame = CGRect(x: 0, y: 1200, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    private func setupShortVideoPlayer() {
        guard let filename = shortVideoData["streamplayback_video_filename_buffering"],
              let videoPath = Bundle.main.path(forResource: filename, ofType: "mp4") else { return }
        let videoURL = URL(fileURLWithPath: videoPath)
        shortVideoPlayer = AVPlayer(url: videoURL)
        
        let layer = AVPlayerLayer(player: shortVideoPlayer)
        layer.frame = view.bounds
        layer.videoGravity = .resizeAspectFill
        view.layer.insertSublayer(layer, at: 0)
        shortVideoPlayerLayer = layer
        
        NotificationCenter.default.addObserver(self, selector: #selector(shortVideoLoopReplay), name: .AVPlayerItemDidPlayToEndTime, object: shortVideoPlayer?.currentItem)
        shortVideoPlayer?.play()
    }
    
    @objc private func shortVideoLoopReplay() {
        shortVideoPlayer?.seek(to: .zero)
        shortVideoPlayer?.play()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shortVideoPlayerLayer?.frame = view.bounds
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func openPlayerVideoReturnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // 用户中心，关注，分享，举报
    @IBAction func requestUserFollowOrUnfollowTargetCommunityCreator(_ sender: UIButton) {
        if sender.tag == 511 {
            UIView.animate(withDuration: 0.31) {
                self.report_black_view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }
            return
        }
        if sender.tag == 512 {
            let videoName = shortVideoData["streamplayback_video_filename_buffering"] ?? ""
            guard let videoPath = Bundle.main.path(forResource: videoName, ofType: "mp4") else { return }
            let videoURL = URL(fileURLWithPath: videoPath)
            let activityVC = UIActivityViewController(activityItems: [videoURL], applicationActivities: nil)
            present(activityVC, animated: true)
            return
        }
        if sender.tag == 513 { // 添加好友
            let nickname = shortVideoData["uploadercreator_video_publishernickname_channel"] ?? ""
            let avatar = shortVideoData["profileiconbadge_video_publisheravatar_verification"] ?? ""
            if GameDataManager.shared.handshakeresponse_isfriendrequest_sent_already(nickname) {
                GameLoadingHUD.gameLoadingText("Friend request already sent", in: self.view)
            } else {
                GameDataManager.shared.socialoutreach_sendfriendrequest_connection(nickname, avatar: avatar, message: "Friend request sent, waiting for response")
                GameLoadingHUD.gameLoadingSuccess("Friend request sent, waiting for response", in: self.view)
            }
            return
        }
        if sender.tag == 514 { // 用户中心
            let userCenterVC = UserGameCnterVC()
            userCenterVC.userData = [
                "nickname": shortVideoData["uploadercreator_video_publishernickname_channel"] ?? "",
                "avatar": shortVideoData["profileiconbadge_video_publisheravatar_verification"] ?? ""
            ]
            navigationController?.pushViewController(userCenterVC, animated: true)
            return
        }
        
    }
    
    //发送、声音、点赞
    @IBAction func processUserLikeActionForGameCommunityPostItem(_ sender: UIButton) {
        if sender.tag == 311 {
            return
        }
        if sender.tag == 312 { // 关闭或开启声音
            sender.isSelected = !sender.isSelected
            shortVideoPlayer?.isMuted = sender.isSelected
            return
        }
        if sender.tag == 313 { // 点赞
            let videoFilename = shortVideoData["streamplayback_video_filename_buffering"] ?? ""
            if GameDataManager.shared.interactionpulse_isvideo_liked_signal(videoFilename) {
                GameDataManager.shared.engagementdrop_unlikevideo_fromlist_churn(videoFilename)
                sender.setBackgroundImage(UIImage(named: "open_play_mp4_like_white"), for: .normal)
            } else {
                GameDataManager.shared.engagementboost_likevideo_tolist_retention(shortVideoData)
                sender.setBackgroundImage(UIImage(named: "open_play_mp4_like_yellow"), for: .normal)
            }
            return
        }
    }
    
    
}

extension OpenPlayerVideoVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "online", for: indexPath) as! OnlineTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        return cell
    }
}

extension OpenPlayerVideoVC: PlayReportBlackViewDelegate {

    func playReportBlackViewDelegateSuccess(rateLimitTag: Int) {
        if rateLimitTag == 311 { // 举报
            GameLoadingHUD.gameLoadingSuccess("Report submitted, will be reviewed within 24 hours", in: self.view)
        }
        else { // 拉黑
            GameDataManager.shared.throttlingburst_appenduser_toblacklist_spikesimulation(shortVideoData["uploadercreator_video_publishernickname_channel"] ?? "", avatar: shortVideoData["voiceovermicrophone_host_avatarimage_headset"] ?? "")
            navigationController?.popViewController(animated: true)
        }
    }
}
