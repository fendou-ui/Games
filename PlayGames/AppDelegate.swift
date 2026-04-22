
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = SmiroTabBarController()
        //UINavigationController(rootViewController: SmiroViewController())//LoginAndRegisterVC())
        window?.makeKeyAndVisible()
        return true
    }


}

