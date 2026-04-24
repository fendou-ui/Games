
import UIKit

class FriendsChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var friends_chat_name_label: UILabel!
    @IBOutlet weak var friends_chat_text: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func handleUserCenterNavReturnClick(_ sender: UIButton) {
        if sender.tag == 511 {
            navigationController?.popViewController(animated: true)
        }
        else {
            
        }
    }
    
    @IBAction func handleUserSubmitommentToGameChatContent(_ sender: UIButton) {
        if sender.tag == 511 {
            
        }
        else {
            
        }
    }
}
