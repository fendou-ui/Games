
import UIKit

class VideoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var video_covert_imageView: UIImageView!
    @IBOutlet weak var report_video_button: UIButton!
    @IBOutlet weak var video_desc_label: UILabel!
    @IBOutlet weak var like_video_button: UIImageView!
    @IBOutlet weak var like_video_count_label: UILabel!
    @IBOutlet weak var comment_video_count_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 13
        layer.masksToBounds = true
    }

}
