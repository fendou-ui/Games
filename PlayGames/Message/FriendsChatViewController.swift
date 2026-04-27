
import UIKit

class FriendsChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var friends_chat_name_label: UILabel!
    @IBOutlet weak var friends_chat_text: UITextField!
    var report_black_view = PlayReportBlackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIReportBlackView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "FriendsChatTableViewCell", bundle: nil), forCellReuseIdentifier: "mess")
    }
    
    func setupUIReportBlackView() {
        report_black_view = UINib(nibName: "PlayReportBlackView", bundle: nil).instantiate(withOwner: self, options: nil).first as! PlayReportBlackView
        report_black_view.delegate = self
        view.addSubview(report_black_view)
        report_black_view.frame = CGRect(x: 0, y: 1200, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }

    @IBAction func handleUserCenterNavReturnClick(_ sender: UIButton) {
        if sender.tag == 512 {
            navigationController?.popViewController(animated: true)
        }
        else {
            UIView.animate(withDuration: 0.31) {
                self.report_black_view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }
        }
    }
    
    @IBAction func handleUserSubmitommentToGameChatContent(_ sender: UIButton) {
        if sender.tag == 511 {
            
        }
        else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mess", for: indexPath) as! FriendsChatTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
    }
}

extension FriendsChatViewController: PlayReportBlackViewDelegate {
    func playReportBlackViewDelegateSuccess(rateLimitTag: Int) {
        if rateLimitTag == 311 {
            
        }
        else {
            
        }
    }
}
