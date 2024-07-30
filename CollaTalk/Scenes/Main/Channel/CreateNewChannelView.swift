//
//  CreateNewChannelView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/30/24.
//

import SwiftUI

struct CreateNewChannelView: View {
    @EnvironmentObject private var store: AppStore
    
    var body: some View {
        ZStack {
            
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                SheetNavigation(
                    title: .createNewChannel,
                    isPresented: Binding(
                        get: { store.state.navigationState.isCreateNewChannelViewPresented },
                        set: { store.dispatch(.navigationAction(.presentCreateNewChannelView(present: $0)))
                        }
                    ),
                    transitionAction: {}
                )
                
                InputView(
                    title: "채널 이름",
                    placeholder: "채널 이름을 입력하세요 (필수)",
                    textFieldGetter: { store.state.createNewChannel.channelName },
                    textFieldSetter: { store.dispatch(.createNewChannelAction(.writeName(name: $0))) },
                    secureFieldGetter: { "" },
                    secureFieldSetter: { _ in },
                    rightButtonAction: {},
                    isValid: true
                )
                
                InputView(
                    title: "채널 설명",
                    placeholder: "채널을 설명하세요 (옵션)",
                    textFieldGetter: { store.state.createNewChannel.channelDescription },
                    textFieldSetter: { store.dispatch(.createNewChannelAction(.writeDescription(description: $0))) },
                    secureFieldGetter: { "" },
                    secureFieldSetter: { _ in },
                    rightButtonAction: {},
                    isValid: true
                )
                
                Spacer()
                
                CustomButton {
                    print("생성")
                    store.dispatch(.createNewChannelAction(.createNewChannel))
                } label: {
                    Text("생성")
                }
                .disabled(!createNewChannelButtonValid)
                .bottomButtonShape(createNewChannelButtonValid ? .brandGreen : .brandInactive)
            }
        }
    }
}

extension CreateNewChannelView {
    private var createNewChannelButtonValid: Bool {
        !store.state.createNewChannel.isChannelNameEmpty
    }
}

#Preview {
    CreateNewChannelView()
}
