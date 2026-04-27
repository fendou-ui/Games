
import UIKit

class MyFollowingBlackListViewController: UIViewController {

    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var completely_empty_imageView: UIImageView!
    var otherTag: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MyFollowingBlackListTableViewCell", bundle: nil), forCellReuseIdentifier: "follow_black")
        
        if otherTag == 1 {
            title_label.text = "Blacklist"
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let follow_black = tableView.dequeueReusableCell(withIdentifier: "follow_black", for: indexPath) as! MyFollowingBlackListTableViewCell
        follow_black.backgroundColor = .clear
        follow_black.selectionStyle = .none
        
        return follow_black
    }
}
