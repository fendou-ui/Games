
import UIKit

class CommentsCell: UITableViewCell {

    @IBOutlet weak var comment_user_avatar: UIImageView!
    @IBOutlet weak var comment_user_name_label: UILabel!
    @IBOutlet weak var comment_content_label: UILabel!
    @IBOutlet weak var comment_report_button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
