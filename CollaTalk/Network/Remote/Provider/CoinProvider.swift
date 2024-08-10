//
//  CoinProvider.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/4/24.
//

import Foundation

final class CoinProvider: BaseProvider<CoinService> {
    
    static let shared = CoinProvider()
    
    private override init() {}
    
    func fetchMyProfile() async throws -> [CoinItem]? {
        return try await performRequest(.fetchCoinItemList, errorType: CommonError.self) { data in
            return try decode(data, as: [CoinItem].self)
        }
    }
    
    func paymentValidation(impUid: String, merchantUid: String) async throws -> CoinValidationResult? {
        let paymentValidationRequest = PaymentValidationRequest(imp_uid: impUid, merchant_uid: merchantUid)
        return try await performRequest(.paymentValidation(request: paymentValidationRequest), errorType: PaymentValidationError.self) { data in
            return try decode(data, as: CoinValidationResult.self)
        }
    }
}
