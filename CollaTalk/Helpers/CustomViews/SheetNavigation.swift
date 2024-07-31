//
//  NavigationBarForCreatingNewFeature.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/5/24.
//

import SwiftUI

struct SheetNavigation: View {
    
    enum Feature: String {
        case signUp = "회원가입"
        case login = "로그인"
        case workspaceInit = "시작하기"
        case createWorkspace = "워크스페이스 생성"
        case editWorkspace = "워크스페이스 편집"
        case changeWorkspaceOwner = "워크스페이스 관리자 변경"
        case changeChannelOwner = "채널 관리자 변경"
        case inviteMember = "팀원 초대"
        case createNewChannel = "채널 생성"
        case searchChannel = "채널 탐색"
        case editChannel = "채널 편집"
    }
        
    let title: Feature
    @Binding var isPresented: Bool
    let transitionAction: () -> Void
    
    var body: some View {
        VStack {
            ZStack {
                VStack(spacing: 15) {
                    if  title == .workspaceInit || title == .searchChannel {
                        EmptyView()
                    } else {
                        BottomViewGrabber()
                            .padding(.top, 6)
                    }
                    
                    Text(title.rawValue)
                        .font(.system(size: 17, weight: .bold))
                }
                
                VStack(spacing: 15) {
                    if title == .workspaceInit || title == .searchChannel {
                        EmptyView()
                    } else {
                        BottomViewGrabber()
                            .padding(.top, 4)
                            .hidden()
                    }
                    
                    HStack {
                        Button {
                            if title == .workspaceInit {
                                print("X 버튼 클릭")
                                transitionAction()
                            } else {
                                print("dismiss")
                                isPresented = false
                            }
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
