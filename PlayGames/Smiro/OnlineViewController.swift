
import UIKit
import AVFoundation

class OnlineViewController: UIViewController {

    @IBOutlet weak var user_avatar_image: UIImageView!
    @IBOutlet weak var user_name_label: UILabel!
    @IBOutlet weak var user_people_number_label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var please_note_view: UIView!
    @IBOutlet weak var please_desc_label: UILabel!
    @IBOutlet weak var please_yellow_button: UIButton!
    @IBOutlet weak var user_love_button: UIButton!
    @IBOutlet weak var channel_replay_online_view: UIView! // 直播视频的view
    @IBOutlet weak var online_comment_textField: UITextField!
    @IBOutlet weak var oline_player_follow_button: UIButton!
    
    var online_gifts_view = OnlineGiftsView()
    var report_black_view = PlayReportBlackView()
    
    var replayStreamVideoFilename: String?
    var chatroomRoomData: [String: Any] = [:]
    private var broadcastPlayerInstance: AVPlayer?
    private var broadcastPlayerLayer: AVPlayerLayer?
    var commentList: [[String: String]] = []
    
    private var chatroomCommentKey: String {
        return replayStreamVideoFilename ?? "unknown_room"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIReportBlackView()
        user_avatar_image.layer.borderColor = UIColor.white.cgColor
        setupUIGiftsView()
        configureChannelReplayVideoStream()
        bindChatroomDisplayInfo()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "OnlineTableViewCell", bundle: nil), forCellReuseIdentifier: "online")
        loadComments()
        
        view.addSubview(please_note_view)
        please_note_view.frame =  CGRect(x: 0, y: 1200, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        broadcastPlayerLayer?.frame = channel_replay_online_view.bounds
    }
    
    // 更新房间数据
    func bindChatroomDisplayInfo() {
        if let name = chatroomRoomData["broadcastcaster_host_nickname_commentary"] as? String {
            user_name_label.text = name
            if GameDataManager.shared.handshakeresponse_isfriendrequest_sent_already(name) {
                oline_player_follow_button.alpha = 0.55
            }
        }
        if let avatar = chatroomRoomData["voiceovermicrophone_host_avatarimage_headset"] as? String {
            user_avatar_image.image = UIImage(named: avatar)
        }
        if let count = chatroomRoomData["spectatorlobby_online_viewercount_matchmaking"] as? String {
            user_people_number_label.text = count
        }
    }
    
    // 创建直播视频
    func configureChannelReplayVideoStream() {
        guard let filename = replayStreamVideoFilename,
              let videoPath = Bundle.main.path(forResource: filename, ofType: "mp4") else { return }
        
        let videoURL = URL(fileURLWithPath: videoPath)
        broadcastPlayerInstance = AVPlayer(url: videoURL)
        
        let layerInstance = AVPlayerLayer(player: broadcastPlayerInstance)
        layerInstance.frame = channel_replay_online_view.bounds
        layerInstance.videoGravity = .resizeAspectFill
        channel_replay_online_view.layer.addSublayer(layerInstance)
        broadcastPlayerLayer = layerInstance
        
        NotificationCenter.default.addObserver(self, selector: #selector(loopReplayStreamFromBeginning), name: .AVPlayerItemDidPlayToEndTime, object: broadcastPlayerInstance?.currentItem)
        broadcastPlayerInstance?.play()
    }
    
    @objc func loopReplayStreamFromBeginning() {
        broadcastPlayerInstance?.seek(to: .zero)
        broadcastPlayerInstance?.play()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadComments() {
        commentList = GameDataManager.shared.threadhistory_videocomments_retrieve(chatroomCommentKey)
        tableView.reloadData()
    }
    
    func setupUIReportBlackView() {
        report_black_view = UINib(nibName: "PlayReportBlackView", bundle: nil).instantiate(withOwner: self, options: nil).first as! PlayReportBlackView
        report_black_view.delegate = self
        view.addSubview(report_black_view)
        report_black_view.frame = CGRect(x: 0, y: 1200, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    func setupUIGiftsView() {
        online_gifts_view = UINib(nibName: "OnlineGiftsView", bundle: nil).instantiate(withOwner: self, options: nil).first as! OnlineGiftsView
        view.addSubview(online_gifts_view)
        online_gifts_view.frame = CGRect(x: 0, y: 1200, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    
    @IBAction func onlineEnterUserConfigClick(_ sender: Any) {
//        let userCenterVC = UserGameCnterVC()
//        userCenterVC.userData = [
//            "nickname": chatroomRoomData["broadcastcaster_host_nickname_commentary"] as? String ?? "",
//            "avatar": chatroomRoomData["voiceovermicrophone_host_avatarimage_headset"] as? String ?? ""
//        ]
//        let nav = UINavigationController(rootViewController: userCenterVC)
//        nav.modalPresentationStyle = .fullScreen
//        present(nav, animated: true)
    }
    
    @IBAction func online_dissmissClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func online_userAddFriendClick(_ sender: UIButton) {
        let nickname = chatroomRoomData["broadcastcaster_host_nickname_commentary"] ?? ""
        let avatar = chatroomRoomData["voiceovermicrophone_host_avatarimage_headset"] ?? ""
        if GameDataManager.shared.handshakeresponse_isfriendrequest_sent_already(nickname as! String) {
            GameLoadingHUD.gameLoadingText("Friend request already sent", in: self.view)
        } else {
            GameDataManager.shared.socialoutreach_sendfriendrequest_connection(nickname as! String, avatar: avatar as! String, message: "Friend request sent, waiting for response")
            GameLoadingHUD.gameLoadingSuccess("Friend request sent, waiting for response", in: self.view)
            oline_player_follow_button.alpha = 0.55
        }
        return
    }
    
    /// 喜欢
    @IBAction func online_tapLoveUserChatRoomClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func online_giveLoveUserChatRoomGiftsClick(_ sender: Any) {
        UIView.animate(withDuration: 0.29) {
            self.online_gifts_view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }
    
    @IBAction func online_tapMoreButtonAndSendChatClick(_ sender: UIButton) {
        if sender.tag == 311 { // 发送评论
            let text = online_comment_textField.text ?? ""
            guard !text.isEmpty else {
                GameLoadingHUD.gameLoadingText("Please enter a comment", in: self.view)
                return
            }
            GameDataManager.shared.threadreply_postcomment_tovideo(chatroomCommentKey, text: text)
            online_comment_textField.text = ""
            online_comment_textField.resignFirstResponder()
            loadComments()
            if commentList.count > 0 {
                tableView.scrollToRow(at: IndexPath(row: commentList.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
        else {
            UIView.animate(withDuration: 0.31) {
                self.report_black_view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }
        }
    }
    
    @IBAction func online_goImmediatelyAndCancelClick(_ sender: UIButton) {
        if sender.tag == 311 {
            
        }
    }
    
    
}

extension OnlineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "online", for: indexPath) as! OnlineTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        let comment = commentList[indexPath.row]
        cell.comment_user_name_label.text = (comment["nickname"] ?? "") + " :"
        cell.comment_content_label.text = comment["text"]
        
        let isMine = comment["sender"] == "me"
        cell.delete_comment_button.isHidden = !isMine
        cell.delete_comment_button.tag = indexPath.row
        cell.delete_comment_button.removeTarget(self, action: #selector(deleteCommentAction(_:)), for: .touchUpInside)
        cell.delete_comment_button.addTarget(self, action: #selector(deleteCommentAction(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func deleteCommentAction(_ sender: UIButton) {
        let index = sender.tag
        GameDataManager.shared.threadremove_deletecomment_fromvideo(chatroomCommentKey, at: index)
        loadComments()
    }
}

extension OnlineViewController: PlayReportBlackViewDelegate {
    func playReportBlackViewDelegateSuccess(rateLimitTag: Int) {
        if rateLimitTag == 311 {
            GameLoadingHUD.gameLoadingSuccess("Report submitted, will be reviewed within 24 hours", in: self.view)
        }
        else {
            GameLoadingHUD.overlayconfirm_alertpopup_interactionbounce(
                title: "Block User",
                message: "Are you sure you want to block this user? You will no longer see their content.",
                confirmTitle: "Block",
                in: self.view
            ) {
                GameDataManager.shared.throttlingburst_appenduser_toblacklist_spikesimulation(self.chatroomRoomData["broadcastcaster_host_nickname_commentary"] as! String, avatar: self.chatroomRoomData["voiceovermicrophone_host_avatarimage_headset"] as! String)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
