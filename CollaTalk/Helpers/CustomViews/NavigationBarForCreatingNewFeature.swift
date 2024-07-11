//
//  NavigationBarForCreatingNewFeature.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/5/24.
//

import SwiftUI

struct NavigationBarForCreatingNewFeature: View {
    
    enum Feature: String {
        case signUp = "회원가입"
        case login = "로그인"
        case workspaceInit = "시작하기"
    }
    
    let title: Feature
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            ZStack {
                VStack(spacing: 15) {
                    if title != .workspaceInit {
                        BottomViewGrabber()
                            .padding(.top, 6)
                    }
                    
                    Text(title.rawValue)
                        .font(.system(size: 17, weight: .bold))
                }
                
                VStack(spacing: 15) {
                    if title != .workspaceInit {
                        BottomViewGrabber()
                            .padding(.top, 4)
                            .hidden()
                    }
                    
                    HStack {
                        Button {
                            print("dismiss")
                            isPresented = false
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 13, height: 13)
                                .foregroundStyle(.brandBlack)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 2)
                        
                        Spacer()
                    }
                }
            }
            
            Divider()
        }
        .background(.brandWhite)
    }
}
