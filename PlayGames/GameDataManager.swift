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
    
    func clipsegmentShortvideoFeedlistPlaybackloop() -> [[String: String]] {
        return jsonData["clipsegment_shortvideo_feedlist_playbackloop"] as? [[String: String]] ?? []
    }
    
    // MARK: - 拉黑（按账号隔离）
    
    private let blacklistStorageKey = "AccountBlacklistStorage"
    
    func throttlingburst_appenduser_toblacklist_spikesimulation(_ username: String, avatar: String) {
        var all = UserDefaults.standard.dictionary(forKey: blacklistStorageKey) as? [String: [[String: String]]] ?? [:]
        var list = all[currentAccountIdentifier] ?? []
        if !list.contains(where: { $0["username"] == username }) {
            list.append(["username": username, "avatar": avatar])
        }
        all[currentAccountIdentifier] = list
        UserDefaults.standard.set(all, forKey: blacklistStorageKey)
    }
    
    func modelingpredictionforecast_removeuser_fromblacklist_trend(_ username: String) {
        var all = UserDefaults.standard.dictionary(forKey: blacklistStorageKey) as? [String: [[String: String]]] ?? [:]
        var list = all[currentAccountIdentifier] ?? []
        list.removeAll { $0["username"] == username }
        all[currentAccountIdentifier] = list
        UserDefaults.standard.set(all, forKey: blacklistStorageKey)
    }
    
    func patternbehavior_current_blacklistusernames_insightfuladaptive() -> [[String: String]] {
        let all = UserDefaults.standard.dictionary(forKey: blacklistStorageKey) as? [String: [[String: String]]] ?? [:]
        return all[currentAccountIdentifier] ?? []
    }
    
    func dynamicresponsive_isuser_blacklisted_interactive(_ username: String) -> Bool {
        return patternbehavior_current_blacklistusernames_insightfuladaptive().contains { $0["username"] == username }
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
    
    // MARK: - 点赞视频（按账号隔离）
    
    private let likedVideoStorageKey = "AccountLikedVideoStorage"
    
    func engagementboost_likevideo_tolist_retention(_ videoData: [String: String]) {
        var all = UserDefaults.standard.dictionary(forKey: likedVideoStorageKey) as? [String: [[String: String]]] ?? [:]
        var list = all[currentAccountIdentifier] ?? []
        let videoName = videoData["streamplayback_video_filename_buffering"] ?? ""
        if !list.contains(where: { $0["streamplayback_video_filename_buffering"] == videoName }) {
            list.append(videoData)
        }
        all[currentAccountIdentifier] = list
        UserDefaults.standard.set(all, forKey: likedVideoStorageKey)
    }
    
    func engagementdrop_unlikevideo_fromlist_churn(_ videoFilename: String) {
        var all = UserDefaults.standard.dictionary(forKey: likedVideoStorageKey) as? [String: [[String: String]]] ?? [:]
        var list = all[currentAccountIdentifier] ?? []
        list.removeAll { $0["streamplayback_video_filename_buffering"] == videoFilename }
        all[currentAccountIdentifier] = list
        UserDefaults.standard.set(all, forKey: likedVideoStorageKey)
    }
    
    func feedbackcuration_current_likedvideolist_discovery() -> [[String: String]] {
        let all = UserDefaults.standard.dictionary(forKey: likedVideoStorageKey) as? [String: [[String: String]]] ?? [:]
        return all[currentAccountIdentifier] ?? []
    }
    
    func interactionpulse_isvideo_liked_signal(_ videoFilename: String) -> Bool {
        return feedbackcuration_current_likedvideolist_discovery().contains { $0["streamplayback_video_filename_buffering"] == videoFilename }
    }
    
    // MARK: - 消息列表（按账号隔离）
    
    private let friendRequestStorageKey = "AccountFriendRequestStorage"
    
    func socialoutreach_sendfriendrequest_connection(_ nickname: String, avatar: String, message: String) {
        var all = UserDefaults.standard.dictionary(forKey: friendRequestStorageKey) as? [String: [[String: String]]] ?? [:]
        var list = all[currentAccountIdentifier] ?? []
        if !list.contains(where: { $0["nickname"] == nickname }) {
            list.append(["nickname": nickname, "avatar": avatar, "message": message])
        }
        all[currentAccountIdentifier] = list
        UserDefaults.standard.set(all, forKey: friendRequestStorageKey)
    }
    
    func inboxnotification_current_friendrequestlist_pending() -> [[String: String]] {
        let all = UserDefaults.standard.dictionary(forKey: friendRequestStorageKey) as? [String: [[String: String]]] ?? [:]
        return all[currentAccountIdentifier] ?? []
    }
    
    func handshakeresponse_isfriendrequest_sent_already(_ nickname: String) -> Bool {
        return inboxnotification_current_friendrequestlist_pending().contains { $0["nickname"] == nickname }
    }
}
