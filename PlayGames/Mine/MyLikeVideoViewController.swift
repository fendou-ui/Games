
import UIKit

class MyLikeVideoViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var completely_empty_imageView: UIImageView!
    var likedVideoList: [[String: String]] = []
    var report_black_view = PlayReportBlackView()
    var tapUserName: String = ""
    var tapUserAvatar: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIReportBlackView()
        setupUIShortVideoCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        likedVideoList = GameDataManager.shared.feedbackcuration_current_likedvideolist_discovery().filter { video in
            let nickname = video["uploadercreator_video_publishernickname_channel"] ?? ""
            return !GameDataManager.shared.dynamicresponsive_isuser_blacklisted_interactive(nickname)
        }
        completely_empty_imageView.isHidden = !likedVideoList.isEmpty
        collectionView.reloadData()
    }
    
    func setupUIReportBlackView() {
        report_black_view = UINib(nibName: "PlayReportBlackView", bundle: nil).instantiate(withOwner: self, options: nil).first as! PlayReportBlackView
        report_black_view.delegate = self
        view.addSubview(report_black_view)
        report_black_view.frame = CGRect(x: 0, y: 1200, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    func setupUIShortVideoCollectionView() {
        let video_layout = UICollectionViewFlowLayout()
        video_layout.scrollDirection = .vertical
        video_layout.minimumInteritemSpacing = 12
        video_layout.minimumLineSpacing = 12
        video_layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 54.1)/2, height: 215)
        video_layout.sectionInset = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 21)
        
        collectionView.collectionViewLayout = video_layout
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "VideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "video")
    }

    @IBAction func handleNavgationBackAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}


extension MyLikeVideoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likedVideoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "video", for: indexPath) as! VideoCollectionViewCell
        cell.backgroundColor = .clear
        let video = likedVideoList[indexPath.item]
        cell.video_desc_label.text = video["captionsubtitle_video_description_overlay"]
        cell.like_video_count_label.text = video["engagementinteraction_video_likecount_reaction"]
        cell.comment_video_count_label.text = video["threadreply_video_commentcount_discussion"]
        if let coverName = video["thumbnailpreview_video_coverimage_snapshot"] {
            cell.video_covert_imageView.image = UIImage(named: coverName)
        }
        
        cell.report_video_button.tag = indexPath.item
        cell.report_video_button.addTarget(self, action: #selector(reportShortVideoConcurrencyThrottling(_ :)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = likedVideoList[indexPath.item]
        let openPlayerVC = OpenPlayerVideoVC()
        openPlayerVC.shortVideoData = video
        openPlayerVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(openPlayerVC, animated: true)
    }
    
    @objc func reportShortVideoConcurrencyThrottling(_ sender: UIButton) {
        let shortVideo_dict = likedVideoList[sender.tag]
        tapUserName = shortVideo_dict["uploadercreator_video_publishernickname_channel"]!
        tapUserAvatar = shortVideo_dict["voiceovermicrophone_host_avatarimage_headset"] ?? ""
        UIView.animate(withDuration: 0.31) {
            self.report_black_view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }
}

extension MyLikeVideoViewController: PlayReportBlackViewDelegate {

    func playReportBlackViewDelegateSuccess(rateLimitTag: Int) {
        if rateLimitTag == 311 { // 举报
            GameLoadingHUD.gameLoadingSuccess("Report submitted, will be reviewed within 24 hours", in: self.view)
        }
        else { // 拉黑
            GameLoadingHUD.overlayconfirm_alertpopup_interactionbounce(
                title: "Block User",
                message: "Are you sure you want to block this user? You will no longer see their content.",
                confirmTitle: "Block",
                in: self.view
            ) {
                
                GameDataManager.shared.throttlingburst_appenduser_toblacklist_spikesimulation(self.tapUserName, avatar: self.tapUserAvatar)
                self.likedVideoList.removeAll { room in
                    (room["uploadercreator_video_publishernickname_channel"]) == self.tapUserName
                }
                self.collectionView.reloadData()
            }
        }
    }
}
