
import UIKit

class OpenPlayerVideoVC: UIViewController {

    @IBOutlet weak var open_player_avatar_imageView: UIImageView!
    @IBOutlet weak var open_player_name_label: UILabel!
    @IBOutlet weak var open_player_follow_button: UIButton!
    @IBOutlet weak var open_player_content_label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var open_player_textFiled: UITextField!
    @IBOutlet weak var open_player_like_button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        open_player_avatar_imageView.layer.borderColor = UIColor.white.cgColor
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "OnlineTableViewCell", bundle: nil), forCellReuseIdentifier: "online")
    }
    
    @IBAction func openPlayerVideoReturnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // 用户中心，关注，分享，举报
    @IBAction func requestUserFollowOrUnfollowTargetCommunityCreator(_ sender: UIButton) {
        if sender.tag == 511 {
            return
        }
        if sender.tag == 512 {
            return
        }
        if sender.tag == 513 {
            return
        }
        if sender.tag == 514 {
            return
        }
        
    }
    
    //发送、声音、点赞
    @IBAction func processUserLikeActionForGameCommunityPostItem(_ sender: UIButton) {
        if sender.tag == 311 {
            return
        }
        if sender.tag == 312 {
            return
        }
        if sender.tag == 313 {
            return
        }
    }
    
    
}

extension OpenPlayerVideoVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "online", for: indexPath) as! OnlineTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        return cell
    }
}
