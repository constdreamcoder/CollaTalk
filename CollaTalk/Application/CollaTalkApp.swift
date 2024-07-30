//
//  CollaTalkApp.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 6/26/24.
//

import SwiftUI

@main
struct CollaTalkApp: App {
    
    private let store = AppStore(
        initial: AppState(),
        reducer: appReducer,
        middlewares: [appMiddleware]
    )
    
    private let windowProvider = WindowProvider()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(windowProvider)
                .onAppear {
                    LocalChannelRepository.shared.getLocationOfDefaultRealm()
                }
        }
    }
}
