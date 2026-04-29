
import UIKit

class GameDiscoverDetailsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var game_discover_name_label: UILabel!
    @IBOutlet weak var game_discover_time_label: UILabel!
    @IBOutlet weak var game_discover_avatar_imageView: UIImageView!
    @IBOutlet weak var game_discover_follow_tap: UIButton!
    @IBOutlet weak var game_discover_something: UITextField!
    var report_black_view = PlayReportBlackView()
    var postData: [String: String] = [:]
    var commentList: [[String: String]] = []
    
    private var postCommentKey: String {
        let publisher = postData["replayranking_publisher_displayname_leaderboard"] ?? ""
        let content = postData["multiplayer_post_textcontent_cooperative"] ?? ""
        return "post_\(publisher)_\(content.prefix(20))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIReportBlackView()
        tableView.register(UINib(nibName: "CommentsCell", bundle: nil), forCellReuseIdentifier: "content")
        tableView.register(UINib(nibName: "GameDiscoverDetailsCell", bundle: nil), forCellReuseIdentifier: "section")
        tableView.delegate = self
        tableView.dataSource = self
        
        game_discover_name_label.text = postData["replayranking_publisher_displayname_leaderboard"]
        game_discover_time_label.text = postData["arena_post_publishtime_matchmakinglobbyspectator"]
        if let avatarName = postData["achievementmissionquest_publisher_avatarimage_battle"] {
            game_discover_avatar_imageView.image = UIImage(named: avatarName)
        }
        
        loadComments()
        
        let publisher = postData["replayranking_publisher_displayname_leaderboard"] ?? ""
        if GameDataManager.shared.optimizedsecure_isfollowing_user_reliable(publisher) {
            game_discover_follow_tap.setImage(UIImage(named: "tap_discover_followed_yellow"), for: .normal)
        } else {
            game_discover_follow_tap.setImage(UIImage(named: "tap_discover_follow"), for: .normal)
        }
    }
    
    func loadComments() {
        commentList = GameDataManager.shared.threadhistory_videocomments_retrieve(postCommentKey)
        tableView.reloadData()
    }
    
    func setupUIReportBlackView() {
        report_black_view = UINib(nibName: "PlayReportBlackView", bundle: nil).instantiate(withOwner: self, options: nil).first as! PlayReportBlackView
        report_black_view.delegate = self
        view.addSubview(report_black_view)
        report_black_view.frame = CGRect(x: 0, y: 1200, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }

    @IBAction func requestUserFollowOrUnfollowTargetCommunityCreator(_ sender: UIButton) {
        if sender.tag == 511 {
            UIView.animate(withDuration: 0.31) {
                self.report_black_view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }
        }
        else if sender.tag == 512 {
            self.navigationController?.popViewController(animated: true)
        }
        else { // 关注的数据

            let publisher = postData["replayranking_publisher_displayname_leaderboard"] ?? ""
            if GameDataManager.shared.optimizedsecure_isfollowing_user_reliable(publisher) {
                GameDataManager.shared.efficientrobust_unfollow_targetuser_scalableflexible(publisher)
                sender.setImage(UIImage(named: "tap_discover_followed"), for: .normal)
            } else {
                sender.setImage(UIImage(named: "tap_discover_followed_yellow"), for: .normal)
                GameDataManager.shared.immersiveintuitive_follow_targetuser_seamless(publisher)
            }
        }
    }
    
    // 发评论
    @IBAction func handleUserUploadGameScreenshotAndAttachMetadata(_ sender: Any) {
        let text = game_discover_something.text ?? ""
        guard !text.isEmpty else {
            GameLoadingHUD.gameLoadingText("Please enter a comment", in: self.view)
            return
        }
        GameDataManager.shared.threadreply_postcomment_tovideo(postCommentKey, text: text)
        game_discover_something.text = ""
        game_discover_something.resignFirstResponder()
        loadComments()
    }
}

