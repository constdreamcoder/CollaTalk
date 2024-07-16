//
//  RemoteImage.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/16/24.
//

import UIKit
import SwiftUI

enum RemoteImageState {
    case error(_ error: Error)
    case image(_ image: UIImage)
    case loading
}

struct RemoteImage<
    ImageView: View,
    PlaceHolderView: View,
    ErrorView: View
>: View {
    
    private let path: String?
    private let errorView: (Error) -> ErrorView?
    private let imageView: (Image) -> ImageView
    private let placeHolderView: () -> PlaceHolderView?
    
    @StateObject private var service = RemoteImageService()

    init(
        path: String?,
        @ViewBuilder imageView: @escaping (Image) -> ImageView,
        @ViewBuilder placeHolderView: @escaping () -> PlaceHolderView? = {
            ProgressView()
                .progressViewStyle(.circular)
        },
        @ViewBuilder errorView: @escaping (Error) -> ErrorView? = { _ in
            Text("이미지 로딩 실패")
        }
    ) {
        self.path = path
        self.errorView = errorView
        self.imageView = imageView
        self.placeHolderView = placeHolderView
    }
        
    var body: some View {
        switch service.state {
        case .error(let error):
                errorView(error)
            
        case .image(let image):
            imageView(Image(uiImage: image))
            
        case .loading:
            placeHolderView()
                .task {
                    // 이미지 다운로드/캐시
                    await service.fetchImage(with: path)
                }
        }
    }
}
