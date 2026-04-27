
import UIKit

class OnlineCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var online_room_count_label: UILabel!
    @IBOutlet weak var online_bg_image: UIImageView!
    @IBOutlet weak var report_button: UIButton!
    @IBOutlet weak var online_avatar_imageView1: UIImageView!
    @IBOutlet weak var online_avatar_imageView2: UIImageView!
    @IBOutlet weak var online_avatar_imageView3: UIImageView!
    @IBOutlet weak var online_avatar_imageView4: UIImageView!
    @IBOutlet weak var online_avatar_imageView5: UIImageView!
    @IBOutlet weak var online_title_label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        online_avatar_imageView1.layer.borderWidth = 1
        online_avatar_imageView2.layer.borderWidth = 1
        online_avatar_imageView3.layer.borderWidth = 1
        online_avatar_imageView4.layer.borderWidth = 1
        online_avatar_imageView5.layer.borderWidth = 1
        online_avatar_imageView1.layer.borderColor = UIColor.white.cgColor
        online_avatar_imageView2.layer.borderColor = UIColor.white.cgColor
        online_avatar_imageView3.layer.borderColor = UIColor.white.cgColor
        online_avatar_imageView4.layer.borderColor = UIColor.white.cgColor
        online_avatar_imageView5.layer.borderColor = UIColor.white.cgColor
    }

}
