//
//  EditProfileView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/3/24.
//

import SwiftUI

struct EditProfileView: View {
    
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var navigationRouter: NavigationRouter
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack {
                NavigationFrameView(
                    title: "내 정보 수정",
                    leftButtonAction: {
                        navigationRouter.pop()
                    }
                )
                
                Spacer()
                    .frame(height: 24)
                
                
                RemoteImage(
                    path: store.state.myProfileState.myProfile?.profileImage,
                    imageView: { image in
                        image
                            .resizable()
                            .aspectRatio(1.0, contentMode: .fit)
                            .frame(width: 70)
                            .background(.brandGreen)
                            .cornerRadius(8, corners: .allCorners)
                            .overlay(alignment: .bottomTrailing) {
                                Image(.camera)
                                    .resizable()
                                    .aspectRatio(1.0, contentMode: .fit)
                                    .frame(width: 24)
                                    .offset(x: 5, y: 5)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                store.dispatch(.navigationAction(.showImagePickerView(show: true)))
                            }
                    },
                    placeHolderView: {
                        PlaceHolderImage()
                    },
                    errorView: { error in
                        PlaceHolderImage()
                    }
                )
                                
                List {
                    Section {
                        EditProfileContentFirstSectionCell(
                            cellType: .myCoin(
                                title: .myCoinTitle,
                                coin: store.state.myProfileState.myProfile?.sesacCoin ?? 0,
                                value: "충전하기"
                            )
                        )
                        EditProfileContentFirstSectionCell(
                            cellType: .nickname(
                                title: .nicknameTitle,
                                value: store.state.myProfileState.myProfile?.nickname ?? ""
                            )
                        )
                        EditProfileContentFirstSectionCell(
                            cellType: .phone(
                                title: .phoneTitle,
                                value: store.state.myProfileState.myProfile?.phone ?? ""
                            )
                        )
                    }
                    
                    Section {
                        EditProfileContentSecondSectionCell(cellType: .email, trailingView: {
                            Text(store.state.myProfileState.myProfile?.email ?? "")
                                .font(.body)
                                .foregroundStyle(.textSecondary)
                        })
                        EditProfileContentSecondSectionCell(cellType: .connectedSocialLogin, trailingView: {
                            HStack {
                                Image(.appleIDLogin)
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fit)
                                    .frame(width: 20)
                                
                                Image(.kakaoLogin)
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fit)
                                    .frame(width: 20)
                            }
                        })
                        EditProfileContentSecondSectionCell(cellType: .logOut, trailingView: {})
                    }
                }
                .scrollDisabled(true)
            
                Spacer()
            }
        }
    }
}

#Preview {
    EditProfileView()
}

struct PlaceHolderImage:View {
    
    var body: some View {
        Image(.kakaoLogo)
            .resizable()
            .aspectRatio(1.0, contentMode: .fit)
            .frame(width: 70)
            .background(.brandGreen)
            .cornerRadius(8, corners: .allCorners)
            .overlay(alignment: .bottomTrailing) {
                Image(.camera)
                    .resizable()
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(width: 24)
                    .offset(x: 5, y: 5)
            }
//            .contentShape(Rectangle())
//            .onTapGesture {
//                store.dispatch(.navigationAction(.showImagePickerView(show: true)))
//            }
    }
}

struct EditProfileContentFirstSectionCell: View {
    enum CellType {
        case myCoin(title: Title, coin: Int, value: String)
        case nickname(title: Title, value: String)
        case phone(title: Title, value: String)
        
        enum Title: String {
            case myCoinTitle = "내 코인"
            case nicknameTitle = "닉네임"
            case phoneTitle = "연락처"
        }
    }
    
    let cellType: CellType
    
    var body: some View {
        HStack {
            Group {
                switch cellType {
                case .myCoin(let title, let coin, _):
                    HStack {
                        Text(title.rawValue)
                        
                        Text("\(coin)")
                            .foregroundStyle(.brandGreen)
                    }
                case .nickname(let title, _):
                    Text(title.rawValue)
                case .phone(let title, _):
                    Text(title.rawValue)
                }
            }
            .font(.bodyBold)
            .foregroundStyle(.textPrimary)
            
            
            Spacer()
            
            HStack {
                Group {
                    switch cellType {
                    case .myCoin(_, _, let value):
                        Text(value)
                    case .nickname(_, let value):
                        Text(value)
                    case .phone(_, let value):
                        Text(value)
                    }
                }
                .font(.body)
                .foregroundStyle(.textSecondary)
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .aspectRatio(0.5, contentMode: .fit)
                    .frame(width: 6.5, height: 13)
            }
        }
    }
}

struct EditProfileContentSecondSectionCell<Content: View>: View {
    
    enum CellType {
        case email
        case connectedSocialLogin
        case logOut
        
        var title: String {
            switch self {
            case .email:
                return "이메일"
            case .connectedSocialLogin:
                return "연결된 소셜 계정"
            case .logOut:
                return "로그아웃"
            }
        }
    }
    
    let cellType: CellType
    let trailingView: Content
    
    init(
        cellType: CellType,
        @ViewBuilder trailingView: () -> Content
    ) {
        self.cellType = cellType
        self.trailingView = trailingView()
    }
    
    var body: some View {
        HStack {
            Text(cellType.title)
                .font(.bodyBold)
                .foregroundStyle(.textPrimary)
            
            Spacer()
            
            trailingView
        }
    }
}
