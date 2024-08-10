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
    
    func performRequest<DecodedType: Decodable, ErrorType: RawRepresentable & Error>(
        _ target: Target,
        errorType: ErrorType.Type,
        decodingHandler: (Data) throws -> DecodedType?
    ) async throws -> DecodedType? where ErrorType.RawValue == String {
        do {
            let response = try await request(target)
            switch response.statusCode {
            case 200:
                return try decodingHandler(response.data)
            case 400...500:
                let errorCode = try decode(response.data, as: ErrorCode.self)
                if let commonError = CommonError(rawValue: errorCode.errorCode) {
                    throw commonError
                } else if let specifiicError = ErrorType(rawValue: errorCode.errorCode) {
                    throw specifiicError
                }
            default: break
            }
        } catch {
            print("error", error)
            throw error
        }
        return nil
    }
    
    private func request(_ target: Target) async throws -> Response {
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
