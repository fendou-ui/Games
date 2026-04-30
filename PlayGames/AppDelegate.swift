
import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 键盘管理 - 全局生效
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true  // 点击空白收起键盘
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                if purchase.transaction.transactionState == .purchased || purchase.transaction.transactionState == .restored {
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                }
            }
        }
        
        setupTestAccountData()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if let account = UserDefaults.standard.string(forKey: "CurrentLoggedInAccount"), !account.isEmpty {
            window?.rootViewController = SmiroTabBarController()
        } else {
            window?.rootViewController = UINavigationController(rootViewController: LoginAndRegisterVC())
        }
        window?.makeKeyAndVisible()
        return true
    }
    
    func setupTestAccountData() {
        var accounts = UserDefaults.standard.dictionary(forKey: "GameRegisteredAccounts") as? [String: String] ?? [:]
        if accounts["game123@gmail.com"] == nil {
            accounts["game123@gmail.com"] = "123456"
            UserDefaults.standard.set(accounts, forKey: "GameRegisteredAccounts")
        }
        
        let profileKey = "AccountUserProfileStorage_game123@gmail.com"
        if UserDefaults.standard.dictionary(forKey: profileKey) == nil {
            let profile: [String: String] = [
                "processhandler_profile_nickname_manager": "game123",
                "controllerserviceprovider_profile_avatarimage_adapter": "sdbfjewb_ejhrf",
                "factory_profile_fanstotal_buildergeneratorresolver": "58",
                "coordinatordispatcher_profile_followingtotal_scheduler": "12",
                "executor_wallet_coinsbalance_observerlistenerdelegate": "500"
            ]
            UserDefaults.standard.set(profile, forKey: profileKey)
        }
        
        let friendsKey = "AccountFriendsListStorage_game123@gmail.com"
        if UserDefaults.standard.array(forKey: friendsKey) == nil {
            let friends: [[String: String]] = [
                ["nickname": "StarPlayer", "avatar": "frostblade_portrait"],
                ["nickname": "NightWolf", "avatar": "stormcaller_portrait"]
            ]
            UserDefaults.standard.set(friends, forKey: friendsKey)
        }
        
        let fansKey = "AccountFansListStorage"
        var allFans = UserDefaults.standard.dictionary(forKey: fansKey) as? [String: [[String: String]]] ?? [:]
        if allFans["game123@gmail.com"] == nil {
            allFans["game123@gmail.com"] = [
                ["nickname": "GamerKing", "avatar": "blazerunner_portrait"],
                ["nickname": "ShadowHunter", "avatar": "duskwarden_portrait"]
            ]
            UserDefaults.standard.set(allFans, forKey: fansKey)
        }
        
        let chatStorageKey = "AccountChatRecordStorage"
        var allChats = UserDefaults.standard.dictionary(forKey: chatStorageKey) as? [String: [[String: String]]] ?? [:]
        let starKey = "game123@gmail.com_StarPlayer"
        if allChats[starKey] == nil {
            allChats[starKey] = [["text": "Hey, wanna play ranked together tonight?", "sender": "friend"]]
        }
        let nightKey = "game123@gmail.com_NightWolf"
        if allChats[nightKey] == nil {
            allChats[nightKey] = [["text": "GG! That last match was insane 🔥", "sender": "friend"]]
        }
        UserDefaults.standard.set(allChats, forKey: chatStorageKey)
    }


}
