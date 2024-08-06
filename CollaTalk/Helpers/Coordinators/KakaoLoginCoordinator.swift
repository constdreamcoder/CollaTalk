//
//  KakaoLoginCoordinator.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/6/24.
//

import Foundation
import KakaoSDKUser

final class KakaoLoginCoordinator: ObservableObject {
    
    var store: AppStore?
        
    /// 카카오 로그인 실행
    func startLoginWithKakaoTalk() {
        /// 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            /// 카카오톡 연결 및 실행
            UserApi.shared.loginWithKakaoTalk { [weak self] oauthToken, error in
                guard let self else { return }
                
                if let error = error {
                    print("Fail to login with KakaoTalk.")
                    print(error)
                }
                else {
                    print("Successfully login with KakaoTak.")
                    
                    guard let store, let oauthToken else { return }
                    /// 서버로 로그인 요청
                    store.dispatch(.loginAction(.loginWithKakao(oauthToken: oauthToken.accessToken)))
                }
            }
        }
    }
}
