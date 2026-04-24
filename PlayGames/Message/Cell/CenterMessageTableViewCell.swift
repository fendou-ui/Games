
import UIKit

class CenterMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var center_message_avatar_imageView: UIImageView!
    @IBOutlet weak var center_message_name_label: UILabel!
    @IBOutlet weak var center_message_content_label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        center_message_avatar_imageView.layer.cornerRadius = 25
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
