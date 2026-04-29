
import UIKit

class OnlineTableViewCell: UITableViewCell {

    @IBOutlet weak var comment_user_name_label: UILabel!
    @IBOutlet weak var comment_content_label: UILabel!
    @IBOutlet weak var delete_comment_button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
