
import UIKit

class OnlineGiftsView: UIView {

    @IBOutlet weak var online_balance_label: UILabel! // 金币余额
    @IBOutlet weak var online_number_label: UILabel! // 打赏份数
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var online_reduct_button: UIButton! // 减少按钮
    @IBOutlet weak var online_add_button: UIButton! // 增加好友
    var online_gifts_list: [[String: String]] = [[String: String]]()
    var online_select_tag: Int = 0
    var giftCount: Int = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        online_giftsMetedataList()
        setupUIOnlineGiftsCollectionView()
        refreshBalanceDisplay()
        updateNumberLabel()
    }
    
    func setupUIOnlineGiftsCollectionView() {
        let online_layout = UICollectionViewFlowLayout()
        online_layout.scrollDirection = .vertical
        online_layout.minimumInteritemSpacing = 15
        online_layout.minimumLineSpacing = 12
        online_layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 85.1)/4, height: 104)
        online_layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        collectionView.collectionViewLayout = online_layout
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "OnlineGiftCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "gifts")
    }
    
    func online_giftsMetedataList() {
        online_gifts_list = [
            ["gifts_icon": "gift_game_beer_icon", "gifts_coins": "9"],
            ["gifts_icon": "gift_game_cola_icon", "gifts_coins": "19"],
            ["gifts_icon": "gift_game_like_icon", "gifts_coins": "29"],
            ["gifts_icon": "gift_game_lips_icon", "gifts_coins": "39"],
            ["gifts_icon": "gift_game_ok_icon", "gifts_coins": "49"],
            ["gifts_icon": "gift_game_rainbow_icon", "gifts_coins": "59"],
            ["gifts_icon": "gift_game_rose_icon", "gifts_coins": "69"],
            ["gifts_icon": "gift_game_stars_icon", "gifts_coins": "79"],
        ]
    }
    
    @IBAction func onlineDismissGiftsViewClick(_ sender: Any) {
        UIView.animate(withDuration: 0.29) {
            self.frame = CGRect(x: 0, y: 1200, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }
    
    @IBAction func onlineAddOrShaoCountClick(_ sender: UIButton) {
        if sender.tag == 311 { // 减少
            if giftCount > 1 {
                giftCount -= 1
            }
        }
        else { // 增加
            giftCount += 1
        }
        updateNumberLabel()
    }
    
    func updateNumberLabel() {
        let dict = online_gifts_list[online_select_tag]
        let unitPrice = Int(dict["gifts_coins"] ?? "0") ?? 0
        let total = unitPrice * giftCount
        online_number_label.text = "\(giftCount)"
    }
    
    func refreshBalanceDisplay() {
        let profile = GameDataManager.shared.dashboardsnapshot_load_userprofile()
        let coins = profile["executor_wallet_coinsbalance_observerlistenerdelegate"] ?? "0"
        online_balance_label.text = coins
    }
    
    
    // 打赏礼物
    @IBAction func onlineSendGiftsClick(_ sender: Any) {
        let dict = online_gifts_list[online_select_tag]
        let unitPrice = Int(dict["gifts_coins"] ?? "0") ?? 0
        let totalCost = unitPrice * giftCount
        
        var profile = GameDataManager.shared.dashboardsnapshot_load_userprofile()
        let balance = Int(profile["executor_wallet_coinsbalance_observerlistenerdelegate"] ?? "0") ?? 0
        
        if balance < totalCost {
            GameLoadingHUD.gameLoadingText("Insufficient coins, \(totalCost) coins required.", in: self)
            return
        }
        
        profile["executor_wallet_coinsbalance_observerlistenerdelegate"] = "\(balance - totalCost)"
        GameDataManager.shared.dashboardsnapshot_save_userprofile(profile)
        refreshBalanceDisplay()
        
        GameLoadingHUD.gameLoadingSuccess("Sent \(giftCount) gift(s)! -\(totalCost) coins", in: self)
        
        if let giftImage = UIImage(named: dict["gifts_icon"] ?? "") {
            let profile = GameDataManager.shared.dashboardsnapshot_load_userprofile()
            let nickname = profile["processhandler_profile_nickname_manager"] ?? "Me"
            if let parentVC = self.superview {
                online_giftViewingAnimation(giftImage: giftImage, senderName: nickname, in: parentVC)
                if totalCost >= 100 {
                    playFullScreenAnimation(giftImage: giftImage, senderName: nickname, in: parentVC)
                }
            }
        }
        
        giftCount = 1
        updateNumberLabel()
    }
    
    func playFullScreenAnimation(giftImage: UIImage, senderName: String, in containerView: UIView) {
    
        let flash = UIView(frame: containerView.bounds)
        flash.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        flash.alpha = 0
        containerView.addSubview(flash)
        UIView.animateKeyframes(withDuration: 0.6, delay: 0) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.15) { flash.alpha = 1 }
            UIView.addKeyframe(withRelativeStartTime: 0.15, relativeDuration: 0.85) { flash.alpha = 0 }
        } completion: { _ in flash.removeFromSuperview() }
        
        // === 阶段 2：中央爆炸（0.2s 后） ===
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let giftLayer = CALayer()
            giftLayer.contents = giftImage.cgImage
            giftLayer.contentsGravity = .resizeAspect
            giftLayer.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
            giftLayer.position = CGPoint(x: containerView.bounds.midX, y: containerView.bounds.midY - 50)
            giftLayer.opacity = 0
            containerView.layer.addSublayer(giftLayer)
            
            // 弹性放大
            let scale = CASpringAnimation(keyPath: "transform.scale")
            scale.fromValue = 0
            scale.toValue = 1.0
            scale.stiffness = 150
            scale.damping = 12
            scale.mass = 2.0
            scale.initialVelocity = 10
            scale.duration = scale.settlingDuration
            
            let fadeIn = CABasicAnimation(keyPath: "opacity")
            fadeIn.fromValue = 0; fadeIn.toValue = 1; fadeIn.duration = 0.15
            
            let group = CAAnimationGroup()
            group.animations = [scale, fadeIn]
            group.duration = scale.settlingDuration
            group.fillMode = .forwards
            group.isRemovedOnCompletion = false
            giftLayer.add(group, forKey: "burst")
            
            // 光晕
            let glow = CAShapeLayer()
            glow.path = UIBezierPath(arcCenter: giftLayer.position, radius: 40, startAngle: 0, endAngle: .pi * 2, clockwise: true).cgPath
            glow.fillColor = UIColor.clear.cgColor
            glow.strokeColor = UIColor(red: 1, green: 0.84, blue: 0, alpha: 0.8).cgColor
            glow.lineWidth = 3; glow.opacity = 0
            containerView.layer.addSublayer(glow)
            
            let expand = CABasicAnimation(keyPath: "transform.scale")
            expand.fromValue = 1; expand.toValue = 4; expand.duration = 0.8
            let glowFade = CABasicAnimation(keyPath: "opacity")
            glowFade.fromValue = 1; glowFade.toValue = 0; glowFade.duration = 0.8
            let glowGroup = CAAnimationGroup()
            glowGroup.animations = [expand, glowFade]; glowGroup.duration = 0.8
            glowGroup.fillMode = .forwards; glowGroup.isRemovedOnCompletion = false
            CATransaction.begin()
            CATransaction.setCompletionBlock { glow.removeFromSuperlayer() }
            glow.add(glowGroup, forKey: "glow")
            CATransaction.commit()
            
            // 1.2 秒后礼物渐隐
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                let fadeOut = CABasicAnimation(keyPath: "opacity")
                fadeOut.fromValue = 1; fadeOut.toValue = 0; fadeOut.duration = 0.4
                fadeOut.fillMode = .forwards; fadeOut.isRemovedOnCompletion = false
                CATransaction.begin()
                CATransaction.setCompletionBlock { giftLayer.removeFromSuperlayer() }
                giftLayer.add(fadeOut, forKey: "fadeOut")
                CATransaction.commit()
            }
        }
        
        // === 阶段 3：粒子雨（1.5s 后） ===
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let emitter = CAEmitterLayer()
            emitter.emitterPosition = CGPoint(x: containerView.bounds.midX, y: -20)
            emitter.emitterSize = CGSize(width: containerView.bounds.width, height: 1)
            emitter.emitterShape = .line
            
            let cell = CAEmitterCell()
            cell.contents = giftImage.cgImage
            cell.birthRate = 12
            cell.lifetime = 5
            cell.velocity = 180
            cell.velocityRange = 60
            cell.yAcceleration = 50
            cell.spin = 1.5
            cell.spinRange = 3
            cell.scale = 0.15
            cell.scaleRange = 0.08
            cell.alphaSpeed = -0.12
            cell.emissionLongitude = .pi
            cell.emissionRange = .pi / 4
            
            emitter.emitterCells = [cell]
            containerView.layer.addSublayer(emitter)
            
            // 3 秒后停止，5 秒后移除
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                emitter.birthRate = 0
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    emitter.removeFromSuperlayer()
                }
            }
        }
    }

    
}

