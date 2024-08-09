//
//  CollaTalkApp.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 6/26/24.
//

import SwiftUI
import iamport_ios
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct CollaTalkApp: App {
    private let store = AppStore(
        initial: AppState(),
        reducer: appReducer,
        middlewares: [appMiddleware]
    )
    
    private let windowProvider = WindowProvider()
    
    init() {
        KakaoSDK.initSDK(appKey: APIKeys.kakaoNativeAppKey)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(windowProvider)
                .onAppear {
                    LocalChannelRepository.shared.getLocationOfDefaultRealm()
                }
                .onOpenURL(perform: { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        let _ = AuthController.handleOpenUrl(url: url)
                    } else {
                        Iamport.shared.receivedURL(url)
                    }
                })
        }
    }
}
