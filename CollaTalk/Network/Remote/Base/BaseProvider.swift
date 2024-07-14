//
//  BaseProvider.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/8/24.
//

import Foundation
import Moya

class BaseProvider<Target: TargetType> {
    private let provider: MoyaProvider<Target>
    
    init() {
        provider = MoyaProvider<Target>(plugins: [LoggerPlugin()])
    }
    
    func request(_ target: Target) async throws -> Response {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func decode<D: Decodable>(_ data: Data, as type: D.Type) throws -> D {
        let decoder = JSONDecoder()
        return try decoder.decode(D.self, from: data)
    }
}
