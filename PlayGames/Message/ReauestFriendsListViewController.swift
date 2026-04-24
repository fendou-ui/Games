
import UIKit

class ReauestFriendsListViewController: UIViewController {

    @IBOutlet weak var friend_list_title: UILabel!
    @IBOutlet weak var completely_empty_imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendlist", for: indexPath) as! ReauestFriendsListTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
