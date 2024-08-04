//
//  PaymentValidationRequest.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/5/24.
//

import Foundation

struct PaymentValidationRequest: Encodable {
    let imp_uid: String
    let merchant_uid: String
}
