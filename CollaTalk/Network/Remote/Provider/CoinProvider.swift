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
        do {
            let response = try await request(.fetchCoinItemList)
            switch response.statusCode {
            case 200:
                let coinItemList = try decode(response.data, as: [CoinItem].self)
                return coinItemList
            case 400...500:
                let errorCode = try decode(response.data, as: ErrorCode.self)
                if let commonError = CommonError(rawValue: errorCode.errorCode) {
                    throw commonError
                }
            default: break
            }
        } catch {
            throw error
        }
        
        return nil
    }
    
    func paymentValidation(impUid: String, merchantUid: String) async throws -> CoinValidationResult? {
        do {
            let paymentValidationRequest = PaymentValidationRequest(imp_uid: impUid, merchant_uid: merchantUid)
            let response = try await request(.paymentValidation(request: paymentValidationRequest))
            switch response.statusCode {
            case 200:
                let coinItemList = try decode(response.data, as: CoinValidationResult.self)
                return coinItemList
            case 400...500:
                let errorCode = try decode(response.data, as: ErrorCode.self)
                if let commonError = CommonError(rawValue: errorCode.errorCode) {
                    throw commonError
                } else if let paymentValidationError = PaymentValidationError(rawValue: errorCode.errorCode) {
                    throw paymentValidationError
                }
            default: break
            }
        } catch {
            throw error
        }
        
        return nil
    }

}
