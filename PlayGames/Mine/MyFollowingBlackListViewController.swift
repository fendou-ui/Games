
import UIKit

class MyFollowingBlackListViewController: UIViewController {

    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var completely_empty_imageView: UIImageView!
    var otherTag: Int = 0
    var follow_fans_black_list: [[String: String]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MyFollowingBlackListTableViewCell", bundle: nil), forCellReuseIdentifier: "follow_black")
        
        getFollowFansBlackList()
    }
    
    func getFollowFansBlackList() {
        if otherTag == 1 {
            title_label.text = "Blacklist"
            follow_fans_black_list = GameDataManager.shared.patternbehavior_current_blacklistusernames_insightfuladaptive()
        }
        if otherTag == 2 {
            title_label.text = "Fans"
        }
        if otherTag == 3 {
            title_label.text = "Follow"
        }
    }

    @IBAction func handleNavgationBackAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension MyFollowingBlackListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return follow_fans_black_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let follow_black = tableView.dequeueReusableCell(withIdentifier: "follow_black", for: indexPath) as! MyFollowingBlackListTableViewCell
        follow_black.backgroundColor = .clear
        follow_black.selectionStyle = .none
        follow_black.follow_black_user_avatar.image = UIImage(named: follow_fans_black_list[indexPath.item]["avatar"] ?? "")
        follow_black.follow_black_user_name_label.text = follow_fans_black_list[indexPath.item]["username"]
        follow_black.follow_black_user_button.tag = indexPath.item
        follow_black.follow_black_user_button.addTarget(self, action: #selector(followFansBlackRemoveClick(_ :)), for: .touchUpInside)
        return follow_black
    }
    
    @objc func followFansBlackRemoveClick(_ sender: UIButton) {
        if otherTag == 1 {
            GameDataManager.shared.modelingpredictionforecast_removeuser_fromblacklist_trend(follow_fans_black_list[sender.tag]["username"] ?? "")
        }
        if otherTag == 3 {
            
        }
        
        getFollowFansBlackList()
    }
}
