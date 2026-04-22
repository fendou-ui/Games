
import UIKit

class SmiroTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tabbar = UITabBarAppearance()
        tabbar.configureWithOpaqueBackground()
        tabbar.backgroundColor = .white// UIColor(red: 31/255, green: 32/255, blue: 50/255, alpha: 1)
        tabbar.shadowColor = .clear
        
        tabBar.standardAppearance = tabbar
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabbar
        }
        tabBar.tintColor = UIColor(red: 31/255, green: 32/255, blue: 50/255, alpha: 1)
        tabBar.unselectedItemTintColor = .gray
        
        setupUIAppTabbarController()
        
    }
    
    func setupUIAppTabbarController() {
        let chimi_home = UINavigationController(rootViewController: SmiroViewController())
        chimi_home.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tabbar_game")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "tabbar_game_s")?.withRenderingMode(.alwaysOriginal)
        )
        
        let chimi_find = UINavigationController(rootViewController: UIViewController())
        chimi_find.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tabbar_star")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "tabbar_star_s")?.withRenderingMode(.alwaysOriginal)
        )
        
        let chimi_mine = UINavigationController(rootViewController: UIViewController())
        chimi_mine.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tabbar_add")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "tabbar_add")?.withRenderingMode(.alwaysOriginal)
        )
        [chimi_home, chimi_find, chimi_mine].forEach {
            $0.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -12, right: 0)
            $0.navigationBar.setBackgroundImage(UIImage(), for: .default)
            $0.navigationBar.shadowImage = UIImage()
            $0.navigationBar.isTranslucent = true
        }
        self.viewControllers = [chimi_home, chimi_find, chimi_mine]
    }


}
