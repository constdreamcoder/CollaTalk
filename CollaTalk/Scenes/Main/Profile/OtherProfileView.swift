//
//  OtherProfileView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/5/24.
//

import SwiftUI

struct OtherProfileView: View {
    
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var navigationRouter: NavigationRouter
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack {
                NavigationFrameView(
                    title: "프로필",
                    leftButtonAction: {
                        navigationRouter.pop()
                    }
                )
                
                Spacer()
                    .frame(height: 24)
                
                RemoteImage(
                    path: store.state.otherProfileState.otherProfile?.profileImage,
                    imageView: { image in
                        image
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 232)
                            .background(.brandGreen)
                            .cornerRadius(8, corners: .allCorners)
                    },
                    placeHolderView: {
                        Image(.kakaoLogo)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 232)
                            .background(.brandGreen)
                            .cornerRadius(8, corners: .allCorners)
                    },
                    errorView: { error in
                        Image(.kakaoLogo)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 232)
                            .background(.brandGreen)
                            .cornerRadius(8, corners: .allCorners)
                    }
                )
                
                List {
                    Section {
                        OtherProfileContentSecondSectionCell(
                            cellType: .nickname,
                            value: store.state.otherProfileState.otherProfile?.nickname ?? ""
                        )
                        
                        OtherProfileContentSecondSectionCell(
                            cellType: .email,
                            value: store.state.otherProfileState.otherProfile?.email ?? ""
                        )
                    }
                    .listRowSeparator(.hidden)
                }
                .scrollDisabled(true)
                
                
                Spacer()
            }
        }
    }
}

#Preview {
    OtherProfileView()
}


struct OtherProfileContentSecondSectionCell: View {
    
    enum CellType {
        case nickname
        case email
        
        var title: String {
            switch self {
            case .nickname:
                return "닉네임"
            case .email:
                return "이메일"
            }
        }
    }
    
    let cellType: CellType
    let value: String
    
    init(
        cellType: CellType,
        value: String
    ) {
        self.cellType = cellType
        self.value = value
    }
    
    var body: some View {
        HStack {
            Text(cellType.title)
                .font(.bodyBold)
                .foregroundStyle(.textPrimary)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .foregroundStyle(.textSecondary)
        }
    }
}

