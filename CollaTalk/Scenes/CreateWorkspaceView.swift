//
//  CreateWorkspaceView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/11/24.
//

import SwiftUI

struct CreateWorkspaceView: View {
    
    @EnvironmentObject private var store: AppStore
    
    var body: some View {
        ZStack {
            
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                NavigationBarForCreatingNewFeature(title: .createWorkspace, isPresented: .constant(true))
                
                Image(.workspace)
                    .resizable()
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(width: 60)
                    .padding(10)
                    .bottomButtonShape(.brandWhite)
                    .overlay(alignment: .bottomTrailing) {
                        Image(.camera)
                            .resizable()
                            .aspectRatio(1.0, contentMode: .fit)
                            .frame(width: 24)
                            .offset(x: -7, y: 5)
                    }
                
                InputView(
                    title: "워크스페이스 이름",
                    placeholder: "워크스페이스 이름을 입력하세요 (필수)",
                    textFieldGetter: { store.state.createWorkspaceState.name },
                    textFieldSetter: { store.dispatch(.createWorkspaceAction(.writeName(name: $0))) },
                    secureFieldGetter: { "" },
                    secureFieldSetter: { _ in },
                    rightButtonAction: {},
                    isValid: true
                )
                
                InputView(
                    title: "워크스페이스 설명",
                    placeholder: "워크스페이스를 설명하세요 (옵션)",
                    textFieldGetter: { store.state.createWorkspaceState.description },
                    textFieldSetter: { store.dispatch(.createWorkspaceAction(.writeDescription(description: $0))) },
                    secureFieldGetter: { "" },
                    secureFieldSetter: { _ in },
                    rightButtonAction: {},
                    isValid: true
                )
                
                Spacer()
                
                CustomButton {
                    print("완료")
                    store.dispatch(.navigationAction(.presentCreateWorkspaceView(present: false)))
                } label: {
                    Text("완료")
                }
                .bottomButtonShape(.brandGreen)
            }
        }
    }
}

#Preview {
    CreateWorkspaceView()
}
