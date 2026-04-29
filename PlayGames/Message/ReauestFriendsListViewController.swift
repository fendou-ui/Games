
import UIKit

class ReauestFriendsListViewController: UIViewController {

    @IBOutlet weak var friend_list_title: UILabel!
    @IBOutlet weak var completely_empty_imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var friendRequestList: [[String: String]] = []
    var friendTag: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ReauestFriendsListTableViewCell", bundle: nil), forCellReuseIdentifier: "friendlist")
        
        if friendTag == 1 {
            friend_list_title.text = "My Friends"
            friendRequestList = GameDataManager.shared.rosterconnection_current_friendslist_retrieve()
        }
        else {
            friend_list_title.text = "Friend request"
            friendRequestList = GameDataManager.shared.inboxnotification_current_friendrequestlist_pending()
        }
        
        completely_empty_imageView.isHidden = !friendRequestList.isEmpty
        
    }
    
    @IBAction func handleUserCenterNavReturnClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

}

extension ReauestFriendsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendRequestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendlist", for: indexPath) as! ReauestFriendsListTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        let request = friendRequestList[indexPath.row]
        cell.friends_user_name_label.text = request["nickname"]
        if let avatarName = request["avatar"] {
            cell.friends_user_avatar_imageView.image = UIImage(named: avatarName)
        }
        cell.friends_user_message_button.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if friendTag == 1 {
            let friend = friendRequestList[indexPath.row]
            let chatVC = FriendsChatViewController()
            chatVC.chatUserData = friend
            chatVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }
}
