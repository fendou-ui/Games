
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
    
    var online_gifts_view = OnlineGiftsView()
    var report_black_view = PlayReportBlackView()
    
    var replayStreamVideoFilename: String?
    var chatroomRoomData: [String: Any] = [:]
    private var broadcastPlayerInstance: AVPlayer?
    private var broadcastPlayerLayer: AVPlayerLayer?
    
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

    @IBAction func online_dissmissClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func online_userAddFriendClick(_ sender: UIButton) {
        
    }
    
    @IBAction func online_tapLoveUserChatRoomClick(_ sender: Any) {
        
    }
    
    @IBAction func online_giveLoveUserChatRoomGiftsClick(_ sender: Any) {
        UIView.animate(withDuration: 0.29) {
            self.online_gifts_view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }
    
    @IBAction func online_tapMoreButtonAndSendChatClick(_ sender: UIButton) {
        if sender.tag == 311 { // 发送消息
            
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "online", for: indexPath) as! OnlineTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        return cell
    }
}

extension OnlineViewController: PlayReportBlackViewDelegate {
    func playReportBlackViewDelegateSuccess(rateLimitTag: Int) {
        if rateLimitTag == 311 {
            GameLoadingHUD.gameLoadingSuccess("Report submitted, will be reviewed within 24 hours", in: self.view)
        }
        else {
            GameDataManager.shared.throttlingburst_appenduser_toblacklist_spikesimulation(chatroomRoomData["broadcastcaster_host_nickname_commentary"] as! String, avatar: chatroomRoomData["voiceovermicrophone_host_avatarimage_headset"] as! String)
            dismiss(animated: true, completion: nil)
        }
    }
}
