
import Foundation
import Alamofire

enum RequestError: Error {
    case unknown(String)
}

let aiUrl = "https://isbvajms.tcqyhxy.top/api"
let gawebPravicy = ""
let gawebService = ""

class GaSokRequest {
    
    static let request = GaSokRequest()
    
    func postRequest( linkUrl: String,
                       dict: [String: Any] = [:],
                       completeHandler: @escaping (Result<Any, RequestError>) -> Void) {
        
        var urlString = "\(aiUrl)\(linkUrl)"
        
        let sign = UserDefaults.standard.object(forKey: "onlyOne") ?? "NO"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(sign)",
            "Content-Type": "application/json",
            "userType": "app_user",
            "content-language": "zh_CN"
        ]
        
        var parameters: [String: Any] = dict
        parameters["systemType"] = "8"
        
        
        AF.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let data):
                do {
                    let avatars = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    let lines = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("temp.json")
                    
                    try avatars.write(to: lines)
                    
                    if let jsonString = try? String(contentsOf: lines) {
                        print("——————\(linkUrl)传入：\(parameters)")
                        print("——————\(linkUrl)返回：\(jsonString)")
                        completeHandler(.success(data))
                    } else {
                        completeHandler(.failure(.unknown("无法读取 JSON 数据")))
                    }
                    try FileManager.default.removeItem(at: lines)
                } catch {
                    completeHandler(.failure(.unknown("转换为 JSON 数据时出错：\(error)")))
                    
                }
            case .failure(let error):
                completeHandler(.failure(.unknown(error.localizedDescription)))
            }
        }
    }
    
}
