//
//  ChangeOwnerViewCellFrame.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/31/24.
//

import SwiftUI

struct ChangeOwnerViewCellFrame: View {
    
    let profileImage: String?
    let nickname: String
    let email: String
    
    var body: some View {
        HStack(spacing: 8) {
            
            RemoteImage(
                path: profileImage,
                imageView: { image in
                    image
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 44)
                        .background(.brandGreen)
                        .cornerRadius(8, corners: .allCorners)
                },
                placeHolderView: {
                    Image(.kakaoLogo)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 44)
                        .background(.brandGreen)
                        .cornerRadius(8, corners: .allCorners)
                }
            )
            
            VStack {
                Text(nickname)
                    .font(.bodyBold)
                    .foregroundStyle(.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                
                Text(email)
                    .font(.body)
                    .foregroundStyle(.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
            }
        }
    }
}
