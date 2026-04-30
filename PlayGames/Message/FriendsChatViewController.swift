
import UIKit

class FriendsChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var friends_chat_name_label: UILabel!
    @IBOutlet weak var friends_chat_text: UITextField!
    var report_black_view = PlayReportBlackView()
    var chatUserData: [String: String] = [:]
    var chatMessages: [[String: String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIReportBlackView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "FriendsChatTableViewCell", bundle: nil), forCellReuseIdentifier: "mess")
        
        friends_chat_name_label.text = chatUserData["nickname"] ?? ""
        chatMessages = GameDataManager.shared.conversationhistory_current_chatrecords_retrieve(chatUserData["nickname"] ?? "")
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
        let nickname = chatUserData["nickname"] ?? ""
        let friendsList = GameDataManager.shared.rosterconnection_current_friendslist_retrieve()
        let isFriend = friendsList.contains { $0["nickname"] == nickname }
        
        if sender.tag == 311 { // 发送聊天消息
            guard isFriend else {
                GameLoadingHUD.gameLoadingText("You can only send messages after becoming friends.", in: self.view)
                return
            }
            let text = friends_chat_text.text ?? ""
            guard !text.isEmpty else { return }
            GameDataManager.shared.dialoguetranscript_sendmessage_tochat(nickname, text: text)
            chatMessages.append(["text": text, "sender": "me"])
            friends_chat_text.text = ""
            tableView.reloadData()
            if chatMessages.count > 0 {
                tableView.scrollToRow(at: IndexPath(row: chatMessages.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
        else { // 视频聊天
            guard isFriend else {
                GameLoadingHUD.gameLoadingText("You can only send messages after becoming friends.", in: self.view)
                return
            }
            let chatVideoVC = ChatVideoViewController()
            chatVideoVC.chatTargetNickname = chatUserData["nickname"] ?? ""
            chatVideoVC.modalPresentationStyle = .fullScreen
            self.present(chatVideoVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mess", for: indexPath) as! FriendsChatTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.chat_label.text = chatMessages[indexPath.row]["text"]
        
        return cell
    }
    
    func customPopToTargetViewController() {
        if let nav = self.navigationController {
            for vc in nav.viewControllers {
                if vc is GameDiscoverViewController {
                    nav.popToViewController(vc, animated: true)
                    break
                }
                if vc is SmiroViewController {
                    nav.popToViewController(vc, animated: true)
                    break
                }
                if vc is CenterMessageViewController {
                    nav.popToViewController(vc, animated: true)
                    break
                }
                if vc is MyLikeVideoViewController {
                    nav.popToViewController(vc, animated: true)
                    break
                }
            }
        }
    }
}

extension FriendsChatViewController: PlayReportBlackViewDelegate {
    func playReportBlackViewDelegateSuccess(rateLimitTag: Int) {
        if rateLimitTag == 311 {
            GameLoadingHUD.gameLoadingSuccess("Report submitted, will be reviewed within 24 hours", in: self.view)
        }
        else {
            GameLoadingHUD.overlayconfirm_alertpopup_interactionbounce(
                title: "Block User",
                message: "Are you sure you want to block this user? You will no longer see their content.",
                confirmTitle: "Block",
                in: self.view
            ) {
                GameDataManager.shared.throttlingburst_appenduser_toblacklist_spikesimulation(self.chatUserData["nickname"] ?? "", avatar: self.chatUserData["avatar"] ?? "")
                self.customPopToTargetViewController()
            }
        }
    }
}
