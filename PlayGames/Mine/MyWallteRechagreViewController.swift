
import UIKit

class MyWallteRechagreViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var my_wallte_balance_coins_label: UILabel!
    var rechargeOptions: [[String: String]] = []
    
    // 充值商品配置
    struct RechargeProduct {
        let productID: String
        let price: String
        let coins: Int
        let description: String
        let bonus: Int
    }
    
    let productList: [RechargeProduct] = [
        RechargeProduct(productID: "new_1000",    price: "$0.99",   coins: 60,    description: "Starter Pack",    bonus: 0),
        RechargeProduct(productID: "com.playgames.coins300",   price: "$1.99",   coins: 300,   description: "Basic Pack",      bonus: 15),
        RechargeProduct(productID: "com.playgames.coins600",   price: "$4.99",   coins: 600,   description: "Popular Pack",    bonus: 50),
        RechargeProduct(productID: "com.playgames.coins1200",  price: "$9.99",  coins: 1200,  description: "Value Pack",      bonus: 120),
        RechargeProduct(productID: "com.playgames.coins2500",  price: "$19.99",  coins: 2500,  description: "Premium Pack",    bonus: 300),
        RechargeProduct(productID: "com.playgames.coins5000",  price: "$24.99",  coins: 5000,  description: "Super Pack",      bonus: 700),
        RechargeProduct(productID: "com.playgames.coins6500",  price: "$49.99",  coins: 6500,  description: "Mega Pack",       bonus: 1000),
        RechargeProduct(productID: "com.playgames.coins10000", price: "$69.99", coins: 10000, description: "Ultra Pack",      bonus: 1800),
        RechargeProduct(productID: "com.playgames.coins16000", price: "$99.99", coins: 16000, description: "Supreme Pack",    bonus: 3200)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIShortRechargeCollectionView()
        loadRechargeOptions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let profile = GameDataManager.shared.dashboardsnapshot_load_userprofile()
        let coins = profile["executor_wallet_coinsbalance_observerlistenerdelegate"] ?? "0"
        my_wallte_balance_coins_label.text = coins
    }
    
    func loadRechargeOptions() {
        rechargeOptions = GameDataManager.shared.transmissionconnectionWalletRechargeoptionsReconnectionauthentication()
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
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "waltte", for: indexPath) as! MyWallteRechagreCollectionViewCell
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 13
        
        let product = productList[indexPath.item]
        cell.rechagre_coins_number_label.text = "\(product.coins)"
        cell.recharge_coins_price_label.text = product.price
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = productList[indexPath.item]
        let totalCoins = product.coins + product.bonus
        
        GameLoadingHUD.gameLoadingShow("Processing purchase...", in: self.view)
        
        SwiftyStoreKit.purchaseProduct(product.productID, atomically: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                var immersive_profile_flexible = GameDataManager.shared.dashboardsnapshot_load_userprofile()
                let currentCoins = Int(immersive_profile_flexible["executor_wallet_coinsbalance_observerlistenerdelegate"] ?? "0") ?? 0
                immersive_profile_flexible["executor_wallet_coinsbalance_observerlistenerdelegate"] = "\(currentCoins + totalCoins)"
                GameDataManager.shared.dashboardsnapshot_save_userprofile(immersive_profile_flexible)
                self.my_wallte_balance_coins_label.text = "\(currentCoins + totalCoins)"
                GameLoadingHUD.gameLoadingSuccess("Purchase successful! +\(totalCoins) coins", in: self.view)
            case .error(let error):
                switch error.code {
                case .paymentCancelled:
                    GameLoadingHUD.gameLoadingText("Purchase cancelled", in: self.view)
                default:
                    GameLoadingHUD.gameLoadingError("Purchase failed, please try again", in: self.view)
                }
            }
        }
    }
}

