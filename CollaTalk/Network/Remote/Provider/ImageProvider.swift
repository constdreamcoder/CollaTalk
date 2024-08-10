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
        return try await performRequest(.downloadImage(path: path), errorType: CommonError.self) { data in
            return data
        }
    }
}
