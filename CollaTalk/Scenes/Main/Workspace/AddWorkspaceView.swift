//
//  AddWorkspaceView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/11/24.
//

import SwiftUI

struct AddWorkspaceView: View {
    
    @EnvironmentObject private var store: AppStore
    
    var body: some View {
        ZStack {
            
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                NavigationBarForCreatingNewFeature(
                    title: .createWorkspace,
                    isPresented: Binding(
                        get: { store.state.navigationState.isAddWorkspaceViewPresented },
                        set: { store.dispatch(.navigationAction(.presentAddWorkspaceView(present: $0))) }
                    ),
                    transitionAction: {})
                
                Image(.workspace)
                    .resizable()
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(width: 60)
                    .padding(10)
                    .background(.brandWhite)
                    .cornerRadius(8, corners: .allCorners)
                    .overlay(alignment: .bottomTrailing) {
                        Image(.camera)
                            .resizable()
                            .aspectRatio(1.0, contentMode: .fit)
                            .frame(width: 24)
                            .offset(x: 5, y: 5)
                    }
                    
                
                InputView(
                    title: "워크스페이스 이름",
                    placeholder: "워크스페이스 이름을 입력하세요 (필수)",
                    textFieldGetter: { store.state.addWorkspaceState.name },
                    textFieldSetter: { store.dispatch(.addWorkspaceAction(.writeName(name: $0))) },
                    secureFieldGetter: { "" },
                    secureFieldSetter: { _ in },
                    rightButtonAction: {},
                    isValid: true
                )
                
                InputView(
                    title: "워크스페이스 설명",
                    placeholder: "워크스페이스를 설명하세요 (옵션)",
                    textFieldGetter: { store.state.addWorkspaceState.description },
                    textFieldSetter: { store.dispatch(.addWorkspaceAction(.writeDescription(description: $0))) },
                    secureFieldGetter: { "" },
                    secureFieldSetter: { _ in },
                    rightButtonAction: {},
                    isValid: true
                )
                
                Spacer()
                
                CustomButton {
                    print("완료")
                    store.dispatch(.navigationAction(.presentAddWorkspaceView(present: false)))
                } label: {
                    Text("완료")
                }
                .disabled(addWorkspaceButtonValid)
                .bottomButtonShape(addWorkspaceButtonValid ? .brandGreen : .brandInactive)
            }
        }
    }
}

extension AddWorkspaceView {
    private var addWorkspaceButtonValid: Bool {
        !store.state.addWorkspaceState.isNameEmpty
    }
}

#Preview {
    AddWorkspaceView()
}
