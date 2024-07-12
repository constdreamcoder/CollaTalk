//
//  CollaTalkApp.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 6/26/24.
//

import SwiftUI

@main
struct CollaTalkApp: App {
    
    let store = AppStore(
        initial: AppState(),
        reducer: appReducer,
        middlewares: [userMiddleware]
    )
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(store)
        }
    }
}
