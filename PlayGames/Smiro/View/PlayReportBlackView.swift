
import UIKit

protocol PlayReportBlackViewDelegate: AnyObject {
    func playReportBlackViewDelegateSuccess(rateLimitTag: Int)
}

class PlayReportBlackView: UIView {
    weak var delegate: PlayReportBlackViewDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func playGamesReportAndBlackWithCancelClick(_ sender: UIButton) {
        UIView.animate(withDuration: 0.31) {
            self.frame = CGRect(x: 0, y: 1200, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }completion: { _ in
            if let window = GameDataManager.shared.coordinatordispatcherKeyWindow,
               self.superview == window {
                self.removeFromSuperview()
            }
        }
        
        if sender.tag == 311 {
            delegate?.playReportBlackViewDelegateSuccess(rateLimitTag: 311)
        }
        else if sender.tag == 312 {
            delegate?.playReportBlackViewDelegateSuccess(rateLimitTag: 312)
        }
    }
}
