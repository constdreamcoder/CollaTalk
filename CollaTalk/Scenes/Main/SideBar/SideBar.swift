//
//  SideBar.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/14/24.
//

import SwiftUI

struct SideBar: View {
    @EnvironmentObject private var store: AppStore
    @State private var isDialogPresented = false
    @State private var dialogWorkspace: Workspace? = nil
    
    private var sideBarWidth = UIScreen.main.bounds.size.width * 0.8
    private var bgColor: Color = .brandWhite
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(.black.opacity(0.6))
            .opacity(store.state.navigationState.isSidebarVisible ? 1 : 0)
            .animation(.easeInOut.delay(0.2), value: store.state.navigationState.isSidebarVisible)
            .onTapGesture {
                store.dispatch(.workspaceAction(.toggleSideBarAction))
            }
            
            content
        }
        .edgesIgnoringSafeArea(.all)
        .confirmationDialog("워크스페이스 설정", isPresented: $isDialogPresented) {
            if dialogWorkspace?.ownerId == store.state.user?.userId {
                Button("워크스페이스 편집") {
                    print("워크스페이스 편집")
                    store.dispatch(.navigationAction(.presentModifyWorkspaceView(present: true, workspaceModificationType: .edit, selectedWorkspace: dialogWorkspace)))
                }
                Button("워크스페이스 나가기") { print("워크스페이스 나기기") }
                Button("워크스페이스 관리자 변경") { print("워크스페이스 삭제") }
                Button("워크스페이스 삭제", role: .destructive) { print("워크스페이스 삭제") }
                Button("취소", role: .cancel) { print("취소") }
            } else {
                Button("워크스페이스 나가기") { print("워크스페이스 나기기") }
                Button("취소", role: .cancel) { print("취소") }
            }
        }
    }
    
    private var content: some View {
        HStack(alignment: .top) {
            ZStack(alignment: .top) {
                bgColor
                
                SideBarContentView(
                    isDialogPresented: $isDialogPresented,
                    dialogWorkspace: $dialogWorkspace
                )
            }
            .frame(width: sideBarWidth)
            .cornerRadius(25, corners: [.topRight, .bottomRight])
            .offset(x: store.state.navigationState.isSidebarVisible ? 0 : -sideBarWidth)
            .animation(.default, value: store.state.navigationState.isSidebarVisible)
            
            Spacer()
        }
    }
}

#Preview {
    SideBar()
}

struct SideBarContentView: View {
    
    @EnvironmentObject private var store: AppStore
    @Binding var isDialogPresented: Bool
    @Binding var dialogWorkspace: Workspace?
    
    var body: some View {
        VStack {
            Group {
                Text("워크스페이스")
                    .font(.title1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 80)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
            }
            .background(.backgroundPrimary)
            
            /// 워크스페이스 표시 영역
            Group {
                /// 워크스페이스가 1개 이상일 때 뷰
                if store.state.workspaceState.workspaces.count > 0 {
                    List {
                        ForEach(store.state.workspaceState.workspaces, id: \.workspaceId) { workspace in
                            WorkspaceCell(
                                isDialogPresented: $isDialogPresented, 
                                dialogWorkspace: $dialogWorkspace,
                                workspace: workspace
                            )
                            .listRowInsets(.init(top: 0, leading: 8, bottom: 0, trailing: 8))
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                    .listRowSpacing(12)
                    .scrollIndicators(.hidden)
                } else {
                    /// 워크스페이스가 0개일 때 뷰
                    VStack {
                        
                        Spacer()
                        
                        Text("워크스페이스를\n찾을 수 없어요.")
                            .font(.title1)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 20)
                        
                        Text("관리자에게 초대를 요청하거나,\n다른 이메일로 시도하거나\n새로운 워크스페이스를 생성해주세요.")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 20)
                        
                        CustomButton {
                            print("워크스페이스 생성")
                            store.dispatch(.navigationAction(.presentModifyWorkspaceView(present: true, workspaceModificationType: .create)))
                        } label: {
                            Text("워크스페이스 생성")
                        }
                        .bottomButtonShape(.brandGreen)

                        Spacer()
                    }
                }
            }
                       
            Spacer()
            
            bottom
                .padding(.bottom, 40)
            
        }
    }
    
    private var bottom: some View {
        VStack {
            HStack {
                Image(systemName: "plus")
                    .frame(width: 18, height: 18)
                
                Text("워크스페이스 추가")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 40)
            .contentShape(Rectangle())
            .onTapGesture {
                print("워크스페이스 추가")
                store.dispatch(.navigationAction(.presentModifyWorkspaceView(present: true, workspaceModificationType: .create)))
            }
            
            HStack {
                Image(systemName: "questionmark.circle")
                    .frame(width: 18, height: 18)
                
                Text("도움말")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 40)
            .contentShape(Rectangle())
            .onTapGesture {
                print("도움말")
            }
        }
        .font(.body)
        .foregroundStyle(.textSecondary)
        .padding(.horizontal, 16)
    }
}

struct WorkspaceCell: View {
    
    @EnvironmentObject private var store: AppStore
    @Binding var isDialogPresented: Bool
    @Binding var dialogWorkspace: Workspace?

    let workspace: Workspace
    
    var body: some View {
        HStack {
            RemoteImage(
                path: workspace.coverImage
            ) { image in
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .background(.brandGreen)
                    .frame(width: 44)
                    .cornerRadius(8, corners: .allCorners)
            } placeHolderView: {
                Image(.kakaoLogo)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .background(.brandGreen)
                    .frame(width: 44)
                    .cornerRadius(8, corners: .allCorners)
            }

            VStack {
                Text(workspace.name)
                    .font(.bodyBold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                
                Text(workspace.createdAt.convertToWorkspaceCellDateFormat)
                    .foregroundStyle(.textSecondary)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
            }
            
            Image(systemName: "ellipsis")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20)
                .padding(.vertical, 20)
                .contentShape(Rectangle())
                .onTapGesture {
                    print(workspace.name)
                    dialogWorkspace = workspace
                    isDialogPresented = true
                }
        }
        .padding(8)
        .background(store.state.workspaceState.selectedWorkspace?.name ?? "" == workspace.name ? .brandGray : .clear)
        .cornerRadius(8, corners: .allCorners)
    }
}
