
import UIKit

import Foundation


public class FXKCreateBlazerunner: BXAStrikeMoments {
var chats_offset: Double? = 0.0
var inputSpace: Double? = 0.0
private var profileMax: Float? = 0.0




	public enum ODJebdfertaEvent9: String {
		case ODRoom = "https://buy.itunes.apple.com/verifyReceipt"
		case ODCreate = "https://sandbox.itunes.apple.com/verifyReceipt"
	}

    
    
    public var service: ODJebdfertaEvent9

    private let sharedSecret: String?

     
    public init(service: ODJebdfertaEvent9 = .ODRoom, sharedSecret: String? = nil) {
		self.service = service
        self.sharedSecret = sharedSecret
	}

@discardableResult
 func resumeSendCompactBonusDiscount(inflightGaweb: String!) -> String! {
    var headinge: Bool = false
   withUnsafeMutablePointer(to: &headinge) { pointer in
    
   }
    var rechargem: Double = 4.0
    var requestsF: String! = String(cString: [109,115,112,101,108,0], encoding: .utf8)!
      requestsF = "\(((String(cString:[110,0], encoding: .utf8)!) == requestsF ? requestsF.count : (headinge ? 2 : 2)))"
   repeat {
      requestsF.append("\(2)")
      if requestsF.count == 3723631 {
         break
      }
   } while (3 < (1 | requestsF.count) || (1 - Int(rechargem > 373155690.0 || rechargem < -373155690.0 ? 53.0 : rechargem)) < 1) && (requestsF.count == 3723631)
   while (headinge) {
       var inflightk: String! = String(cString: [100,111,117,98,108,101,0], encoding: .utf8)!
       var momenty: String! = String(cString: [98,102,114,97,109,101,115,0], encoding: .utf8)!
       var handlers0: [Any]! = [9, 79]
       _ = handlers0
      repeat {
          var postsz: Bool = false
         handlers0.append(1)
         if handlers0.count == 87377 {
            break
         }
      } while (handlers0.count == 87377) && ((inflightk.count - 2) >= 4)
      if 3 > inflightk.count {
          var frostlayerh: Double = 3.0
          _ = frostlayerh
          var confirmg: String! = String(cString: [115,101,97,108,97,110,116,0], encoding: .utf8)!
          _ = confirmg
         momenty = "\(1 + confirmg.count)"
         frostlayerh -= (Double(Int(frostlayerh > 77255969.0 || frostlayerh < -77255969.0 ? 90.0 : frostlayerh) >> (Swift.min(confirmg.count, 2))))
      }
         momenty = "\(3 >> (Swift.min(1, handlers0.count)))"
         momenty = "\(inflightk.count * 2)"
      for _ in 0 ..< 2 {
         momenty = "\(3 * inflightk.count)"
      }
      repeat {
          var cell_: String! = String(cString: [102,97,99,116,111,114,105,122,97,116,105,111,110,0], encoding: .utf8)!
         withUnsafeMutablePointer(to: &cell_) { pointer in
                _ = pointer.pointee
         }
          var stringj: Double = 5.0
          var furyr: String! = String(cString: [119,114,97,112,112,101,100,0], encoding: .utf8)!
         withUnsafeMutablePointer(to: &furyr) { pointer in
    
         }
         inflightk = "\(furyr.count)"
         cell_ = "\(((String(cString:[54,0], encoding: .utf8)!) == momenty ? inflightk.count : momenty.count))"
         stringj -= Double(1)
         if inflightk.count == 272809 {
            break
         }
      } while (inflightk.count == 2) && (inflightk.count == 272809)
       var performt: String! = String(cString: [115,122,97,98,111,115,0], encoding: .utf8)!
       var blurv: Double = 5.0
       _ = blurv
          var emberC: String! = String(cString: [115,117,98,109,111,100,117,108,101,0], encoding: .utf8)!
          var lounge2: String! = String(cString: [97,114,101,97,115,0], encoding: .utf8)!
          var queryU: Double = 2.0
         blurv += (Double(Int(queryU > 364268921.0 || queryU < -364268921.0 ? 63.0 : queryU) * 1))
         emberC.append("\((Int(blurv > 362251131.0 || blurv < -362251131.0 ? 63.0 : blurv) >> (Swift.min(labs(1), 5))))")
         lounge2 = "\(emberC.count)"
         performt = "\(momenty.count ^ 3)"
      rechargem -= (Double(Int(rechargem > 10414918.0 || rechargem < -10414918.0 ? 4.0 : rechargem)))
      break
   }
   return requestsF

}





	public func validate(receiptData: Data, completion: @escaping (CZoneBattleW) -> Void) {

         var initializeYuvpc: String! = resumeSendCompactBonusDiscount(inflightGaweb:String(cString: [101,118,97,108,117,97,116,111,114,0], encoding: .utf8)!)

      let initializeYuvpc_len = initializeYuvpc?.count ?? 0
      print(initializeYuvpc)

withUnsafeMutablePointer(to: &initializeYuvpc) { pointer in
        _ = pointer.pointee
}


       var quantityF: String! = String(cString: [99,111,108,111,114,115,0], encoding: .utf8)!
      quantityF = "\(quantityF.count / (Swift.max(2, 5)))"


		let last = URL(string: service.rawValue)! 
		let give = NSMutableURLRequest(url: last)
		give.httpMethod = "POST"

        let stringm = receiptData.base64EncodedString(options: [])
		let cell: NSMutableDictionary = [ "receipt-data": stringm ]
		
		if let password = sharedSecret {
			cell.setValue(password, forKey: "password")
		}

		
		do {
			give.httpBody = try JSONSerialization.data(withJSONObject: cell, options: [])
		} catch let e {
			completion(.error(error: .requestBodyEncodeError(error: e)))
			return
		}

		
		let pixel = URLSession.shared.dataTask(with: give as URLRequest) { data, _, error -> Void in

			
			if let networkError = error {
				completion(.error(error: .networkError(error: networkError)))
				return
			}

			
			guard let safeData = data else {
				completion(.error(error: .noRemoteData))
				return
			}

			
			guard let receiptInfo = try? JSONSerialization.jsonObject(with: safeData, options: .mutableLeaves) as? ReceiptInfo ?? [:] else {
				let message = String(data: safeData, encoding: String.Encoding.utf8)
				completion(.error(error: .jsonDecodeError(string: message)))
				return
			}

			
			if let status = receiptInfo["status"] as? Int {
				 
				let desc = CSkinE(rawValue: status) ?? CSkinE.unknown
				if case .CPurchases = desc {
                    self.service = .ODCreate
                    self.validate(receiptData: receiptData, completion: completion)
				} else {
					if desc.isValid {
						completion(.success(receipt: receiptInfo))
					} else {
						completion(.error(error: .receiptInvalid(receipt: receiptInfo, status: desc)))
					}
				}
			} else {
				completion(.error(error: .receiptInvalid(receipt: receiptInfo, status: CSkinE.none)))
			}
		}
		pixel.resume()
	}
}