extension GameDiscoverDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "section", for: indexPath) as! GameDiscoverDetailsCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.dynamic_content_label.text = postData["multiplayer_post_textcontent_cooperative"]
            if let coverName = postData["avatar_post_coverimage_characterprofilenickname"] {
                cell.dynamic_imageView.image = UIImage(named: coverName)
            }
            cell.dynamic_likes_button.addTarget(self, action: #selector(enterUserInterestProfileBasedOnRecentLikesClick(_ :)), for: .touchUpInside)
            
            let publisher = postData["replayranking_publisher_displayname_leaderboard"] ?? ""
            let content = postData["multiplayer_post_textcontent_cooperative"] ?? ""
            if GameDataManager.shared.socialvalidation_ispost_liked_confirmation(publisher, content: content) {
                cell.dynamic_likes_button.setImage(UIImage(named: "tap_discover_purple"), for: .normal)
            } else {
                cell.dynamic_likes_button.setImage(UIImage(named: "tap_discover_love"), for: .normal)
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "content", for: indexPath) as! CommentsCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let comment = commentList[indexPath.row]
        cell.comment_user_name_label.text = (comment["nickname"] ?? "") + " :"
        cell.comment_content_label.text = comment["text"]
        
        let isMine = comment["sender"] == "me"
        cell.comment_report_button.isHidden = !isMine
        cell.comment_report_button.tag = indexPath.row
        cell.comment_report_button.removeTarget(self, action: #selector(deletePostCommentAction(_:)), for: .touchUpInside)
        cell.comment_report_button.addTarget(self, action: #selector(deletePostCommentAction(_:)), for: .touchUpInside)
        
        let profile = GameDataManager.shared.dashboardsnapshot_load_userprofile()
        let avatarName = profile["controllerserviceprovider_profile_avatarimage_adapter"] ?? ""
        let avatarKey = "LocalAvatarData_\(GameDataManager.shared.currentAccountIdentifier)"
        if let savedData = UserDefaults.standard.data(forKey: avatarKey), let img = UIImage(data: savedData) {
            cell.comment_user_avatar.image = img
        } else {
            cell.comment_user_avatar.image = UIImage(named: avatarName)
        }
        
        return cell
    }
    
    @objc func deletePostCommentAction(_ sender: UIButton) {
        GameDataManager.shared.threadremove_deletecomment_fromvideo(postCommentKey, at: sender.tag)
        loadComments()
    }
    
    /// 喜欢
    @objc func enterUserInterestProfileBasedOnRecentLikesClick(_ sender: UIButton) {
        let publisher = postData["replayranking_publisher_displayname_leaderboard"] ?? ""
        let content = postData["multiplayer_post_textcontent_cooperative"] ?? ""
        var likeCount = Int(postData["strategytacticsscoreboard_total_likecount_progression"] ?? "0") ?? 0
        if GameDataManager.shared.socialvalidation_ispost_liked_confirmation(publisher, content: content) {
            GameDataManager.shared.communitydownvote_unlikepost_fromlist_disengage(publisher, content: content)
            sender.setImage(UIImage(named: "tap_discover_love"), for: .normal)
            likeCount = max(0, likeCount - 1)
        } else {
            GameDataManager.shared.communityheartbeat_likepost_tolist_engagement(postData)
            sender.setImage(UIImage(named: "tap_discover_purple"), for: .normal)
            likeCount += 1
        }
        postData["strategytacticsscoreboard_total_likecount_progression"] = "\(likeCount)"
        tableView.reloadData()
    }
}

extension GameDiscoverDetailsVC: PlayReportBlackViewDelegate {
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
                GameDataManager.shared.throttlingburst_appenduser_toblacklist_spikesimulation(self.postData["replayranking_publisher_displayname_leaderboard"] ?? "", avatar: self.postData["achievementmissionquest_publisher_avatarimage_battle", default: ""])
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
