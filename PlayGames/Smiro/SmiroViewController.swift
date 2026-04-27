
import UIKit

class SmiroViewController: UIViewController {

    @IBOutlet weak var online_collectionView: UICollectionView!
    @IBOutlet weak var video_collectionView: UICollectionView!
    @IBOutlet weak var follow_button: UIButton!
    @IBOutlet weak var popular_button: UIButton!
    
    var chatroomList: [[String: Any]] = []
    var report_black_view = PlayReportBlackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        follow_button.isSelected = true
        chatroomList = GameDataManager.shared.seriescontentOnlineChatroomlistCreatorinfluencer()
        setupUIOnlineCollectionView()
        setupUIShortVideoCollectionView()
        setupUIReportBlackView()
    }
    
    func setupUIReportBlackView() {
        report_black_view = UINib(nibName: "PlayReportBlackView", bundle: nil).instantiate(withOwner: self, options: nil).first as! PlayReportBlackView
        report_black_view.delegate = self
        guard let window = GameDataManager.shared.coordinatordispatcherKeyWindow else { return }
        window.addSubview(report_black_view)
        report_black_view.frame = CGRect(x: 0, y: 1200, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func titleSelectFollowAndPopularClick(_ sender: UIButton) {
        follow_button.isSelected = false
        popular_button.isSelected = false
        if sender.tag == 311 {
            follow_button.isSelected = true
        }
        else {
            popular_button.isSelected = true
        }
    }
    
    @IBAction func sendVideoClick(_ sender: Any) {
        let postVideoVC = PostVideoDynamicVC()
        postVideoVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(postVideoVC, animated: true)
    }
    
    func setupUIOnlineCollectionView() {
        let online_layout = UICollectionViewFlowLayout()
        online_layout.scrollDirection = .horizontal
        online_layout.minimumInteritemSpacing = 12
        online_layout.minimumLineSpacing = 12
        online_layout.itemSize = CGSize(width: 141, height: 197)
        online_layout.sectionInset = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 21)
        
        online_collectionView.collectionViewLayout = online_layout
        online_collectionView.backgroundColor = .clear
        online_collectionView.dataSource = self
        online_collectionView.delegate = self
        online_collectionView.register(UINib(nibName: "OnlineCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "online")
    }
    
    func setupUIShortVideoCollectionView() {
        let video_layout = UICollectionViewFlowLayout()
        video_layout.scrollDirection = .vertical
        video_layout.minimumInteritemSpacing = 12
        video_layout.minimumLineSpacing = 12
        video_layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 54.1)/2, height: 215)
        video_layout.sectionInset = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 21)
        
        video_collectionView.collectionViewLayout = video_layout
        video_collectionView.backgroundColor = .clear
        video_collectionView.dataSource = self
        video_collectionView.delegate = self
        video_collectionView.register(UINib(nibName: "VideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "video")
    }
    
}

extension SmiroViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == online_collectionView {
            return chatroomList.count
        }
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == online_collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "online", for: indexPath) as! OnlineCollectionViewCell
            cell.backgroundColor = .clear
            let room = chatroomList[indexPath.item]
            cell.online_title_label.text = room["hostguest_chatroom_displaytitle_collaboration"] as? String
            cell.online_room_count_label.text = "\(room["spectatorlobby_online_viewercount_matchmaking"] as? String ?? "6") Online"
            if let bgName = room["promotionbrandingsponsorship_chatroom_backgroundcover_advertisement"] as? String {
                cell.online_bg_image.image = UIImage(named: bgName)
            }
            if let avatars = room["acquisitionoptimization_chatroom_memberavatars_experiment"] as? [String] {
                let imageViews = [cell.online_avatar_imageView1, cell.online_avatar_imageView2, cell.online_avatar_imageView3, cell.online_avatar_imageView4, cell.online_avatar_imageView5]
                for (i, iv) in imageViews.enumerated() {
                    if i < avatars.count {
                        iv?.image = UIImage(named: avatars[i])
                    }
                }
            }
            
            cell.report_button.tag = indexPath.item
            cell.report_button.addTarget(self, action: #selector(reportQueueConcurrencyThrottling(_ :)), for: .touchUpInside)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "video", for: indexPath) as! VideoCollectionViewCell
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == online_collectionView {
            let room = chatroomList[indexPath.item]
            let onlineVC = OnlineViewController(nibName: "OnlineViewController", bundle: nil)
            onlineVC.replayStreamVideoFilename = room["monetization_chatroom_videofile_conversionretention"] as? String
            onlineVC.chatroomRoomData = room
            onlineVC.modalPresentationStyle = .fullScreen
            present(onlineVC, animated: true, completion: nil)
        }else {
            let openPlayerVC = OpenPlayerVideoVC()
            openPlayerVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(openPlayerVC, animated: true)
        }
        
    }
    
    @objc func reportQueueConcurrencyThrottling(_ sender: UIButton) {
        guard let window = GameDataManager.shared.coordinatordispatcherKeyWindow else { return }
        window.addSubview(report_black_view)
        report_black_view.frame = CGRect(x: 0, y: 1200, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        UIView.animate(withDuration: 0.31) {
            self.report_black_view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }
    
}

extension SmiroViewController: PlayReportBlackViewDelegate {

    func playReportBlackViewDelegateSuccess(rateLimitTag: Int) {
        if rateLimitTag == 311 { // 举报
            GameDataManager.shared.throttlingburst_appenduser_toblacklist_spikesimulation("GamerKing")
        }
        else {
            
        }
    }
}
