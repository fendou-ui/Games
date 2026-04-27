
import UIKit

class ChatVideoViewController: UIViewController {

    @IBOutlet weak var chat_name_label: UILabel!
    @IBOutlet weak var chat_shoot_view: UIView!
    var report_black_view = PlayReportBlackView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIReportBlackView()
    }
    
    func setupUIReportBlackView() {
        report_black_view = UINib(nibName: "PlayReportBlackView", bundle: nil).instantiate(withOwner: self, options: nil).first as! PlayReportBlackView
        report_black_view.delegate = self
        view.addSubview(report_black_view)
        report_black_view.frame = CGRect(x: 0, y: 1200, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }

    @IBAction func handleUserCenterNavReturnClick(_ sender: UIButton) {
        if sender.tag == 512 {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            UIView.animate(withDuration: 0.31) {
                self.report_black_view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }
        }
    }
    
    @IBAction func chatVideoCallEndClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ChatVideoViewController: PlayReportBlackViewDelegate {
    func playReportBlackViewDelegateSuccess(rateLimitTag: Int) {
        if rateLimitTag == 311 {
            
        }
        else {
            
        }
    }
}
