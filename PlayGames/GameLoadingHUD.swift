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
}
