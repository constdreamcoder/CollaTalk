//
//  ImageLayoutView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/11/24.
//

import SwiftUI

struct ImageLayoutView: View {
    let files: [String]
    
    var body: some View {
        switch files.count {
        case 1:
            OneImageView(file: files)
        case 2:
            TwoImagesView(files: files)
        case 3:
            ThreeImagesView(files: files)
        case 4:
            FourImagesView(
                firstRowFiles: Array(files[0...1]),
                secondRowFiles: Array(files[2...3])
            )
        case 5:
            FiveImagesView(
                firstRowFiles: Array(files[0...2]),
                secondRowFiles: Array(files[3...4])
            )
        default:
            EmptyView()
        }
    }
}

struct OneImageView: View {
    
    let file: [String]
    
    var body: some View {
        
        RemoteImage(
            path: file[0],
            imageView: { image in
                image
                    .resizable()
            },
            placeHolderView: {
                Rectangle()
                    .foregroundStyle(.brandGreen)
            },
            errorView: { error in
                Rectangle()
                    .foregroundStyle(.brandGreen)
            }
        )
        .cornerRadius(4, corners: .allCorners)
        .aspectRatio(244/160, contentMode: .fit)
    }
}

struct TwoImagesView: View {
    
    let files: [String]
    
    let contents: [GridItem] = Array(
        repeating: .init(.flexible(), spacing: 2),
        count: 2
    )
    
    var body: some View {
        LazyVGrid(columns: contents) {
            ForEach(files, id: \.self) { file in
                RemoteImage(
                    path: file,
                    imageView: { image in
                        image
                            .resizable()
                    },
                    placeHolderView: {
                        Rectangle()
                            .foregroundStyle(.brandGreen)
                    },
                    errorView: { error in
                        Rectangle()
                            .foregroundStyle(.brandGreen)
                    }
                )
                .cornerRadius(4, corners: .allCorners)
                .aspectRatio(3/2, contentMode: .fit)
            }
        }
    }
}

struct ThreeImagesView: View {
    
    let files: [String]
    
    let contents: [GridItem] = Array(
        repeating: .init(.flexible(), spacing: 2),
        count: 3
    )
    
    var body: some View {
        LazyVGrid(columns: contents) {
            ForEach(files, id: \.self) { file in
                RemoteImage(
                    path: file,
                    imageView: { image in
                        image
                            .resizable()
                    },
                    placeHolderView: {
                        Rectangle()
                            .foregroundStyle(.brandGreen)
                    },
                    errorView: { error in
                        Rectangle()
                            .foregroundStyle(.brandGreen)
                    }
                )
                .cornerRadius(4, corners: .allCorners)
                .aspectRatio(1, contentMode: .fit)
            }
        }
    }
}

struct FourImagesView: View {
    
    let firstRowFiles: [String]
    let secondRowFiles: [String]
    
    var body: some View {
        VStack(spacing: 2) {
            TwoImagesView(files: firstRowFiles)
            
            TwoImagesView(files: secondRowFiles)
        }
    }
}


struct FiveImagesView: View {
    
    let firstRowFiles: [String]
    let secondRowFiles: [String]
    
    var body: some View {
        VStack(spacing: 2) {
            ThreeImagesView(files: firstRowFiles)
            
            TwoImagesView(files: secondRowFiles)
        }
    }
}
