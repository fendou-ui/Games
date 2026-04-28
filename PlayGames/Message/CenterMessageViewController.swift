
import UIKit

class CenterMessageViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var completely_empty_imageView: UIImageView!
    
    var messageList: [[String: String]] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        messageList = GameDataManager.shared.inboxnotification_current_friendrequestlist_pending().map { request in
            [
                "reviewapproval_sender_displayname_violation": request["nickname"] ?? "",
                "guidelinepolicycommunity_sender_avatarimage_socialnetwork": request["avatar"] ?? "",
                "connectionfriendship_latest_messagepreview_followunfollow": request["message"] ?? ""
            ]
        }
        completely_empty_imageView.isHidden = !messageList.isEmpty
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CenterMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "messageContent")
    }

    @IBAction func attachTagsAndCategoriesToGameCommunityPostBefore(_ sender: UIButton) {
        if sender.tag == 511 {
            let friendsListVC = ReauestFriendsListViewController()
            friendsListVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(friendsListVC, animated: true)
        }
        else {
            
        }
    }
}

extension CenterMessageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageContent", for: indexPath) as! CenterMessageTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        let msg = messageList[indexPath.row]
        cell.center_message_name_label.text = msg["reviewapproval_sender_displayname_violation"]
        cell.center_message_content_label.text = msg["connectionfriendship_latest_messagepreview_followunfollow"]
        if let avatarName = msg["guidelinepolicycommunity_sender_avatarimage_socialnetwork"] {
            cell.center_message_avatar_imageView.image = UIImage(named: avatarName)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = FriendsChatViewController()
        chatVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}
