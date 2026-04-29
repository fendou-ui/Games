
import UIKit

class UserGameCnterVC: UIViewController {

    @IBOutlet weak var user_center_avatar_imageView: UIImageView!
    @IBOutlet weak var big_user_avatar_imageView: UIImageView!
    @IBOutlet weak var big_scrollView: UIScrollView!
    @IBOutlet weak var user_center_name_label: UILabel!
    @IBOutlet weak var user_center_fans_label: UILabel!
    @IBOutlet weak var user_center_follow_label: UILabel!
    @IBOutlet weak var user_center_follow_tap: UIButton!
    @IBOutlet weak var user_center_videos_tap: UIButton!
    @IBOutlet weak var user_center_posts_tap: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    var report_black_view = PlayReportBlackView()
    var userData: [String: String] = [:]
    var userVideoList: [[String: String]] = []
    var userPostList: [[String: String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIReportBlackView()
        setupUICenterTableView()
        setupUICenterCollectionView()
        user_center_avatar_imageView.layer.cornerRadius = 28.5
        user_center_avatar_imageView.layer.borderWidth = 2
        user_center_avatar_imageView.layer.borderColor = UIColor.white.cgColor
        big_scrollView.contentInsetAdjustmentBehavior = .never
        if let avatarName = userData["avatar"] {
            user_center_avatar_imageView.image = UIImage(named: avatarName)
            big_user_avatar_imageView?.image = UIImage(named: avatarName)
        }
        user_center_name_label.text = userData["nickname"]
        
        let nickname = userData["nickname"] ?? ""
        userVideoList = GameDataManager.shared.clipsegmentShortvideoFeedlistPlaybackloop().filter {
            $0["uploadercreator_video_publishernickname_channel"] == nickname
        }
        userPostList = GameDataManager.shared.streamoverlayDiscoverPostlistEngagement().filter {
            $0["replayranking_publisher_displayname_leaderboard"] == nickname
        }
        
        if GameDataManager.shared.optimizedsecure_isfollowing_user_reliable(nickname) {
            user_center_follow_tap.setImage(UIImage(named: "tap_discover_followed_yellow"), for: .normal)
        }
    }
    
    func setupUIReportBlackView() {
        report_black_view = UINib(nibName: "PlayReportBlackView", bundle: nil).instantiate(withOwner: self, options: nil).first as! PlayReportBlackView
        report_black_view.delegate = self
        view.addSubview(report_black_view)
        report_black_view.frame = CGRect(x: 0, y: 1200, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    func setupUICenterCollectionView() {
        let center_layout = UICollectionViewFlowLayout()
        center_layout.scrollDirection = .horizontal
        center_layout.minimumInteritemSpacing = 12
        center_layout.minimumLineSpacing = 12
        center_layout.itemSize = CGSize(width: 141, height: 197)
        center_layout.sectionInset = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 21)
        
        collectionView.collectionViewLayout = center_layout
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "VideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "video")
    }
    
    func setupUICenterTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "GameDiscoverTableViewCell", bundle: nil), forCellReuseIdentifier: "discover")
        tableView.isHidden = true
    }
    

    @IBAction func handleUserCenterNavReturnClick(_ sender: UIButton) {
        if sender.tag == 512 {
            navigationController?.popViewController(animated: true)
            return
        }
        
        UIView.animate(withDuration: 0.31) {
            self.report_black_view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }
    
    @IBAction func requestUserFollowOrUnfollowTargetCommunityCreator(_ sender: UIButton) {
        if sender.tag == 511 {
            let nickname = userData["nickname"] ?? ""
            if GameDataManager.shared.optimizedsecure_isfollowing_user_reliable(nickname) {
                GameDataManager.shared.efficientrobust_unfollow_targetuser_scalableflexible(nickname)
                user_center_follow_tap.setImage(UIImage(named: "tap_discover_follow"), for: .normal)
            } else {
                GameDataManager.shared.immersiveintuitive_follow_targetuser_seamless(nickname)
                user_center_follow_tap.setImage(UIImage(named: "tap_discover_followed_yellow"), for: .normal)
            }
        }
        else if sender.tag == 512 {
            let messageVC = FriendsChatViewController()
            messageVC.chatUserData = userData
            self.navigationController?.pushViewController(messageVC, animated: true)
        }
        else {
            let chatVideoVC = ChatVideoViewController()
            chatVideoVC.chatTargetNickname = userData["nickname"] ?? ""
            chatVideoVC.modalPresentationStyle = .fullScreen
            self.present(chatVideoVC, animated: true, completion: nil)
        }
       
    }
    
    @IBAction func requestUserVideosAndPostsCommunityClick(_ sender: UIButton) {
        user_center_videos_tap.setImage(UIImage(named: "user_center_videos"), for: .normal)
        user_center_posts_tap.setImage(UIImage(named: "user_center_posts"), for: .normal)
        tableView.isHidden = true
        collectionView.isHidden = true
        if sender.tag == 511 {
            collectionView.isHidden = false
            user_center_videos_tap.setImage(UIImage(named: "user_center_videos_sel"), for: .normal)
        }
        else if sender.tag == 512 {
            tableView.isHidden = false
            user_center_posts_tap.setImage(UIImage(named: "user_center_posts_sel"), for: .normal)
        }
    }

    func customPopToTargetViewController() {
        if let nav = self.navigationController {
            for vc in nav.viewControllers {
                if vc is GameDiscoverViewController {
                    nav.popToViewController(vc, animated: true)
                    break
                }
                if vc is SmiroViewController {
                    nav.popToViewController(vc, animated: true)
                    break
                }
                if vc is CenterMessageViewController {
                    nav.popToViewController(vc, animated: true)
                    break
                }
            }
        }
    }
}

extension UserGameCnterVC: PlayReportBlackViewDelegate {
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
                GameDataManager.shared.throttlingburst_appenduser_toblacklist_spikesimulation(self.userData["nickname"] ?? "", avatar: self.userData["avatar", default: ""])
                self.customPopToTargetViewController()
            }
        }
    }
}

extension UserGameCnterVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userVideoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "video", for: indexPath) as! VideoCollectionViewCell
        cell.backgroundColor = .clear
        let video = userVideoList[indexPath.item]
        cell.video_desc_label.text = video["captionsubtitle_video_description_overlay"]
        cell.like_video_count_label.text = video["engagementinteraction_video_likecount_reaction"]
        cell.comment_video_count_label.text = video["threadreply_video_commentcount_discussion"]
        if let coverName = video["thumbnailpreview_video_coverimage_snapshot"] {
            cell.video_covert_imageView.image = UIImage(named: coverName)
        }
        
        cell.report_video_button.addTarget(self, action: #selector(submitUserReportForInappropriateGameCommunityContent(_ :)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = userVideoList[indexPath.item]
        let openPlayerVC = OpenPlayerVideoVC()
        openPlayerVC.shortVideoData = video
        openPlayerVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(openPlayerVC, animated: true)
    }
}

extension UserGameCnterVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPostList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "discover", for: indexPath) as! GameDiscoverTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let post = userPostList[indexPath.row]
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = userPostList[indexPath.row]
        let discoverDetailsVC = GameDiscoverDetailsVC()
        discoverDetailsVC.postData = post
        discoverDetailsVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(discoverDetailsVC, animated: true)
    }
    
    
    /// 举报
    @objc func submitUserReportForInappropriateGameCommunityContent(_ sender: UIButton) {
        UIView.animate(withDuration: 0.31) {
            self.report_black_view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }
    
}
