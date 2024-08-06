//
//  AppleLoginCoodinator.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/6/24.
//

import Foundation
import AuthenticationServices

final class AppleLoginCoodinator: NSObject, ObservableObject {
    
    var store: AppStore?
        
    /// 애플 로그인 실행
    func loginWithAppleID() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension AppleLoginCoodinator: ASAuthorizationControllerDelegate {
    /// 애플 로그인 완료 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
                        
            guard
                let identityToken = appleIDCredential.identityToken,
                let identityTokenString = String(data: identityToken, encoding: .utf8)
            else { return }
            
            var fullname: String? = nil
            if let familyName = fullName?.familyName, let givenName = fullName?.givenName {
                fullname = familyName + givenName
            } else if let familyName = fullName?.familyName, fullName?.givenName == nil {
                fullname = familyName
            } else if fullName?.familyName == nil, let givenName = fullName?.givenName {
                fullname = givenName
            }
            
            guard let store else { return }
            if let fullname = fullname, fullname.isEmpty {
                print("이름이 비어있습니다.")
                store.dispatch(.loginAction(.EmptyNicknameError))
            } else {
                print("fullname", fullname)
                store.dispatch(.loginAction(.loginWithAppleID(idToken: identityTokenString, nickname: fullname)))
            }
            
        case let passwordCredential as ASPasswordCredential:
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            print("username: \(username)")
            print("password: \(password)")
        default:
            break
        }
    }
    
    /// 애플 로그인 오류 발생 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        print("login failed - \(error.localizedDescription)")
    }
}

extension AppleLoginCoodinator: ASAuthorizationControllerPresentationContextProviding {
    /// 애플 로그인 화면을 표시할 window 선택
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { fatalError("No window found.") }
        
        return window
    }
}
