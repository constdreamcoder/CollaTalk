//
//  ImageProvider.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/16/24.
//

import Foundation

final class ImageProvider: BaseProvider<ImageService> {
    
    static let shared = ImageProvider()
    
    private override init() {}
    
    func downloadImage(with path: String) async throws -> Data? {
        do {
            let response = try await request(.downloadImage(path: path))
            switch response.statusCode {
            case 200:
                return response.data
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
}
