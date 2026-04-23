
import UIKit

protocol PlayReportBlackViewDelegate: AnyObject {
    func playReportBlackViewDelegateSuccess()
}

class PlayReportBlackView: UIView {
    weak var delegate: PlayReportBlackViewDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func playGamesReportAndBlackWithCancelClick(_ sender: UIButton) {
        UIView.animate(withDuration: 0.31) {
            self.frame = CGRect(x: 0, y: 1200, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        
        if sender.tag == 311 {
            delegate?.playReportBlackViewDelegateSuccess()
        }
        else if sender.tag == 312 {
            delegate?.playReportBlackViewDelegateSuccess()
        }
    }
}
