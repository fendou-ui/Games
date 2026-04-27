
import UIKit

class MyWallteRechagreViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var my_wallte_balance_coins_label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIShortRechargeCollectionView()
    }
    
    func setupUIShortRechargeCollectionView() {
        let video_layout = UICollectionViewFlowLayout()
        video_layout.scrollDirection = .vertical
        video_layout.minimumInteritemSpacing = 12
        video_layout.minimumLineSpacing = 12
        video_layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 66.1)/3, height: 125)
        video_layout.sectionInset = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 21)
        
        collectionView.collectionViewLayout = video_layout
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "MyWallteRechagreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "waltte")
    }

    @IBAction func handleNavgationBackAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension MyWallteRechagreViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "waltte", for: indexPath) as! MyWallteRechagreCollectionViewCell
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 13
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let openPlayerVC = OpenPlayerVideoVC()
        openPlayerVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(openPlayerVC, animated: true)
    }
}

