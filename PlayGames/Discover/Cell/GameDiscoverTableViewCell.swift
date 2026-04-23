
import UIKit

class GameDiscoverTableViewCell: UITableViewCell {

    @IBOutlet weak var cell_discover_imageView: UIImageView!
    @IBOutlet weak var cell_discover_user_avatar: UIImageView!
    @IBOutlet weak var cell_discover_like_button: UIButton!
    @IBOutlet weak var cell_discover_follow_button: UIButton!
    @IBOutlet weak var cell_discover_like_label: UILabel!
    @IBOutlet weak var cell_discover_comment_label: UILabel!
    @IBOutlet weak var cell_discover_name_label: UILabel!
    @IBOutlet weak var cell_discover_time_label: UILabel!
    @IBOutlet weak var cell_discover_content_label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
