//
//  ChatView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/22/24.
//

import SwiftUI
import UIKit

enum ChatRoomType {
    case dm
    case channel
}

struct ChatView: View {
    
    let chatRoomType: ChatRoomType
    
    @EnvironmentObject private var store: AppStore
    @StateObject private var socket = SocketIOManager.shared
    
    @State private var textViewHeight: CGFloat = 30
    private let textViewPadding: CGFloat = 8 // 고정값
    
    @State private var inputViewVStackSpacing: CGFloat = 0
    @State private var selectedImageHeight: CGFloat = 0
    
    var body: some View {
        
        VStack {
            if chatRoomType == .dm {
                DMChatRoomsView(chatRoomType: chatRoomType)
                    .onReceive(socket.receivedDMSubject) { receivedDM in
                        store.dispatch(.chatAction(.receiveNewDirectMessage(receivedDM: receivedDM)))
                    }
            } else if chatRoomType == .channel {
                ChannelChatsView(chatRoomType: chatRoomType)
                    .onReceive(socket.receivedChannelChatSubject) { receivedChannelChat in
                        store.dispatch(.chatAction(.receiveNewChannelChat(receivedChannelChat: receivedChannelChat)))
                    }
            }
        }
        .keyboardToolbar(height: textViewHeight + textViewPadding * 2 + inputViewVStackSpacing + selectedImageHeight)  {
            VStack {
                HStack(alignment: .bottom) {
                    SelectPhotosView {
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(height: 22)
                            .foregroundStyle(.textSecondary)
                            .padding(.bottom, 12)
                    }
                    
                    VStack(spacing: inputViewVStackSpacing) {
                        ResizableTextView(
                            text: Binding(
                                get: { store.state.chatState.message },
                                set: { store.dispatch(.chatAction(.writeMessage(message: $0))) }),
                            height: $textViewHeight,
                            maxHeight: 48,
                            textFont: .systemFont(ofSize: 13),
                            placeholder: "메세지를 입력하세요"
                        )
                        .frame(minHeight: textViewHeight)
                        
                        LazyHStack {
                            ForEach(store.state.chatState.selectedImages, id: \.self) { selectedImage in
                                ChatSelectedImage(image: selectedImage)
                                    .overlay(alignment: .topTrailing) {
                                        Image(.removeImageIcon)
                                            .resizable()
                                            .aspectRatio(1, contentMode: .fit)
                                            .frame(width: 20)
                                            .background(.backgroundSecondary)
                                            .clipShape(Circle())
                                            .offset(x: 4.0, y: -4.0)
                                            .onTapGesture {
                                                print("선택된 이미지 제거")
                                                store.dispatch(.chatAction(.removeSelectedImage(image: selectedImage)))
                                            }
                                    }
                            }
                        }
                        .frame(height: selectedImageHeight)
                    }
                    .padding(.vertical, textViewPadding)
                    
                    Image(.messageSendIcon)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(height: 24)
                        .padding(.bottom, 12)
                        .onTapGesture {
                            print("메세지 전송")
                            store.dispatch(.chatAction(.sendNewMessage))
                        }
                }
                .padding(.horizontal, 12)
                .background(.backgroundPrimary)
                .cornerRadius(8, corners: .allCorners)
            }
            .padding(.horizontal, 16)
        }
        .onChange(of: store.state.chatState.selectedImages, action: { newValue in
            print(newValue.count)
            
            if newValue.count > 0 {
                inputViewVStackSpacing = 8
                selectedImageHeight = 50
            } else {
                inputViewVStackSpacing  = 0
                selectedImageHeight = 0
            }
        })
        .onDisappear {
            // TODO: - 정확한 시점으로 옮기기
//            store.dispatch(.chatAction(.initializeAllElements))
        }
    }
}

#Preview {
    ChatView(chatRoomType: .dm)
}

struct ChannelChatsView: View {
    
    let chatRoomType: ChatRoomType
    
    @EnvironmentObject private var store: AppStore
    @Namespace private var channelChatBottomID

