//
//  RemoteImageService.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/16/24.
//

import UIKit
import SwiftUI

/// `RemoteImage` 를 위한 이미지 다운로드, 캐싱 Service
final class RemoteImageService: ObservableObject {

    enum RemoteImageServiceError: Error {
        case failToFetchImage
    }
    
    private let cacheManager = ImageCacheManager.shared
    private let router = ImageProvider.shared
    
    @Published var state: RemoteImageState = .loading
    
    func fetchImage(with path: String?) async {
        guard let path else {
            state = .error(DownloadImageError.invalidURL)
            return
        }
        
        let url = URL(string: "\(APIKeys.baseURL)\(path)")!
        if let cachedImage = cacheManager.get(for: url) {
            state = .image(cachedImage)
            return
        }
        
        do {
            let imageData = try await router.downloadImage(with: path)
            guard let imageData else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                let image = UIImage(data: imageData)
                if let image {
                    cacheManager.store(image, for: url)
                    state = .image(image)
                } else {
                    state = .error(RemoteImageServiceError.failToFetchImage)
                }
            }
        } catch {
            print("Download Image Error", error)
            state = .error(error)
        }
    }
}
