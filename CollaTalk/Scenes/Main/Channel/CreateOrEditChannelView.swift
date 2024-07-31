//
//  CreateNewChannelView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/30/24.
//

import SwiftUI

struct CreateOrEditChannelView: View {
    @EnvironmentObject private var store: AppStore
    
    var body: some View {
        ZStack {
            
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                SheetNavigation(
                    title: store.state.createOrEditChannel.isEditMode ? .editChannel : .createNewChannel,
                    isPresented: Binding(
                        get: { store.state.navigationState.isCreateOrEditChannelViewPresented },
                        set: { store.dispatch(.navigationAction(.presentCreateOrEditChannelView(present: $0, isEditMode: false))) }
                    ),
                    transitionAction: {}
                )
                
                InputView(
                    title: "채널 이름",
                    placeholder: "채널 이름을 입력하세요 (필수)",
                    textFieldGetter: { store.state.createOrEditChannel.channelName },
                    textFieldSetter: { store.dispatch(.createOrEditChannelAction(.writeName(name: $0))) },
                    secureFieldGetter: { "" },
                    secureFieldSetter: { _ in },
                    rightButtonAction: {},
                    isValid: true
                )
                
                InputView(
                    title: "채널 설명",
                    placeholder: "채널을 설명하세요 (옵션)",
                    textFieldGetter: { store.state.createOrEditChannel.channelDescription },
                    textFieldSetter: { store.dispatch(.createOrEditChannelAction(.writeDescription(description: $0))) },
                    secureFieldGetter: { "" },
                    secureFieldSetter: { _ in },
                    rightButtonAction: {},
                    isValid: true
                )
                
                Spacer()
                
                CustomButton {
                    if store.state.createOrEditChannel.isEditMode {
                        print("완료")
                        store.dispatch(.createOrEditChannelAction(.editChannel))
                    } else {
                        print("생성")
                        store.dispatch(.createOrEditChannelAction(.createNewChannel))
                    }
                } label: {
                    if store.state.createOrEditChannel.isEditMode {
                        Text("완료")
                    } else {
                        Text("생성")
                    }
                }
                .disabled(!createNewChannelButtonValid)
                .bottomButtonShape(createNewChannelButtonValid ? .brandGreen : .brandInactive)
            }
        }
    }
}

extension CreateOrEditChannelView {
    private var createNewChannelButtonValid: Bool {
        !store.state.createOrEditChannel.isChannelNameEmpty
    }
}

#Preview {
    CreateOrEditChannelView()
}