    var body: some View {
        ScrollViewReader { proxy in
            ChatViewNavigationBar(
                chatRoomType: chatRoomType,
                title: "#\(store.state.channelState.channel?.name ?? "")"
            )
            ScrollView {
                LazyVStack(pinnedViews: .sectionHeaders) {
                    ForEach(store.state.channelState.channelChats, id: \.chatDate) { chatDate, channelChats in
                        Section(
                            content: {
                                ForEach(channelChats, id: \.chatId) { channelChat in
                                    ChatItem(
                                        chatDirection: channelChat.sender?.userId == store.state.user?.userId ? .right : .left,
                                        profileImage: channelChat.sender?.profileImage,
                                        chatTime: channelChat.createdAt.toChatTime,
                                        nickname: channelChat.sender?.nickname ?? "",
                                        content: channelChat.content,
                                        files: channelChat.files.map { $0 }, 
                                        profileImageTouchAction: {
                                            print("채널 채팅 프로필 조회")
                                            if channelChat.sender?.userId != store.state.user?.userId {
                                                guard let userId = channelChat.sender?.userId else { return }
                                                store.dispatch(.otherProfileAction(.fetchOtherMemberProfile(userId:  userId)))
                                            }
                                        }
                                    )
                                }
                            },
                            header: {
                                ChatHeader(chateDate: chatDate)
                                    .padding(.top, 0.5)
                            }
                        )
                        
                    }
                }
                .padding(.horizontal, 16)
                
                Rectangle()
                    .frame(height: 0)
                    .background(.clear)
                    .id(channelChatBottomID)
            }
            .onAppear(perform: {
                proxy.scrollTo(channelChatBottomID, anchor: .bottom)
            })
            .onChange(of: store.state.channelState.channelChatCount, action: { _ in
                withAnimation { proxy.scrollTo(channelChatBottomID, anchor: .bottom) }
            })
        }
    }
}

struct DMChatRoomsView: View {

    let chatRoomType: ChatRoomType
    
    @EnvironmentObject private var store: AppStore
    @Namespace private var dmChatBottomID

    var body: some View {
        ScrollViewReader { proxy in
            ChatViewNavigationBar(
                chatRoomType: chatRoomType,
                title: store.state.dmState.opponent?.nickname ?? ""
            )
            ScrollView {
                LazyVStack(pinnedViews: .sectionHeaders) {
                    ForEach(store.state.dmState.dms, id: \.chatDate) { chatDate, dms in
                        Section(
                            content: {
                                ForEach(dms, id: \.dmId) { dm in
                                    ChatItem(
                                        chatDirection: dm.user?.userId == store.state.user?.userId ? .right : .left,
                                        profileImage: dm.user?.profileImage,
                                        chatTime: dm.createdAt.toChatTime,
                                        nickname: dm.user?.nickname ?? "",
                                        content: dm.content,
                                        files: dm.files.map { $0 }, 
                                        profileImageTouchAction: {
                                            print("DM 채팅 프로필 조회")
                                            if dm.user?.userId != store.state.user?.userId {
                                                guard let userId = dm.user?.userId else { return }
                                                store.dispatch(.otherProfileAction(.fetchOtherMemberProfile(userId:  userId)))
                                            }
                                        }
                                    )
                                }
                            },
                            header: {
                                ChatHeader(chateDate: chatDate)
                                    .padding(.top, 0.5)
                            }
                        )
                        
                    }
                }
                .padding(.horizontal, 16)
                
                Rectangle()
                    .frame(height: 0)
                    .background(.clear)
                    .id(dmChatBottomID)
            }
            .onAppear(perform: {
                proxy.scrollTo(dmChatBottomID, anchor: .bottom)
            })
            .onChange(of: store.state.dmState.dmCount, action: { _ in
                withAnimation { proxy.scrollTo(dmChatBottomID, anchor: .bottom) }
            })
        }
    }
}

struct ChatViewNavigationBar: View {
    
    @EnvironmentObject private var navigationRouter: NavigationRouter
    @EnvironmentObject private var store: AppStore
    
