
import UIKit

class CenterMessageViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var completely_empty_imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageContent", for: indexPath) as! CenterMessageTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = FriendsChatViewController()
        chatVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}
