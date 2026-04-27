import Foundation
import UIKit

class GameDataManager {
    
    static let shared = GameDataManager()
    
    private var jsonData: [String: Any] = [:]
    
    var currentAccountIdentifier: String {
        return UserDefaults.standard.string(forKey: "CurrentLoggedInAccount") ?? "unknown"
    }
    
    var coordinatordispatcherKeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first
    }
    
    private init() {
        loadLocalJSON()
    }
    
    private func loadLocalJSON() {
        guard let path = Bundle.main.path(forResource: "GameLocalData", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return
        }
        jsonData = json
    }
    
    func streamoverlayDiscoverPostlistEngagement() -> [[String: String]] {
        return jsonData["streamoverlay_discover_postlist_engagement"] as? [[String: String]] ?? []
    }
    
    func identitysubscriptionDiscoverCommentslistDonationrewardcurrency() -> [[String: String]] {
        return jsonData["identitysubscription_discover_commentslist_donationrewardcurrency"] as? [[String: String]] ?? []
    }
    
    func filtersafetysecurityCenterMessagelistReport() -> [[String: String]] {
        return jsonData["filtersafetysecurity_center_messagelist_report"] as? [[String: String]] ?? []
    }
    
    func blockmutediscoverFriendsChatrecordsExploretrendingpopular() -> [[String: String]] {
        return jsonData["blockmutediscover_friends_chatrecords_exploretrendingpopular"] as? [[String: String]] ?? []
    }
    
    func personalizedanalyticsmetricsPendingFriendrequestInsight() -> [[String: String]] {
        return jsonData["personalizedanalyticsmetrics_pending_friendrequest_insight"] as? [[String: String]] ?? []
    }
    
    func renderingplaybacktimelineFollowingBlacklistusersSchedule() -> [[String: String]] {
        return jsonData["renderingplaybacktimeline_following_blacklistusers_schedule"] as? [[String: String]] ?? []
    }
    
    func seriescontentOnlineChatroomlistCreatorinfluencer() -> [[String: Any]] {
        return jsonData["seriescontent_online_chatroomlist_creatorinfluencer"] as? [[String: Any]] ?? []
    }
    
    func deploymentintegrationconfigurationChatroomLivemessagesInitialization() -> [[String: String]] {
        return jsonData["deploymentintegrationconfiguration_chatroom_livemessages_initialization"] as? [[String: String]] ?? []
    }
    
    func transmissionconnectionWalletRechargeoptionsReconnectionauthentication() -> [[String: String]] {
        return jsonData["transmissionconnection_wallet_rechargeoptions_reconnectionauthentication"] as? [[String: String]] ?? []
    }
    
    func scalabilityavailabilitySettingsMenuitemsReliabilitystability() -> [[String: String]] {
        return jsonData["scalabilityavailability_settings_menuitems_reliabilitystability"] as? [[String: String]] ?? []
    }
    
    func cachingbufferCurrentUserprofilePipelineworkflow() -> [String: String] {
        return jsonData["cachingbuffer_current_userprofile_pipelineworkflow"] as? [String: String] ?? [:]
    }
    
    // MARK: - 拉黑（按账号隔离）
    
    private let blacklistStorageKey = "AccountBlacklistStorage"
    
    func throttlingburst_appenduser_toblacklist_spikesimulation(_ username: String) {
        var all = UserDefaults.standard.dictionary(forKey: blacklistStorageKey) as? [String: [String]] ?? [:]
        var list = all[currentAccountIdentifier] ?? []
        if !list.contains(username) {
            list.append(username)
        }
        all[currentAccountIdentifier] = list
        UserDefaults.standard.set(all, forKey: blacklistStorageKey)
    }
    
    func modelingpredictionforecast_removeuser_fromblacklist_trend(_ username: String) {
        var all = UserDefaults.standard.dictionary(forKey: blacklistStorageKey) as? [String: [String]] ?? [:]
        var list = all[currentAccountIdentifier] ?? []
        list.removeAll { $0 == username }
        all[currentAccountIdentifier] = list
        UserDefaults.standard.set(all, forKey: blacklistStorageKey)
    }
    
    func patternbehavior_current_blacklistusernames_insightfuladaptive() -> [String] {
        let all = UserDefaults.standard.dictionary(forKey: blacklistStorageKey) as? [String: [String]] ?? [:]
        return all[currentAccountIdentifier] ?? []
    }
    
    func dynamicresponsive_isuser_blacklisted_interactive(_ username: String) -> Bool {
        return patternbehavior_current_blacklistusernames_insightfuladaptive().contains(username)
    }
    
    // MARK: - 关注（按账号隔离）
    
    private let followingStorageKey = "AccountFollowingStorage"
    
    func immersiveintuitive_follow_targetuser_seamless(_ username: String) {
        var all = UserDefaults.standard.dictionary(forKey: followingStorageKey) as? [String: [String]] ?? [:]
        var list = all[currentAccountIdentifier] ?? []
        if !list.contains(username) {
            list.append(username)
        }
        all[currentAccountIdentifier] = list
        UserDefaults.standard.set(all, forKey: followingStorageKey)
    }
    
    func efficientrobust_unfollow_targetuser_scalableflexible(_ username: String) {
        var all = UserDefaults.standard.dictionary(forKey: followingStorageKey) as? [String: [String]] ?? [:]
        var list = all[currentAccountIdentifier] ?? []
        list.removeAll { $0 == username }
        all[currentAccountIdentifier] = list
        UserDefaults.standard.set(all, forKey: followingStorageKey)
    }
    
    func extensiblemaintainable_current_followingusernames_readable() -> [String] {
        let all = UserDefaults.standard.dictionary(forKey: followingStorageKey) as? [String: [String]] ?? [:]
        return all[currentAccountIdentifier] ?? []
    }
    
    func optimizedsecure_isfollowing_user_reliable(_ username: String) -> Bool {
        return extensiblemaintainable_current_followingusernames_readable().contains(username)
    }
}
