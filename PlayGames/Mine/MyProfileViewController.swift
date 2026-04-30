
import UIKit
/**
 设置测试账号的信息
 账号：game123@gmail.com
 密码：123456
 */
class MyProfileViewController: UIViewController {

    @IBOutlet weak var big_ScrollView: UIScrollView!
    @IBOutlet weak var big_my_avatar_imageView: UIImageView!
    @IBOutlet weak var my_avatar_imageView: UIImageView!
    @IBOutlet weak var big_my_name_label: UILabel!
    @IBOutlet weak var big_my_followed_count_label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var user_center_videos_tap: UIButton!
    @IBOutlet weak var user_cans_count_label: UILabel!
    @IBOutlet weak var user_center_posts_tap: UIButton!
    @IBOutlet weak var my_coins_balance_label: UILabel!
    
    var myVideoList: [[String: String]] = []
    var myPostList: [[String: String]] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        let profile = GameDataManager.shared.dashboardsnapshot_load_userprofile()
        let nickname = profile["processhandler_profile_nickname_manager"] ?? ""
        big_my_name_label.text = nickname
        
        let followingCount = GameDataManager.shared.extensiblemaintainable_current_followingusernames_readable().count
        big_my_followed_count_label.text = "\(followingCount) Follows"
        
        let fansCount = GameDataManager.shared.viewership_current_fanslist_retrieve().count
        user_cans_count_label.text = "\(fansCount) Fans"
        
        let coins = profile["executor_wallet_coinsbalance_observerlistenerdelegate"] ?? "0"
        my_coins_balance_label.text = coins
        
        if let avatarName = profile["controllerserviceprovider_profile_avatarimage_adapter"], !avatarName.isEmpty {
            my_avatar_imageView.image = UIImage(named: avatarName)
            big_my_avatar_imageView.image = UIImage(named: avatarName)
        } else {
            my_avatar_imageView.image = UIImage(named: "skydrifter_portrait")
            big_my_avatar_imageView.image = UIImage(named: "skydrifter_portrait")
        }
        let avatarKey = "LocalAvatarData_\(GameDataManager.shared.currentAccountIdentifier)"
        if let savedData = UserDefaults.standard.data(forKey: avatarKey), let img = UIImage(data: savedData) {
            my_avatar_imageView.image = img
            big_my_avatar_imageView.image = img
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        big_ScrollView.contentInsetAdjustmentBehavior = .never
        my_avatar_imageView.layer.cornerRadius = 28.5
        my_avatar_imageView.layer.masksToBounds = true
        
        let profile = GameDataManager.shared.dashboardsnapshot_load_userprofile()
        let nickname = profile["processhandler_profile_nickname_manager"] ?? ""
        
        myVideoList = GameDataManager.shared.clipsegmentShortvideoFeedlistPlaybackloop().filter {
            $0["uploadercreator_video_publishernickname_channel"] == nickname
        }
        myPostList = GameDataManager.shared.streamoverlayDiscoverPostlistEngagement().filter {
            $0["replayranking_publisher_displayname_leaderboard"] == nickname
        }
        
        setupMyCollectionView()
        setupMyTableView()
    }
    
    func setupMyCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: 141, height: 197)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 21)
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "VideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "video")
    }
    
    func setupMyTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "GameDiscoverTableViewCell", bundle: nil), forCellReuseIdentifier: "discover")
        tableView.isHidden = true
    }

    @IBAction func handleUserSettingAction(_ sender: Any) {
        let setVC = MySettingViewController()
        setVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(setVC, animated: true)
    }
    
    @IBAction func profileOtherButtonAction(_ sender: UIButton) {
        if sender.tag == 511 {
            let profileVC = MyEditProfileViewController()
            profileVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(profileVC, animated: true)
        }
        else if sender.tag == 512 {
            let myWallte = MyWallteRechagreViewController()
            myWallte.modalPresentationStyle = .fullScreen
            present(myWallte, animated: true, completion: nil)
        }
        else if sender.tag == 515 {
            let fanslist = MyFollowingBlackListViewController()
            fanslist.otherTag = 2
            fanslist.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(fanslist, animated: true)
        }
        else if sender.tag == 516 {
            let followerlist = MyFollowingBlackListViewController()
            followerlist.otherTag = 3
            followerlist.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(followerlist, animated: true)
        }
        else if sender.tag == 513 {
            tableView.isHidden = true
            collectionView.isHidden = false
            user_center_posts_tap.setImage(UIImage(named: "user_center_posts"), for: .normal)
            user_center_videos_tap.setImage(UIImage(named: "user_center_videos_sel"), for: .normal)
        }
        else if sender.tag == 514 {
            tableView.isHidden = false
            collectionView.isHidden = true
            user_center_videos_tap.setImage(UIImage(named: "user_center_videos"), for: .normal)
            user_center_posts_tap.setImage(UIImage(named: "user_center_posts_sel"), for: .normal)
        }
    }
    
}

extension MyProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myVideoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "video", for: indexPath) as! VideoCollectionViewCell
        cell.backgroundColor = .clear
        let video = myVideoList[indexPath.item]
        cell.video_desc_label.text = video["captionsubtitle_video_description_overlay"]
        cell.like_video_count_label.text = video["engagementinteraction_video_likecount_reaction"]
        cell.comment_video_count_label.text = video["threadreply_video_commentcount_discussion"]
        if let coverName = video["thumbnailpreview_video_coverimage_snapshot"] {
            cell.video_covert_imageView.image = UIImage(named: coverName)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = myVideoList[indexPath.item]
        let openPlayerVC = OpenPlayerVideoVC()
        openPlayerVC.shortVideoData = video
        openPlayerVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(openPlayerVC, animated: true)
    }
}

extension MyProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPostList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "discover", for: indexPath) as! GameDiscoverTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        let post = myPostList[indexPath.row]
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
        cell.cell_discover_follow_button.isHidden = true
        cell.cell_discover_report_button.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = myPostList[indexPath.row]
        let discoverDetailsVC = GameDiscoverDetailsVC()
        discoverDetailsVC.postData = post
        discoverDetailsVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(discoverDetailsVC, animated: true)
    }
}
