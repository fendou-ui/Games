
import UIKit

class MySettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var mySettes: [[String: String]] = [[String: String]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        settingMetedata()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MySettingTableViewCell", bundle: nil), forCellReuseIdentifier: "set")
    }
    
    func settingMetedata() {
        mySettes = [
            ["image_icon": "dfmniqwe", "item_name": "Video with likes"],
            ["image_icon": "sdfnjksdf", "item_name": "Blacklist"],
            ["image_icon": "mjcxhnvjsdh", "item_name": "Privacy agreement"],
            ["image_icon": "cmxvnjs", "item_name": "User agreement"],
            ["image_icon": "qwndsjkfer", "item_name": "Contact Us"],
            ["image_icon": "qwnjkdsnfr", "item_name": "Community guidelines"],
            ["image_icon": "sdjfhwer", "item_name": "Deletion of account"],
        ]
    }

    @IBAction func handleNavgationBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleExitLogOutAction(_ sender: Any) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySettes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "set", for: indexPath) as! MySettingTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let dict = mySettes[indexPath.item]
        cell.set_image_icon.image = UIImage(named: dict["image_icon", default: ""])
        cell.set_label.text = dict["item_name"]
        if dict["item_name"] == "Deletion of account" {
            cell.set_label.textColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = mySettes[indexPath.item]
        if dict["item_name"] == "Video with likes" {
            self.navigationController?.pushViewController(MyLikeVideoViewController(), animated: true)
        }
        else if dict["item_name"] == "Blacklist" {
            let blacklist = MyFollowingBlackListViewController()
            blacklist.otherTag = 1
            navigationController?.pushViewController(blacklist, animated: true)
        }
        
    }
    
}