extension OnlineGiftsView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return online_gifts_list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dict = online_gifts_list[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifts", for: indexPath) as! OnlineGiftCollectionViewCell
        cell.backgroundColor = .clear
        cell.cell_gift_coins_label.text = dict["gifts_coins"]
        cell.cell_gift_image.image = UIImage(named: dict["gifts_icon", default: ""])
        if indexPath.item == online_select_tag {
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor(red: 1, green: 0.6, blue: 0, alpha: 1).cgColor
            cell.layer.cornerRadius = 10
        } else {
            cell.layer.borderWidth = 0
            cell.layer.borderColor = UIColor.clear.cgColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        online_select_tag = indexPath.item
        giftCount = 1
        updateNumberLabel()
        collectionView.reloadData()
    }
    
    func online_giftViewingAnimation(giftImage: UIImage, senderName: String, in containerView: UIView) {

        let send_gift_item = UIView(frame: CGRect(x: -300, y: containerView.bounds.height * 0.35, width: 200, height: 60))
        send_gift_item.layer.cornerRadius = 30
        send_gift_item.clipsToBounds = true
        
        let send_gift_gradient = CAGradientLayer()
        send_gift_gradient.frame = send_gift_item.bounds
        send_gift_gradient.colors = [
            UIColor(red: 0.95, green: 0.3, blue: 0.5, alpha: 0.85).cgColor,
            UIColor(red: 0.6, green: 0.2, blue: 0.8, alpha: 0.6).cgColor
        ]
        send_gift_gradient.startPoint = CGPoint(x: 0, y: 0.5)
        send_gift_gradient.endPoint = CGPoint(x: 1, y: 0.5)
        send_gift_item.layer.insertSublayer(send_gift_gradient, at: 0)
        
        let send_gift_name_label = UILabel(frame: CGRect(x: 15, y: 8, width: 140, height: 20))
        send_gift_name_label.text = senderName
        send_gift_name_label.font = .systemFont(ofSize: 14, weight: .semibold)
        send_gift_name_label.textColor = .white
        send_gift_item.addSubview(send_gift_name_label)
        
        let send_gift_label = UILabel(frame: CGRect(x: 15, y: 30, width: 140, height: 16))
        send_gift_label.text = "Send a gift"
        send_gift_label.font = .systemFont(ofSize: 12)
        send_gift_label.textColor = UIColor.white.withAlphaComponent(0.8)
        send_gift_item.addSubview(send_gift_label)
        
        let send_gift_image_icon = UIImageView(frame: CGRect(x: 130, y: 5, width: 50, height: 50))
        send_gift_image_icon.image = giftImage
        send_gift_image_icon.contentMode = .scaleAspectFit
        send_gift_image_icon.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        send_gift_item.addSubview(send_gift_image_icon)
        
        containerView.addSubview(send_gift_item)
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            send_gift_item.frame.origin.x = 12
        } completion: { _ in
            let bounce = CASpringAnimation(keyPath: "transform.scale")
            bounce.fromValue = 0.3
            bounce.toValue = 1.0
            bounce.stiffness = 300
            bounce.damping = 10
            bounce.duration = bounce.settlingDuration
            send_gift_image_icon.layer.add(bounce, forKey: "bounce")
            send_gift_image_icon.transform = .identity
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            UIView.animate(withDuration: 0.3, animations: {
                send_gift_item.frame.origin.x = UIScreen.main.bounds.width + 50
                send_gift_item.alpha = 0
            }) { _ in
                send_gift_item.removeFromSuperview()
            }
        }
    }

}
