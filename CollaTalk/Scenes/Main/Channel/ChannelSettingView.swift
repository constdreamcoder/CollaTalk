//
//  ChannelSettingView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/31/24.
//

import SwiftUI

struct ChannelSettingView: View {
    
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var navigationRouter: NavigationRouter
    @State private var isExpanded: Bool = false
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack {
                NavigationFrameView(
                    title: "채널 설정",
                    leftButtonAction: {
                        print("뒤로가기")
                        navigationRouter.pop()
                        store.dispatch(
                            .channelAction(
                                .fetchChannelChats(
                                    chatRoomType: .channel,
                                    channel: store.state.channelSettingState.channelDetails,
                                    isRefreshing: true
                                )
                            )
                        )
                    }
                )
                
                ScrollView {
                    ChannelDescriptionSection(
                        name: store.state.channelSettingState.channelDetails?.name ?? "",
                        description: store.state.channelSettingState.channelDetails?.description
                    )
                    
                    ChannelMemberSection(
                        isExpanded: $isExpanded,
                        members: store.state.channelSettingState.channelDetails?.channelMembers ?? []
                    )
                    
                    ChannelSettingButtonSection()
                        .padding(.top, 16)
            
                    Spacer()
                }
                .scrollIndicators(.hidden)
            }
        }
        .sheet(
            isPresented: Binding(
                get: { store.state.navigationState.isChangeChannelOwnerViewPresented },
                set: { store.dispatch(.navigationAction(.presentChangeChannelOwnerView(present: $0))) }
            )
        ) {
            ChangeChannelOwnerView()
        }
    }
}

#Preview {
    ChannelSettingView()
}

struct ChannelDescriptionSection: View {
    
    let name: String
    let description: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("#\(name)")
                .font(.title2)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let description {
                Text(description)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
           
        }
        .foregroundStyle(.brandBlack)
        .padding(.horizontal, 16)
    }
}

struct ChannelMemberSection: View {
    
    @Binding var isExpanded: Bool
    
    let data = Array(1...33).map { "목록 \($0)"}
    
    let members: [WorkspaceMember]
    
    private let columns = [
        GridItem(.adaptive(minimum: 44)),
        GridItem(.adaptive(minimum: 44)),
        GridItem(.adaptive(minimum: 44)),
        GridItem(.adaptive(minimum: 44)),
        GridItem(.adaptive(minimum: 44)),
    ]
    
    var body: some View {
        VStack {
            CellHeader(
                isExpanded: $isExpanded,
                title: "멤버 (\(members.count))"
            )
            .padding(.horizontal, 13)
            
            if isExpanded {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(members, id: \.userId) { member in
                        VStack(alignment: .center, spacing: 4) {
                            
                            RemoteImage(
                                path: member.profileImage,
                                imageView: { image in
                                    image
                                        .resizable()
                                        .aspectRatio(1, contentMode: .fit)
                                        .frame(width: 44)
                                },
                                placeHolderView: {
                                    Image(.kakaoLogo)
                                        .resizable()
                                        .aspectRatio(1, contentMode: .fit)
                                        .frame(width: 44)
                                       
                                },
                                errorView: { error in
                                    Image(.kakaoLogo)
                                        .resizable()
                                        .aspectRatio(1, contentMode: .fit)
                                        .frame(width: 44)
                                }
                            )
                            .background(.brandGreen)
                            .cornerRadius(8, corners: .allCorners)
                            
                            Text(member.nickname)
                                .font(.body)
                                .foregroundStyle(.textTertiary)
                                .lineLimit(1)
                        }
                    }
                }
                .padding(.horizontal, 3)
            }
        }
    }
}

struct ChannelSettingButtonSection: View {
    
    @EnvironmentObject private var store: AppStore
    
    var body: some View {
        VStack {
            CustomButton {
                print("채널 편집")
                store.dispatch(.createOrEditChannelAction(.moveToEditChannelView))
            } label: {
                Text("채널 편집")
                    .foregroundStyle(.brandBlack)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.brandBlack, lineWidth: 1)
            }
            .bottomButtonShape(.backgroundSecondary)
            
            CustomButton {
                print("채널에서 나가기")
            } label: {
                Text("채널에서 나가기")
                    .foregroundStyle(.brandBlack)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.brandBlack, lineWidth: 1)
            }
            .bottomButtonShape(.backgroundSecondary)
            
            CustomButton {
                print("채널 관리자 변경")
                store.dispatch(.navigationAction(.presentChangeChannelOwnerView(present: true)))
            } label: {
                Text("채널 관리자 변경")
                    .foregroundStyle(.brandBlack)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.brandBlack, lineWidth: 1)
            }
            .bottomButtonShape(.backgroundSecondary)
            
            CustomButton {
                print("채널 삭제")
            } label: {
                Text("채널 삭제")
                    .foregroundStyle(.brandError)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.brandError, lineWidth: 1)
            }
            .bottomButtonShape(.backgroundSecondary)
            
        }
    }
}
