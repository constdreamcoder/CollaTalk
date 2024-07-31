//
//  ChannelSettingView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/31/24.
//

import SwiftUI

struct ChannelSettingView: View {
    
    @EnvironmentObject private var navigationRouter: NavigationRouter
    @State private var isExpanded: Bool = false
    
    let data = Array(1...33).map { "목록 \($0)"}
    
    private let columns = [
        GridItem(.adaptive(minimum: 44)),
        GridItem(.adaptive(minimum: 44)),
        GridItem(.adaptive(minimum: 44)),
        GridItem(.adaptive(minimum: 44)),
        GridItem(.adaptive(minimum: 44)),
    ]
    
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
                    }
                )
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("#그냥 떠들고 싶을 때")
                            .font(.title2)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("안녕하세요 새싹 여러분? 심심하셨죠? 이 채널은 나머지 모든 것을 위한 채널이에요. 팀원들이 농담하거나 순간적인 아이디어를 공유하는 곳이죠! 마음껏 즐기세요!")
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .foregroundStyle(.brandBlack)
                    .padding(.horizontal, 16)
                    
                    VStack {
                        CellHeader(
                            isExpanded: $isExpanded,
                            title: "멤버 (14)"
                        )
                        .padding(.horizontal, 13)
                        
                        if isExpanded {
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(data, id: \.self) {_ in
                                    VStack(alignment: .center, spacing: 4) {
                                        Image(.kakaoLogo)
                                            .resizable()
                                            .aspectRatio(1, contentMode: .fit)
                                            .frame(width: 44)
                                            .background(.brandGreen)
                                            .cornerRadius(8, corners: .allCorners)
                                        Text("Hue")
                                            .font(.body)
                                            .foregroundStyle(.textTertiary)
                                    }
                                }
                            }
                            .padding(.horizontal, 3)
                        }
                    }
                    
                    VStack {
                        CustomButton {
                            print("채널 편집")
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
                            print("채널 관리자")
                        } label: {
                            Text("채널 관리자")
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
                    
                    Spacer()
                }
                .scrollIndicators(.hidden)
            }
        }
    }
}

#Preview {
    ChannelSettingView()
}
