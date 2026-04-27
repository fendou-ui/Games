
import UIKit

class MyWallteRechagreCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var rechagre_coins_number_label: UILabel!
    @IBOutlet weak var recharge_coins_price_label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        recharge_coins_price_label.layer.cornerRadius = 13
        recharge_coins_price_label.layer.masksToBounds = true
    }

}
