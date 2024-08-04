//
//  CoinValidationResult.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/5/24.
//

import Foundation

struct CoinValidationResult: Decodable {
    let billingId: String
    let merchantUid: String
    let buyerId: String
    let productName: String
    let price: Int
    let sesacCoin: Int
    let paidAt: String
    
    enum CodingKeys: String, CodingKey {
        case billingId = "billing_id"
        case merchantUid = "merchant_uid"
        case buyerId = "buyer_id"
        case productName
        case price
        case sesacCoin
        case paidAt
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.billingId = try container.decode(String.self, forKey: .billingId)
        self.merchantUid = try container.decode(String.self, forKey: .merchantUid)
        self.buyerId = try container.decode(String.self, forKey: .buyerId)
        self.productName = try container.decode(String.self, forKey: .productName)
        self.price = try container.decode(Int.self, forKey: .price)
        self.sesacCoin = try container.decode(Int.self, forKey: .sesacCoin)
        self.paidAt = try container.decode(String.self, forKey: .paidAt)
    }
}
