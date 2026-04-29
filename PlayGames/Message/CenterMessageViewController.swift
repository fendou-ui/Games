
import UIKit

class CenterMessageViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var completely_empty_imageView: UIImageView!
    @IBOutlet weak var hurry_up_label: UILabel!
    
    var messageList: [[String: String]] = []
    var friendsList: [[String: String]] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        friendsList = GameDataManager.shared.rosterconnection_current_friendslist_retrieve()
        
        messageList = friendsList.compactMap { friend in
            let nickname = friend["nickname"] ?? ""
            let avatar = friend["avatar"] ?? ""
            let chatRecords = GameDataManager.shared.conversationhistory_current_chatrecords_retrieve(nickname)
            let lastMessage = chatRecords.last?["text"] ?? ""
            guard !lastMessage.isEmpty else { return nil }
            return [
                "reviewapproval_sender_displayname_violation": nickname,
                "guidelinepolicycommunity_sender_avatarimage_socialnetwork": avatar,
                "connectionfriendship_latest_messagepreview_followunfollow": lastMessage
            ]
        }
        
        let sentRequests = GameDataManager.shared.inboxnotification_current_friendrequestlist_pending()
        for request in sentRequests {
            let nickname = request["nickname"] ?? ""
            let avatar = request["avatar"] ?? ""
            let msg = request["message"] ?? "Friend request sent"
            if !messageList.contains(where: { $0["reviewapproval_sender_displayname_violation"] == nickname }) {
                messageList.append([
                    "reviewapproval_sender_displayname_violation": nickname,
                    "guidelinepolicycommunity_sender_avatarimage_socialnetwork": avatar,
                    "connectionfriendship_latest_messagepreview_followunfollow": msg
                ])
            }
        }
        
        completely_empty_imageView.isHidden = !messageList.isEmpty
        tableView.reloadData()
        collectionView.reloadData()
        
        hurry_up_label.isHidden = true
        if friendsList.count == 0 {
            hurry_up_label.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CenterMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "messageContent")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: 70, height: 90)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "friendCell")
    }

    @IBAction func attachTagsAndCategoriesToGameCommunityPostBefore(_ sender: UIButton) {
        if sender.tag == 511 {
            let friendsListVC = ReauestFriendsListViewController()
            friendsListVC.friendTag = 0
            friendsListVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(friendsListVC, animated: true)
        }
        else {
            let friendsListVC = ReauestFriendsListViewController()
            friendsListVC.friendTag = 1
            friendsListVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(friendsListVC, animated: true)
        }
    }
}

extension CenterMessageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friendsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendCell", for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let friend = friendsList[indexPath.item]
        
        let avatarView = UIImageView(frame: CGRect(x: 7, y: 0, width: 56, height: 56))
        avatarView.layer.cornerRadius = 28
        avatarView.layer.masksToBounds = true
        avatarView.contentMode = .scaleAspectFill
        if let avatarName = friend["avatar"] {
            avatarView.image = UIImage(named: avatarName)
        }
        cell.contentView.addSubview(avatarView)
        
        let nameLabel = UILabel(frame: CGRect(x: 0, y: 60, width: 70, height: 28))
        nameLabel.text = friend["nickname"]
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        nameLabel.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        
        nameLabel.textAlignment = .center
        cell.contentView.addSubview(nameLabel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let friend = friendsList[indexPath.item]
        let chatVC = FriendsChatViewController()
        chatVC.chatUserData = friend
        chatVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chatVC, animated: true)
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
        let msg = messageList[indexPath.row]
        let chatVC = FriendsChatViewController()
        chatVC.chatUserData = [
            "nickname": msg["reviewapproval_sender_displayname_violation"] ?? "",
            "avatar": msg["guidelinepolicycommunity_sender_avatarimage_socialnetwork"] ?? ""
        ]
        chatVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}
