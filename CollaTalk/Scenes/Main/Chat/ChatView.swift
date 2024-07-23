//
//  ChatView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/22/24.
//

import SwiftUI

struct ChatView: View {
    enum ChatViewType {
        case dm
        case channel
    }
    
    @State private var text: String = ""
    
    var body: some View {
        VStack {
            ChatViewNavigationBar(chatViewType: .dm)
            
            ScrollView {
                Section(
                    content: {
                        ChatItem(chatDirection: .left)
                            .listRowSeparator(.hidden)
                        ChatItem(chatDirection: .right)
                            .listRowSeparator(.hidden)
                    },
                    header: {
                        ChatHeader()
                    }
                )
                
            }
            .listStyle(.plain)
        }
        .keyboardToolbar(height: 60) {
            HStack {
//                Spacer()
//                    .frame(width: 12)
                
                Image(systemName: "plus")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 22)
                    .foregroundStyle(.textSecondary)
                    .onTapGesture {
                        print("갤러리로 이동")
                    }
                    .padding(.leading, 8)
                    .padding(.trailing, 4)
                
                TextField("메세지를 입력하세요", text: $text, axis: .vertical)
                
                Image(.messageSendIcon)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 24)
                    .onTapGesture {
                        print("사진 보내기")
                    }
                    .padding(.horizontal, 8)
            }
            .frame(height: 40)
            .background(.backgroundPrimary)
            .cornerRadius(8, corners: .allCorners)
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    ChatView()
}

struct ChatViewNavigationBar: View {
    
    @EnvironmentObject private var navigationRouter: NavigationRouter
    
    let chatViewType: ChatView.ChatViewType
    
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
                .hidden(chatViewType == .dm)
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
    
    let chatDirection: ChatDirection
    
    private let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        HStack(alignment: .top) {
            
            if chatDirection == .left {
                Image(.kakaoLogo)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 34)
                    .background(.brandGreen)
                    .cornerRadius(8, corners: .allCorners)
            } else {
                
                Spacer()
                
                Text("08:16 오전")
                //                .font(.caption2)
                    .foregroundStyle(.textSecondary)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
            
            
            VStack(alignment: chatDirection == .left ? .leading : .trailing) {
                
                if chatDirection == .left {
                    Text("뚜비두밥")
                    //                    .font(.caption)
                        .foregroundStyle(.textPrimary)
                }
                
                Text("ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ")
                //                    .font(.body)
                    .foregroundStyle(.textPrimary)
                    .padding(8)
                    .cornerRadius(8, corners: .allCorners)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.brandBlack, lineWidth: 1)
                    )
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(chatDirection == .left ? .leading : .trailing)
                
                Group {
                    Image(.kakaoLogo)
                        .resizable()
                        .aspectRatio(244/162,contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: 162)
                        .background(.brandGreen)
                }
                .cornerRadius(16, corners: .allCorners)
            }
            .frame(width: screenWidth * 0.57)
            
            if chatDirection == .left {
                Text("08:16 오전")
                //                .font(.caption2)
                    .foregroundStyle(.textSecondary)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            } else {
                
            }
            
        }
    }
}

struct ChatHeader: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("2024.07.23 금")
            //                .font(.caption)
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
