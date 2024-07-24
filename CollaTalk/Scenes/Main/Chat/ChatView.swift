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
    
    @State private var selectedImages: [UIImage] = []
    
    @State private var text: String = ""
    @State private var textViewHeight: CGFloat = 30
    private let textViewPadding: CGFloat = 8 // 고정값
    
    @State private var inputViewVStackSpacing: CGFloat = 0
    @State private var selectedImageHeight: CGFloat = 0
        
    var body: some View {
        
        VStack {
            ChatViewNavigationBar(chatViewType: .dm)
            
            List {
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
        .keyboardToolbar(height: textViewHeight + textViewPadding * 2 + inputViewVStackSpacing + selectedImageHeight)  {
            VStack {
                HStack(alignment: .bottom) {
                    
                    CustomPhotosPicker(selectedImages: $selectedImages) {
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(height: 22)
                            .foregroundStyle(.textSecondary)
                            .padding(.bottom, 12)
                    }
                    
                    
                    VStack(spacing: inputViewVStackSpacing) {
                        ResizableTextView(
                            text: $text,
                            height: $textViewHeight,
                            maxHeight: 48,
                            textFont: .systemFont(ofSize: 13),
                            placeholder: "메세지를 입력하세요"
                        )
                        .frame(minHeight: textViewHeight)
                        
                        LazyHStack {
                            ForEach(selectedImages, id: \.self) { selectedImage in
                                ChatSelectedImage {
                                    selectedImages.removeAll { $0 == selectedImage }
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
                            print("사진 보내기")
                            
                        }
                }
                .padding(.horizontal, 12)
                .background(.backgroundPrimary)
                .cornerRadius(8, corners: .allCorners)
            }
            .padding(.horizontal, 16)
        }
        .onChange(of: selectedImages, action: { newValue in
            print(newValue.count)
            
            if newValue.count > 0 {
                inputViewVStackSpacing = 8
                selectedImageHeight = 50
            } else {
                inputViewVStackSpacing  = 0
                selectedImageHeight = 0
            }
        })
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
                    .font(.caption2)
                    .foregroundStyle(.textSecondary)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
            
            
            VStack(alignment: chatDirection == .left ? .leading : .trailing) {
                
                if chatDirection == .left {
                    Text("뚜비두밥")
                        .font(.caption)
                        .foregroundStyle(.textPrimary)
                }
                
                Text("ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ")
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