    let chatRoomType: ChatRoomType
    let title: String
    
    var body: some View {
        NavigationFrameView(
            title: title,
            leftButtonAction: {
                print("뒤로가기")
                navigationRouter.pop()
                if store.state.tabState.currentTab == .dm {
                    store.dispatch(.dmAction(.refresh))
                } else if store.state.tabState.currentTab == .home {
                    store.dispatch(.homeAction(.refresh))
                }
            },
            rightButtonAction: {
                print("채널 설정 화면으로 이동")
                store.dispatch(.channelSettingAction(.fetchChannel))
            },
            isRightButtonHidden: chatRoomType == .dm
        )
    }
}

enum ChatDirection {
    case left
    case right
}

struct ChatItem: View {
    
    @EnvironmentObject private var store: AppStore
    
    let chatDirection: ChatDirection
    
    let profileImage: String?
    let chatTime: String
    let nickname: String
    let content: String?
    let files: [String]
    
    let profileImageTouchAction: () -> Void
    
    private let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        HStack(alignment: .top) {
            if chatDirection == .left {
                RemoteImage(
                    path: profileImage,
                    imageView: { image in
                        image
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 34)
                            .background(.brandGreen)
                            .cornerRadius(8, corners: .allCorners)
                    },
                    placeHolderView: {
                        Image(.kakaoLogo)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 34)
                            .background(.brandGreen)
                            .cornerRadius(8, corners: .allCorners)
                    },
                    errorView: { error in
                        Image(.kakaoLogo)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 34)
                            .background(.brandGreen)
                            .cornerRadius(8, corners: .allCorners)
                    }
                )
                .contentShape(Rectangle())
                .onTapGesture(perform: profileImageTouchAction)
                
            } else {
                
                Spacer()
                
                Text(chatTime)
                    .font(.caption2)
                    .foregroundStyle(.textSecondary)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
            
            VStack(alignment: chatDirection == .left ? .leading : .trailing) {
                
                if chatDirection == .left {
                    Text(nickname)
                        .font(.caption)
                        .foregroundStyle(.textPrimary)
                }
                
                if let content = content, !(content.isEmpty && files.count > 0) {
                    Text(content)
                        .font(.body)
                        .foregroundStyle(.textPrimary)
                        .padding(8)
                        .background(chatDirection == .left ? .backgroundSecondary :  .yellow.opacity(0.4))
                        .cornerRadius(8, corners: .allCorners)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.brandBlack, lineWidth: 1)
                        )
                        .multilineTextAlignment(chatDirection == .left ? .leading : .trailing)
                }
                
                // TODO: - 개수별 이미지 표시 레이아웃 구성
                if files.count > 0 {
                    Group {
                        RemoteImage(
                            path: files[0],
                            imageView: { image in
                                image
                                    .resizable()
                                    .aspectRatio(244/162, contentMode: .fit)
                            },
                            placeHolderView: {
                                Image(.kakaoLogo)
                                    .resizable()
                                    .aspectRatio(244/162, contentMode: .fit)
                            },
                            errorView: { error in
                                Image(.kakaoLogo)
                                    .resizable()
                                    .aspectRatio(244/162, contentMode: .fit)
                            }
                        )
                    }
                    .cornerRadius(16, corners: .allCorners)
                    .frame(maxWidth: screenWidth * 0.57, maxHeight: 162, alignment: .top)
                }
            }
            
            if chatDirection == .left {
                Text(chatTime)
                    .font(.caption2)
                    .foregroundStyle(.textSecondary)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity, alignment: chatDirection == .left ? .leading : .trailing)
    }
}

struct ChatHeader: View {
    
    let chateDate: String
    
    var body: some View {
        Text(chateDate)
            .font(.caption)
            .foregroundStyle(.textPrimary)
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .background(.backgroundPrimary)
            .cornerRadius(16, corners: .allCorners)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.brandBlack, lineWidth: 1)
            )
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct ChatSelectedImage: View {
    
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .frame(width: 44)
            .background(.brandGreen)
            .cornerRadius(8, corners: .allCorners)
    }
}
