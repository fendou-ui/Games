
import UIKit

class MyFollowingBlackListTableViewCell: UITableViewCell {

    @IBOutlet weak var follow_black_user_avatar: UIImageView!
    @IBOutlet weak var follow_black_user_name_label: UILabel!
    @IBOutlet weak var follow_black_user_button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
