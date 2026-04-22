
import UIKit

class SmiroViewController: UIViewController {

    @IBOutlet weak var online_collectionView: UICollectionView!
    @IBOutlet weak var video_collectionView: UICollectionView!
    @IBOutlet weak var follow_button: UIButton!
    @IBOutlet weak var popular_button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        follow_button.isSelected = true
        setupUIOnlineCollectionView()
        setupUIShortVideoCollectionView()
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
            return 5
        }
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == online_collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "online", for: indexPath) as! OnlineCollectionViewCell
            cell.backgroundColor = .clear
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "video", for: indexPath) as! VideoCollectionViewCell
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == online_collectionView {
            let onlineVC = OnlineViewController()
            onlineVC.modalPresentationStyle = .fullScreen
            present(onlineVC, animated: true, completion: nil)
        }
    }
}
