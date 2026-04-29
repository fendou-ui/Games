
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
            friendRequestList = GameDataManager.shared.personalizedanalyticsmetricsPendingFriendrequestInsight()
        }
        
        completely_empty_imageView.isHidden = !friendRequestList.isEmpty
        
    }
    
    @IBAction func handleUserCenterNavReturnClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // 同意好友请求
    @objc func agreeAddFriendQuestClick(_ sender: UIButton) {
        let index = sender.tag
        guard index < friendRequestList.count else { return }
        let request = friendRequestList[index]
        
        // 加入好友列表
        var currentFriends = GameDataManager.shared.rosterconnection_current_friendslist_retrieve()
        if !currentFriends.contains(where: { $0["nickname"] == request["nickname"] }) {
            currentFriends.append(request)
            GameDataManager.shared.rosterconnection_save_friendslist(currentFriends)
        }
        
        // 从请求列表移除
        friendRequestList.remove(at: index)
        completely_empty_imageView.isHidden = !friendRequestList.isEmpty
        tableView.reloadData()
        
        GameLoadingHUD.gameLoadingSuccess("You are now friends with \(request["nickname"] ?? "")", in: self.view)
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
        if friendTag == 0 {
            cell.friends_user_message_button.isHidden = false
            cell.friends_user_message_button.tag = indexPath.row
            cell.friends_user_message_button.addTarget(self, action: #selector(agreeAddFriendQuestClick(_ :)), for: .touchUpInside)
        }
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
