//
//  ChatView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/22/24.
//

import SwiftUI

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
    
    @Namespace private var bottomID
    
    var body: some View {
        
        VStack {
            ScrollViewReader { proxy in
                ChatViewNavigationBar(chatRoomType: chatRoomType)
                
                List {
                    ForEach(store.state.dmState.dms, id: \.dmId) { dm in
                        Group {
                            if dm.user?.userId == store.state.user?.userId {
                                ChatItem(dm: dm, chatDirection: .right)
                                    .listRowSeparator(.hidden)
                            } else {
                                ChatItem(dm: dm, chatDirection: .left)
                                    .listRowSeparator(.hidden)
                            }
                        }
                    }
                    Rectangle()
                        .frame(height: 0)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .background(.clear)
                        .id(bottomID)
                }
                .environment(\.defaultMinListRowHeight, 1)
                .listStyle(.plain)
                .onChange(of: store.state.dmState.dms, action: { newValue in
                    withAnimation { proxy.scrollTo(bottomID, anchor: .bottom) }
                })
                .onAppear(perform: {
                    proxy.scrollTo(bottomID, anchor: .bottom)
                })
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
                                ChatSelectedImage {
                                    print("선택된 이미지 제거")
                                    store.dispatch(.chatAction(.removeSelectedImage(image: selectedImage)))
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
                            store.dispatch(.chatAction(.sendDirectMessage))
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
        .onReceive(socket.receivedDMSubject) { receivedDM in
            store.dispatch(.chatAction(.receiveNewDirectMessage(receivedDM: receivedDM)))
        }
        .onDisappear {
            store.dispatch(.chatAction(.initializeAllElements))
        }
    }
}

#Preview {
    ChatView(chatRoomType: .dm)
}

struct ChatViewNavigationBar: View {
    
    @EnvironmentObject private var navigationRouter: NavigationRouter
    
    let chatRoomType: ChatRoomType
    
    var body: some View {
        VStack {
            HStack {
                Button(
                    action: {
                        print("뒤로가기")
                        navigationRouter.pop()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .font(.title1)
                            .frame(width: 17, height: 22)
                    }
                )
                .padding(10)
                
                Spacer()
                
                Text("뚜미두밥")
                    .font(.title1)
                    .lineLimit(1)
                
                Spacer()
                
                Button(
                    action: {
                        print("채널 설정")
                    },
                    label: {
                        Image(systemName: "list.bullet")
                            .font(.title1)
                            .frame(width: 18, height: 16)
                    }
                )
                .padding(.trailing, 15)
                .hidden(chatRoomType == .dm)
            }
            .foregroundStyle(.brandBlack)
            
            Divider()
        }
    }
}

enum ChatDirection {
    case left
    case right
}

struct ChatItem: View {
    
    let dm: LocalDirectMessage
    let chatDirection: ChatDirection
    
    private let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        HStack(alignment: .top) {
            
            if chatDirection == .left {
                RemoteImage(
                    path: dm.user?.profileImage,
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
                
            } else {
                
                Spacer()
                
                Text(dm.createdAt.toChatTime)
                    .font(.caption2)
                    .foregroundStyle(.textSecondary)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
            
            
            VStack(alignment: chatDirection == .left ? .leading : .trailing) {
                
                if chatDirection == .left {
                    Text(dm.user?.nickname ?? "")
                        .font(.caption)
                        .foregroundStyle(.textPrimary)
                }
                
                if let content = dm.content {
                    Text(content)
                        .font(.body)
                        .foregroundStyle(.textPrimary)
                        .padding(8)
                        .cornerRadius(8, corners: .allCorners)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.brandBlack, lineWidth: 1)
                        )
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(chatDirection == .left ? .leading : .trailing)
                }
                
                if dm.files.count > 0 {
                    Group {
                        RemoteImage(
                            path: dm.files[0],
                            imageView: { image in
                                image
                                    .resizable()
                                    .aspectRatio(244/162,contentMode: .fit)
                                    .frame(maxWidth: .infinity, maxHeight: 162)
                                    .background(.brandGreen)
                            },
                            placeHolderView: {
                                Image(.kakaoLogo)
                                    .resizable()
                                    .aspectRatio(244/162,contentMode: .fit)
                                    .frame(maxWidth: .infinity, maxHeight: 162)
                                    .background(.brandGreen)
                            },
                            errorView: { error in
                                Image(.kakaoLogo)
                                    .resizable()
                                    .aspectRatio(244/162,contentMode: .fit)
                                    .frame(maxWidth: .infinity, maxHeight: 162)
                                    .background(.brandGreen)
                            }
                        )
                    }
                    .cornerRadius(16, corners: .allCorners)
                }
            }
            .frame(width: screenWidth * 0.57)
            
            if chatDirection == .left {
                Text(dm.createdAt.toChatTime)
                    .font(.caption2)
                    .foregroundStyle(.textSecondary)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .padding(.vertical, 6)
    }
}

struct ChatHeader: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("2024.07.23 금")
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
        }
        .frame(maxWidth: .infinity)
    }
}

struct ChatSelectedImage: View {
    
    let tapAction: () -> Void
    
    var body: some View {
        Image(.kakaoLogo)
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .frame(width: 44)
            .background(.brandGreen)
            .cornerRadius(8, corners: .allCorners)
            .overlay(alignment: .topTrailing) {
                Image(.removeImageIcon)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 20)
                    .background(.backgroundSecondary)
                    .clipShape(Circle())
                    .offset(x: 4.0, y: -4.0)
                    .onTapGesture {
                        print("삭제")
                        tapAction()
                    }
            }
    }
}
