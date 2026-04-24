
import UIKit

class ReauestFriendsListTableViewCell: UITableViewCell {

    @IBOutlet weak var friends_user_name_label: UILabel!
    @IBOutlet weak var friends_user_avatar_imageView: UIImageView!
    @IBOutlet weak var friends_user_message_button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        friends_user_avatar_imageView.layer.cornerRadius = 25
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
