
import UIKit

class OnlineViewController: UIViewController {

    @IBOutlet weak var user_avatar_image: UIImageView!
    @IBOutlet weak var user_name_label: UILabel!
    @IBOutlet weak var user_people_number_label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        user_avatar_image.layer.borderColor = UIColor.white.cgColor
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "OnlineTableViewCell", bundle: nil), forCellReuseIdentifier: "online")
    }

    @IBAction func online_dissmissClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func online_userAddFriendClick(_ sender: UIButton) {
        
    }
    
}

extension OnlineViewController: UITableViewDelegate, UITableViewDataSource {
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
