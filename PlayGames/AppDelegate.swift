
import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 键盘管理 - 全局生效
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true  // 点击空白收起键盘
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = SmiroTabBarController()
//        window?.rootViewController = UINavigationController(rootViewController: LoginAndRegisterVC())
        window?.makeKeyAndVisible()
        return true
    }


}
