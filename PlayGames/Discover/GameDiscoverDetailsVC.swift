
import UIKit

class GameDiscoverDetailsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var game_discover_name_label: UILabel!
    @IBOutlet weak var game_discover_time_label: UILabel!
    @IBOutlet weak var game_discover_avatar_imageView: UIImageView!
    @IBOutlet weak var game_discover_follow_tap: UIButton!
    @IBOutlet weak var game_discover_something: UITextField!
    var report_black_view = PlayReportBlackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CommentsCell", bundle: nil), forCellReuseIdentifier: "content")
        tableView.register(UINib(nibName: "GameDiscoverDetailsCell", bundle: nil), forCellReuseIdentifier: "section")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupUIReportBlackView() {
        report_black_view = UINib(nibName: "PlayReportBlackView", bundle: nil).instantiate(withOwner: self, options: nil).first as! PlayReportBlackView
        report_black_view.delegate = self
        view.addSubview(report_black_view)
        report_black_view.frame = CGRect(x: 0, y: 1200, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }

    @IBAction func requestUserFollowOrUnfollowTargetCommunityCreator(_ sender: UIButton) {
        if sender.tag == 511 {
            UIView.animate(withDuration: 0.31) {
                self.report_black_view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }
        }
        else if sender.tag == 512 {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            
        }
    }
    
    @IBAction func handleUserUploadGameScreenshotAndAttachMetadata(_ sender: Any) {
        
    }
}

extension GameDiscoverDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "section", for: indexPath) as! GameDiscoverDetailsCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "content", for: indexPath) as! CommentsCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
    }
}

extension GameDiscoverDetailsVC: PlayReportBlackViewDelegate {
    func playReportBlackViewDelegateSuccess() {
        self.navigationController?.popViewController(animated: true)
    }
}
