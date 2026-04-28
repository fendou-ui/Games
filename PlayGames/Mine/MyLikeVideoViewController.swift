
import UIKit

class MyLikeVideoViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var completely_empty_imageView: UIImageView!
    var likedVideoList: [[String: String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        likedVideoList = GameDataManager.shared.feedbackcuration_current_likedvideolist_discovery()
        setupUIShortVideoCollectionView()
        completely_empty_imageView.isHidden = !likedVideoList.isEmpty
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = likedVideoList[indexPath.item]
        let openPlayerVC = OpenPlayerVideoVC()
        openPlayerVC.shortVideoData = video
        openPlayerVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(openPlayerVC, animated: true)
    }
}
