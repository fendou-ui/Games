
import UIKit

class GameDiscoverViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var report_black_view = PlayReportBlackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIReportBlackView()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "GameDiscoverTableViewCell", bundle: nil), forCellReuseIdentifier: "discover")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    func setupUIReportBlackView() {
        report_black_view = UINib(nibName: "PlayReportBlackView", bundle: nil).instantiate(withOwner: self, options: nil).first as! PlayReportBlackView
        report_black_view.delegate = self
        view.addSubview(report_black_view)
        report_black_view.frame = CGRect(x: 0, y: 1200, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    @IBAction func processUserCreateNewGameCommunityPostWithMediaContent(_ sender: Any) {
        let postDiscoverVC = PostVideoDynamicVC()
        postDiscoverVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(postDiscoverVC, animated: true)
    }
    
}

extension GameDiscoverViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "discover", for: indexPath) as! GameDiscoverTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.cell_discover_report_button.tag = indexPath.item
        cell.cell_discover_report_button.addTarget(self, action: #selector(submitUserReportForInappropriateGameCommunityContent(_ :)), for: .touchUpInside)
        
        cell.cell_discover_center_button.tag = indexPath.item
        cell.cell_discover_center_button.addTarget(self, action: #selector(enterUserInterestProfileBasedOnRecentInteractionData(_ :)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let discoverDetailsVC = GameDiscoverDetailsVC()
        discoverDetailsVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(discoverDetailsVC, animated: true)
    }
    
    
    /// 举报
    @objc func submitUserReportForInappropriateGameCommunityContent(_ sender: UIButton) {
        UIView.animate(withDuration: 0.31) {
            self.report_black_view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }
    
    @objc func enterUserInterestProfileBasedOnRecentInteractionData(_ sender: UIButton) {
        let userCenterVC = UserGameCnterVC()
        userCenterVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(userCenterVC, animated: true)
    }
}

extension GameDiscoverViewController: PlayReportBlackViewDelegate {
    func playReportBlackViewDelegateSuccess(rateLimitTag: Int) {
        if rateLimitTag == 311 {
            
        }
        else {
            
        }
    }
}
