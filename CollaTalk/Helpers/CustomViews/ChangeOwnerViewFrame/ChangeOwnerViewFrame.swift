//
//  ChangeOwnerViewFrame.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/31/24.
//

import SwiftUI

struct ChangeOwnerViewFrame<Content: View, Value: Equatable>: View {
    
    @Binding var isPresented: Bool
    let onDisappearAction: (() -> Void)?
    let onChangeValue: Value
    let onChangeAction: (Value) -> Void
    let content: Content
    let isChangingChannelOwnerShip: Bool
    
    init(
        isPresented: Binding<Bool>,
        onDisappearAction: (() -> Void)? = nil,
        onChangeValue: Value,
        onChangeAction: @escaping (Value) -> Void,
        content: () -> Content,
        isChangingChannelOwnerShip: Bool = false
    ) {
        self._isPresented = isPresented
        self.onDisappearAction = onDisappearAction
        self.onChangeValue = onChangeValue
        self.onChangeAction = onChangeAction
        self.content = content()
        self.isChangingChannelOwnerShip = isChangingChannelOwnerShip
    }
    
    var body: some View {
        ZStack {
            
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack {
                
                SheetNavigation(
                    title: isChangingChannelOwnerShip ? .changeChannelOwner : .changeWorkspaceOwner,
                    isPresented: $isPresented,
                    transitionAction: {}
                )
                
                content
                
                Spacer()
            }
        }
        .onDisappear(perform: onDisappearAction)
        .onChange(of: onChangeValue, action: onChangeAction)
    }
}
