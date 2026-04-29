import UIKit

class GameLoadingHUD: UIView {
    
    // MARK: - 单例持有当前显示的 HUD
    private static var currentHUD: GameLoadingHUD?
    
    // MARK: - UI 组件
    let containerView = UIView()
    let indicatorView = UIActivityIndicatorView(style: .large)
    let textLabel = UILabel()
    
    // MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 搭建 UI
    func setupUI() {
        // 全屏半透明遮罩
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        // 中间容器
        containerView.backgroundColor = UIColor(white: 0.15, alpha: 0.65)
        containerView.layer.cornerRadius = 14
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        // 转圈指示器
        indicatorView.color = .cyan
        indicatorView.hidesWhenStopped = false
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(indicatorView)
        
        // 文字
        textLabel.textColor = .white
        textLabel.font = .systemFont(ofSize: 14, weight: .medium)
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(greaterThanOrEqualToConstant: 120),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            
            indicatorView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            indicatorView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            
            textLabel.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 14),
            textLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            textLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - 显示动画
    func showAnimation() {
        containerView.alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        if !indicatorView.isHidden {
            indicatorView.startAnimating()
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        }
    }
    
    // MARK: - 隐藏动画
    func hideAnimation(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.backgroundColor = .clear
        }) { _ in
            self.indicatorView.stopAnimating()
            self.removeFromSuperview()
            completion?()
        }
    }
    
    // MARK: - ✅ 显示加载
    static func gameLoadingShow(_ text: String = "Loading...", in view: UIView? = nil) {
        DispatchQueue.main.async {
            dismissImmediately()
            
            guard let targetView = view ?? gameTopView() else { return }
            
            let hud = GameLoadingHUD(frame: targetView.bounds)
            hud.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            hud.textLabel.text = text
            targetView.addSubview(hud)
            hud.showAnimation()
            
            currentHUD = hud
        }
    }
    
    // MARK: - ✅ 隐藏
    static func gameLoadingDismiss() {
        DispatchQueue.main.async {
            dismissImmediately()
        }
    }
    
    /// 同步移除，内部调用，避免嵌套 async 导致时序问题
    private static func dismissImmediately() {
        currentHUD?.hideAnimation()
        currentHUD = nil
    }
    
    // MARK: - ✅ 成功提示
    static func gameLoadingSuccess(_ text: String = "Success", in view: UIView? = nil, delay: TimeInterval = 1.5) {
        DispatchQueue.main.async {
            dismissImmediately()
            
            guard let targetView = view ?? gameTopView() else { return }
            
            let hud = GameLoadingHUD(frame: targetView.bounds)
            hud.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            hud.indicatorView.stopAnimating()
            hud.indicatorView.isHidden = true
            
            // ✅ 图标居中
            let successLabel = UILabel()
            successLabel.text = "✅"
            successLabel.font = .systemFont(ofSize: 40)
            successLabel.textAlignment = .center
            successLabel.translatesAutoresizingMaskIntoConstraints = false
            hud.containerView.addSubview(successLabel)
            
            hud.textLabel.text = text
            hud.textLabel.font = .systemFont(ofSize: 14, weight: .medium)
            
            NSLayoutConstraint.activate([
                successLabel.centerXAnchor.constraint(equalTo: hud.containerView.centerXAnchor),
                successLabel.topAnchor.constraint(equalTo: hud.containerView.topAnchor, constant: 20),
                hud.textLabel.topAnchor.constraint(equalTo: successLabel.bottomAnchor, constant: 12)
            ])
            
            targetView.addSubview(hud)
            hud.showAnimation()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                hud.hideAnimation()
            }
        }
    }
    
    // MARK: - ✅ 失败提示
    static func gameLoadingError(_ text: String = "Error", in view: UIView? = nil, delay: TimeInterval = 1.5) {
        DispatchQueue.main.async {
            dismissImmediately()
            
            guard let targetView = view ?? gameTopView() else { return }
            
            let hud = GameLoadingHUD(frame: targetView.bounds)
            hud.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            hud.indicatorView.stopAnimating()
            hud.indicatorView.isHidden = true
            
            // ❌ 图标居中
            let errorLabel = UILabel()
            errorLabel.text = "❌"
            errorLabel.font = .systemFont(ofSize: 40)
            errorLabel.textAlignment = .center
            errorLabel.translatesAutoresizingMaskIntoConstraints = false
            hud.containerView.addSubview(errorLabel)
            
            hud.textLabel.text = text
            hud.textLabel.font = .systemFont(ofSize: 14, weight: .medium)
            
            NSLayoutConstraint.activate([
                errorLabel.centerXAnchor.constraint(equalTo: hud.containerView.centerXAnchor),
                errorLabel.topAnchor.constraint(equalTo: hud.containerView.topAnchor, constant: 20),
                hud.textLabel.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 12)
            ])
            
            targetView.addSubview(hud)
            hud.showAnimation()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                hud.hideAnimation()
            }
        }
    }
    
    // MARK: - ✅ 纯文字 Toast
    static func gameLoadingText(_ text: String, in view: UIView? = nil, delay: TimeInterval = 1.5) {
        DispatchQueue.main.async {
            dismissImmediately()
            
            guard let targetView = view ?? gameTopView() else { return }
            
            let hud = GameLoadingHUD(frame: targetView.bounds)
            hud.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            hud.indicatorView.stopAnimating()
            hud.indicatorView.isHidden = true
            hud.textLabel.text = text
            
            hud.textLabel.topAnchor.constraint(equalTo: hud.containerView.topAnchor, constant: 30).isActive = true
            
            targetView.addSubview(hud)
            hud.showAnimation()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                hud.hideAnimation()
            }
        }
    }
    
    // MARK: - 获取最顶层 View
    static func gameTopView() -> UIView? {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }),
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }
        return window
    }
    
    // MARK: - 自定义确认弹窗
    static func overlayconfirm_alertpopup_interactionbounce(title: String, message: String, confirmTitle: String = "OK", cancelTitle: String = "Cancel", in parentView: UIView, onConfirm: @escaping () -> Void) {
        
        let dimscreen_backdrop_wrapper = UIView(frame: parentView.bounds)
        dimscreen_backdrop_wrapper.tag = 9527
        
        let frostlayer_visual_effect = UIBlurEffect(style: .dark)
        let frostlayer_blur_renderer = UIVisualEffectView(effect: frostlayer_visual_effect)
        frostlayer_blur_renderer.frame = dimscreen_backdrop_wrapper.bounds
        frostlayer_blur_renderer.alpha = 0
        dimscreen_backdrop_wrapper.addSubview(frostlayer_blur_renderer)
        
        let popcard_container_panel = UIView()
        popcard_container_panel.backgroundColor = UIColor(white: 0.13, alpha: 0.95)
        popcard_container_panel.layer.cornerRadius = 20
        popcard_container_panel.layer.shadowColor = UIColor.black.cgColor
        popcard_container_panel.layer.shadowOpacity = 0.5
        popcard_container_panel.layer.shadowOffset = CGSize(width: 0, height: 8)
        popcard_container_panel.layer.shadowRadius = 20
        popcard_container_panel.translatesAutoresizingMaskIntoConstraints = false
        dimscreen_backdrop_wrapper.addSubview(popcard_container_panel)
        
        let warnemoji_icon_display = UILabel()
        warnemoji_icon_display.text = "⚠️"
        warnemoji_icon_display.font = .systemFont(ofSize: 40)
        warnemoji_icon_display.textAlignment = .center
        warnemoji_icon_display.translatesAutoresizingMaskIntoConstraints = false
        popcard_container_panel.addSubview(warnemoji_icon_display)
        
        let heading_title_label = UILabel()
        heading_title_label.text = title
        heading_title_label.font = .systemFont(ofSize: 18, weight: .bold)
        heading_title_label.textColor = .white
        heading_title_label.textAlignment = .center
        heading_title_label.translatesAutoresizingMaskIntoConstraints = false
        popcard_container_panel.addSubview(heading_title_label)
        
        let subtitle_desc_label = UILabel()
        subtitle_desc_label.text = message
        subtitle_desc_label.font = .systemFont(ofSize: 14)
        subtitle_desc_label.textColor = UIColor(white: 0.7, alpha: 1)
        subtitle_desc_label.textAlignment = .center
        subtitle_desc_label.numberOfLines = 0
        subtitle_desc_label.translatesAutoresizingMaskIntoConstraints = false
        popcard_container_panel.addSubview(subtitle_desc_label)
        
        let actionrow_button_stack = UIStackView()
        actionrow_button_stack.axis = .horizontal
        actionrow_button_stack.spacing = 12
        actionrow_button_stack.distribution = .fillEqually
        actionrow_button_stack.translatesAutoresizingMaskIntoConstraints = false
        popcard_container_panel.addSubview(actionrow_button_stack)
        
        let dismiss_cancel_btn = UIButton(type: .system)
        dismiss_cancel_btn.setTitle(cancelTitle, for: .normal)
        dismiss_cancel_btn.setTitleColor(UIColor(white: 0.8, alpha: 1), for: .normal)
        dismiss_cancel_btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        dismiss_cancel_btn.backgroundColor = UIColor(white: 0.25, alpha: 1)
        dismiss_cancel_btn.layer.cornerRadius = 12
        actionrow_button_stack.addArrangedSubview(dismiss_cancel_btn)
        
        let proceed_confirm_btn = UIButton(type: .system)
        proceed_confirm_btn.setTitle(confirmTitle, for: .normal)
        proceed_confirm_btn.setTitleColor(.white, for: .normal)
        proceed_confirm_btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        proceed_confirm_btn.layer.cornerRadius = 12
        proceed_confirm_btn.clipsToBounds = true
        actionrow_button_stack.addArrangedSubview(proceed_confirm_btn)
        
        let redshift_gradient_layer = CAGradientLayer()
        redshift_gradient_layer.colors = [
            UIColor(red: 1, green: 0.3, blue: 0.35, alpha: 1).cgColor,
            UIColor(red: 0.85, green: 0.15, blue: 0.3, alpha: 1).cgColor
        ]
        redshift_gradient_layer.startPoint = CGPoint(x: 0, y: 0.5)
        redshift_gradient_layer.endPoint = CGPoint(x: 1, y: 0.5)
        redshift_gradient_layer.frame = CGRect(x: 0, y: 0, width: 200, height: 48)
        redshift_gradient_layer.cornerRadius = 12
        proceed_confirm_btn.layer.insertSublayer(redshift_gradient_layer, at: 0)
        
        NSLayoutConstraint.activate([
            popcard_container_panel.centerXAnchor.constraint(equalTo: dimscreen_backdrop_wrapper.centerXAnchor),
            popcard_container_panel.centerYAnchor.constraint(equalTo: dimscreen_backdrop_wrapper.centerYAnchor),
            popcard_container_panel.widthAnchor.constraint(equalToConstant: 300),
            
            warnemoji_icon_display.topAnchor.constraint(equalTo: popcard_container_panel.topAnchor, constant: 24),
            warnemoji_icon_display.centerXAnchor.constraint(equalTo: popcard_container_panel.centerXAnchor),
            
            heading_title_label.topAnchor.constraint(equalTo: warnemoji_icon_display.bottomAnchor, constant: 12),
            heading_title_label.leadingAnchor.constraint(equalTo: popcard_container_panel.leadingAnchor, constant: 20),
            heading_title_label.trailingAnchor.constraint(equalTo: popcard_container_panel.trailingAnchor, constant: -20),
            
            subtitle_desc_label.topAnchor.constraint(equalTo: heading_title_label.bottomAnchor, constant: 8),
            subtitle_desc_label.leadingAnchor.constraint(equalTo: popcard_container_panel.leadingAnchor, constant: 20),
            subtitle_desc_label.trailingAnchor.constraint(equalTo: popcard_container_panel.trailingAnchor, constant: -20),
            
            actionrow_button_stack.topAnchor.constraint(equalTo: subtitle_desc_label.bottomAnchor, constant: 24),
            actionrow_button_stack.leadingAnchor.constraint(equalTo: popcard_container_panel.leadingAnchor, constant: 20),
            actionrow_button_stack.trailingAnchor.constraint(equalTo: popcard_container_panel.trailingAnchor, constant: -20),
            actionrow_button_stack.heightAnchor.constraint(equalToConstant: 48),
            actionrow_button_stack.bottomAnchor.constraint(equalTo: popcard_container_panel.bottomAnchor, constant: -20)
        ])
        
        parentView.addSubview(dimscreen_backdrop_wrapper)
        
        popcard_container_panel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        popcard_container_panel.alpha = 0
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            frostlayer_blur_renderer.alpha = 1
            popcard_container_panel.transform = .identity
            popcard_container_panel.alpha = 1
        }
        
        dismiss_cancel_btn.addAction(UIAction { _ in
            UIView.animate(withDuration: 0.2) {
                popcard_container_panel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                popcard_container_panel.alpha = 0
                frostlayer_blur_renderer.alpha = 0
            } completion: { _ in
                dimscreen_backdrop_wrapper.removeFromSuperview()
            }
        }, for: .touchUpInside)
        
        proceed_confirm_btn.addAction(UIAction { _ in
            UIView.animate(withDuration: 0.2) {
                popcard_container_panel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                popcard_container_panel.alpha = 0
                frostlayer_blur_renderer.alpha = 0
            } completion: { _ in
                dimscreen_backdrop_wrapper.removeFromSuperview()
                onConfirm()
            }
        }, for: .touchUpInside)
        
        proceed_confirm_btn.layoutIfNeeded()
        redshift_gradient_layer.frame = proceed_confirm_btn.bounds
    }
}
