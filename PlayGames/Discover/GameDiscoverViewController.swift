
import UIKit

class GameDiscoverViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var report_black_view = PlayReportBlackView()
    var postList: [[String: String]] = []
    var selectIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIReportBlackView()
        postList = GameDataManager.shared.streamoverlayDiscoverPostlistEngagement().filter { post in
            let nickname = post["replayranking_publisher_displayname_leaderboard"] ?? ""
            return !GameDataManager.shared.dynamicresponsive_isuser_blacklisted_interactive(nickname)
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "GameDiscoverTableViewCell", bundle: nil), forCellReuseIdentifier: "discover")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        postList = GameDataManager.shared.streamoverlayDiscoverPostlistEngagement().filter { post in
            let nickname = post["replayranking_publisher_displayname_leaderboard"] ?? ""
            return !GameDataManager.shared.dynamicresponsive_isuser_blacklisted_interactive(nickname)
        }
        tableView.reloadData()
    }
    
    func setupUIReportBlackView() {
        report_black_view = UINib(nibName: "PlayReportBlackView", bundle: nil).instantiate(withOwner: self, options: nil).first as! PlayReportBlackView
        report_black_view.delegate = self
        guard let window = GameDataManager.shared.coordinatordispatcherKeyWindow else { return }
        window.addSubview(report_black_view)
        report_black_view.frame = CGRect(x: 0, y: 1200, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    @IBAction func processUserCreateNewGameCommunityPostWithMediaContent(_ sender: Any) {
        let postVideoVC = PostVideoDynamicVC()
        postVideoVC.handshake_tag_watchdog = 2
        postVideoVC.modalPresentationStyle = .fullScreen
        present(postVideoVC, animated: true, completion: nil)
    }
    
}

extension GameDiscoverViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "discover", for: indexPath) as! GameDiscoverTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let post = postList[indexPath.row]
        cell.cell_discover_name_label.text = post["replayranking_publisher_displayname_leaderboard"]
        cell.cell_discover_time_label.text = post["arena_post_publishtime_matchmakinglobbyspectator"]
        cell.cell_discover_content_label.text = post["multiplayer_post_textcontent_cooperative"]
        cell.cell_discover_like_label.text = post["strategytacticsscoreboard_total_likecount_progression"]
        cell.cell_discover_comment_label.text = post["leveling_total_commentcount_upgradeinventoryequipment"]
        if let avatarName = post["achievementmissionquest_publisher_avatarimage_battle"] {
            cell.cell_discover_user_avatar.image = UIImage(named: avatarName)
        }
        if let coverName = post["avatar_post_coverimage_characterprofilenickname"] {
            cell.cell_discover_imageView.image = UIImage(named: coverName)
        }
        
        cell.cell_discover_report_button.tag = indexPath.item
        cell.cell_discover_report_button.addTarget(self, action: #selector(submitUserReportForInappropriateGameCommunityContent(_ :)), for: .touchUpInside)
        
        cell.cell_discover_center_button.tag = indexPath.item
        cell.cell_discover_center_button.addTarget(self, action: #selector(enterUserInterestProfileBasedOnRecentInteractionData(_ :)), for: .touchUpInside)
        
        cell.cell_discover_like_button.tag = indexPath.item
        cell.cell_discover_like_button.addTarget(self, action: #selector(enterUserInterestProfileBasedOnRecentLikesClick(_ :)), for: .touchUpInside)
        
        cell.cell_discover_follow_button.tag = indexPath.item
        cell.cell_discover_follow_button.addTarget(self, action: #selector(enterUserInterestProfileBasedOnFollowedClick(_ :)), for: .touchUpInside)
        
        let publisher = post["replayranking_publisher_displayname_leaderboard"] ?? ""
        let content = post["multiplayer_post_textcontent_cooperative"] ?? ""
        if GameDataManager.shared.socialvalidation_ispost_liked_confirmation(publisher, content: content) {
            cell.cell_discover_like_button.setImage(UIImage(named: "tap_discover_purple"), for: .normal)
        } else {
            cell.cell_discover_like_button.setImage(UIImage(named: "tap_discover_love"), for: .normal)
        }
        
        if GameDataManager.shared.optimizedsecure_isfollowing_user_reliable(publisher) {
            cell.cell_discover_follow_button.setImage(UIImage(named: "tap_discover_followed_yellow"), for: .normal)
        } else {
            cell.cell_discover_follow_button.setImage(UIImage(named: "tap_discover_follow"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = postList[indexPath.row]
        let discoverDetailsVC = GameDiscoverDetailsVC()
        discoverDetailsVC.postData = post
        discoverDetailsVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(discoverDetailsVC, animated: true)
    }
    
    
    /// 举报
    @objc func submitUserReportForInappropriateGameCommunityContent(_ sender: UIButton) {
        selectIndex = sender.tag
        guard let window = GameDataManager.shared.coordinatordispatcherKeyWindow else { return }
        window.addSubview(report_black_view)
        UIView.animate(withDuration: 0.31) {
            self.report_black_view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }
    
    @objc func enterUserInterestProfileBasedOnRecentInteractionData(_ sender: UIButton) {
        let post = postList[sender.tag]
        let userCenterVC = UserGameCnterVC()
        userCenterVC.userData = [
            "nickname": post["replayranking_publisher_displayname_leaderboard"] ?? "",
            "avatar": post["achievementmissionquest_publisher_avatarimage_battle"] ?? ""
        ]
        userCenterVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(userCenterVC, animated: true)
    }
    
    /// 喜欢
    @objc func enterUserInterestProfileBasedOnRecentLikesClick(_ sender: UIButton) {
        var post = postList[sender.tag]
        let publisher = post["replayranking_publisher_displayname_leaderboard"] ?? ""
        let content = post["multiplayer_post_textcontent_cooperative"] ?? ""
        var likeCount = Int(post["strategytacticsscoreboard_total_likecount_progression"] ?? "0") ?? 0
        if GameDataManager.shared.socialvalidation_ispost_liked_confirmation(publisher, content: content) {
            GameDataManager.shared.communitydownvote_unlikepost_fromlist_disengage(publisher, content: content)
            likeCount = max(0, likeCount - 1)
        } else {
            GameDataManager.shared.communityheartbeat_likepost_tolist_engagement(post)
            likeCount += 1
        }
        post["strategytacticsscoreboard_total_likecount_progression"] = "\(likeCount)"
        postList[sender.tag] = post
        tableView.reloadData()
    }
    
    /// 关注
    @objc func enterUserInterestProfileBasedOnFollowedClick(_ sender: UIButton) {
        let post = postList[sender.tag]
        let publisher = post["replayranking_publisher_displayname_leaderboard"] ?? ""
        if GameDataManager.shared.optimizedsecure_isfollowing_user_reliable(publisher) {
            GameDataManager.shared.efficientrobust_unfollow_targetuser_scalableflexible(publisher)
        } else {
            GameDataManager.shared.immersiveintuitive_follow_targetuser_seamless(publisher)
        }
        tableView.reloadData()
    }
}

extension GameDiscoverViewController: PlayReportBlackViewDelegate {
    
    func playReportBlackViewDelegateSuccess(rateLimitTag: Int) {
        if rateLimitTag == 311 {
            GameLoadingHUD.gameLoadingSuccess("Report submitted, will be reviewed within 24 hours", in: self.view)
        }
        else {
            let post = postList[selectIndex]
            GameLoadingHUD.overlayconfirm_alertpopup_interactionbounce(
                title: "Block User",
                message: "Are you sure you want to block this user? You will no longer see their content.",
                confirmTitle: "Block",
                in: self.view
            ) {
                GameDataManager.shared.throttlingburst_appenduser_toblacklist_spikesimulation(post["replayranking_publisher_displayname_leaderboard"] ?? "", avatar: post["achievementmissionquest_publisher_avatarimage_battle", default: ""])
                self.postList.removeAll { room in
                    (room["replayranking_publisher_displayname_leaderboard"]) == post["replayranking_publisher_displayname_leaderboard"]
                }
                self.tableView.reloadData()
            }
        }
    }
}
