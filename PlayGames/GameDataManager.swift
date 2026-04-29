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
    
    // MARK: - 个人资料（按账号隔离）
    
    func dashboardsnapshot_save_userprofile(_ profile: [String: String]) {
        let key = "AccountUserProfileStorage_\(currentAccountIdentifier)"
        UserDefaults.standard.set(profile, forKey: key)
    }
    
    func dashboardsnapshot_load_userprofile() -> [String: String] {
        let key = "AccountUserProfileStorage_\(currentAccountIdentifier)"
        if let profile = UserDefaults.standard.dictionary(forKey: key) as? [String: String] {
            return profile
        }
        return cachingbufferCurrentUserprofilePipelineworkflow()
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
    
    // MARK: - 点赞动态（按账号隔离）
    
    private let likedPostStorageKey = "AccountLikedPostStorage"
    
    func communityheartbeat_likepost_tolist_engagement(_ postData: [String: String]) {
        var all = UserDefaults.standard.dictionary(forKey: likedPostStorageKey) as? [String: [[String: String]]] ?? [:]
        var list = all[currentAccountIdentifier] ?? []
        let publisher = postData["replayranking_publisher_displayname_leaderboard"] ?? ""
        let content = postData["multiplayer_post_textcontent_cooperative"] ?? ""
        if !list.contains(where: { $0["replayranking_publisher_displayname_leaderboard"] == publisher && $0["multiplayer_post_textcontent_cooperative"] == content }) {
            list.append(postData)
        }
        all[currentAccountIdentifier] = list
        UserDefaults.standard.set(all, forKey: likedPostStorageKey)
    }
    
    func communitydownvote_unlikepost_fromlist_disengage(_ publisher: String, content: String) {
        var all = UserDefaults.standard.dictionary(forKey: likedPostStorageKey) as? [String: [[String: String]]] ?? [:]
        var list = all[currentAccountIdentifier] ?? []
        list.removeAll { $0["replayranking_publisher_displayname_leaderboard"] == publisher && $0["multiplayer_post_textcontent_cooperative"] == content }
        all[currentAccountIdentifier] = list
        UserDefaults.standard.set(all, forKey: likedPostStorageKey)
    }
    
    func feedreaction_current_likedpostlist_trending() -> [[String: String]] {
        let all = UserDefaults.standard.dictionary(forKey: likedPostStorageKey) as? [String: [[String: String]]] ?? [:]
        return all[currentAccountIdentifier] ?? []
    }
    
    func socialvalidation_ispost_liked_confirmation(_ publisher: String, content: String) -> Bool {
        return feedreaction_current_likedpostlist_trending().contains { $0["replayranking_publisher_displayname_leaderboard"] == publisher && $0["multiplayer_post_textcontent_cooperative"] == content }
    }
    
    // MARK: - 聊天记录（按账号+聊天对象隔离）
    
    private let chatRecordStorageKey = "AccountChatRecordStorage"
    
    func dialoguetranscript_sendmessage_tochat(_ targetNickname: String, text: String) {
        let chatKey = "\(currentAccountIdentifier)_\(targetNickname)"
        var all = UserDefaults.standard.dictionary(forKey: chatRecordStorageKey) as? [String: [[String: String]]] ?? [:]
        var list = all[chatKey] ?? []
        list.append(["text": text, "sender": "me"])
        all[chatKey] = list
        UserDefaults.standard.set(all, forKey: chatRecordStorageKey)
    }
    
    func conversationhistory_current_chatrecords_retrieve(_ targetNickname: String) -> [[String: String]] {
        let chatKey = "\(currentAccountIdentifier)_\(targetNickname)"
        let all = UserDefaults.standard.dictionary(forKey: chatRecordStorageKey) as? [String: [[String: String]]] ?? [:]
        return all[chatKey] ?? []
    }
    
    // MARK: - 好友列表（按账号隔离）
    
    func rosterconnection_current_friendslist_retrieve() -> [[String: String]] {
        let key = "AccountFriendsListStorage_\(currentAccountIdentifier)"
        return UserDefaults.standard.array(forKey: key) as? [[String: String]] ?? []
    }
    
    func rosterconnection_save_friendslist(_ list: [[String: String]]) {
        let key = "AccountFriendsListStorage_\(currentAccountIdentifier)"
        UserDefaults.standard.set(list, forKey: key)
    }
    
    // MARK: - 视频评论（按账号+视频隔离）
    
    private let videoCommentStorageKey = "AccountVideoCommentStorage"
    
    func threadreply_postcomment_tovideo(_ videoFilename: String, text: String) {
        let profile = dashboardsnapshot_load_userprofile()
        let nickname = profile["processhandler_profile_nickname_manager"] ?? "Me"
        let commentKey = "\(currentAccountIdentifier)_\(videoFilename)"
        var all = UserDefaults.standard.dictionary(forKey: videoCommentStorageKey) as? [String: [[String: String]]] ?? [:]
        var list = all[commentKey] ?? []
        list.append(["nickname": nickname, "text": text, "sender": "me"])
        all[commentKey] = list
        UserDefaults.standard.set(all, forKey: videoCommentStorageKey)
    }
    
    func threadhistory_videocomments_retrieve(_ videoFilename: String) -> [[String: String]] {
        let commentKey = "\(currentAccountIdentifier)_\(videoFilename)"
        let all = UserDefaults.standard.dictionary(forKey: videoCommentStorageKey) as? [String: [[String: String]]] ?? [:]
        return all[commentKey] ?? []
    }
    
    func threadremove_deletecomment_fromvideo(_ videoFilename: String, at index: Int) {
        let commentKey = "\(currentAccountIdentifier)_\(videoFilename)"
        var all = UserDefaults.standard.dictionary(forKey: videoCommentStorageKey) as? [String: [[String: String]]] ?? [:]
        var list = all[commentKey] ?? []
        guard index < list.count else { return }
        list.remove(at: index)
        all[commentKey] = list
        UserDefaults.standard.set(all, forKey: videoCommentStorageKey)
    }
}
