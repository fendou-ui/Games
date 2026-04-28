
import UIKit

class ReauestFriendsListViewController: UIViewController {

    @IBOutlet weak var friend_list_title: UILabel!
    @IBOutlet weak var completely_empty_imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var friendRequestList: [[String: String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendRequestList = GameDataManager.shared.inboxnotification_current_friendrequestlist_pending()
        completely_empty_imageView.isHidden = !friendRequestList.isEmpty
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ReauestFriendsListTableViewCell", bundle: nil), forCellReuseIdentifier: "friendlist")
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
