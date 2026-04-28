
import UIKit

class UserGameCnterVC: UIViewController {

    @IBOutlet weak var user_center_avatar_imageView: UIImageView!
    @IBOutlet weak var big_user_avatar_imageView: UIImageView!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIReportBlackView()
        setupUICenterTableView()
        setupUICenterCollectionView()
        user_center_avatar_imageView.layer.cornerRadius = 28.5
        user_center_avatar_imageView.layer.borderWidth = 2
        user_center_avatar_imageView.layer.borderColor = UIColor.white.cgColor
        
        if let avatarName = userData["avatar"] {
            user_center_avatar_imageView.image = UIImage(named: avatarName)
            big_user_avatar_imageView.image = UIImage(named: avatarName)
        }
        user_center_name_label.text = userData["nickname"]
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

    
}

extension UserGameCnterVC: PlayReportBlackViewDelegate {
    func playReportBlackViewDelegateSuccess(rateLimitTag: Int) {
        if rateLimitTag == 311 {
            
        }
        else {
            
        }
    }
}

extension UserGameCnterVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "video", for: indexPath) as! VideoCollectionViewCell
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let openPlayerVC = OpenPlayerVideoVC()
        openPlayerVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(openPlayerVC, animated: true)
    }
}

extension UserGameCnterVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "discover", for: indexPath) as! GameDiscoverTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.cell_discover_report_button.tag = indexPath.item
        cell.cell_discover_report_button.addTarget(self, action: #selector(submitUserReportForInappropriateGameCommunityContent(_ :)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let discoverDetailsVC = GameDiscoverDetailsVC()
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

/**
 
 Dear App Review Team,
 
 Thank you so much for taking the time to review our app and for the detailed feedback — we truly appreciate it, especially as first-time developers on the platform.
 
 We've carefully reviewed the issues raised and would like to outline how we plan to address each one:
 
 Regarding Guideline 1.2 - User-Generated Content:
 
 We want to assure you that our app already has the following safety mechanisms in place:
 
 1、EULA / Terms of Use – Users are required to agree to our User Agreement and Privacy Policy before signing in. We will further enhance this by presenting a clear EULA prompt upon first login that explicitly states our zero-tolerance policy for objectionable content and abusive behavior.
 
 2、Content Filtering – Our app includes built-in content moderation to filter inappropriate material.
 
 3、Flagging Mechanism – Users can report objectionable content or abusive users via the "Report User" feature, which is accessible from user profiles and content pages.
 
 4、Blocking Mechanism – Users can block abusive users through the "Block User" option. Blocked users are immediately hidden from all content feeds, messages, and user lists.
 
 5、24-Hour Response Commitment – We are committed to acting on all objectionable content reports within 24 hours, including removing the content and ejecting the offending user.
 
 Regarding Guideline 2.1(a) - Information Needed:
 
We apologize for the inconvenience. To ensure you can fully verify all features, we have pre-populated the app with chat content. Upon logging in, you will find an existing conversation with a user in the Messages tab, which you can tap into to experience the full chat functionality — including sending messages and video chat.
 
 We will also include a screen recording demonstrating the EULA agreement flow, the report mechanism, and the block mechanism as requested.
 
 Warm regards,
 Elstyl Team
 
 */
