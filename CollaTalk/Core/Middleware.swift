//
//  Middleware.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/8/24.
//

import Combine

typealias Middleware<State, Action> = (State, Action) -> AnyPublisher<Action, Never>

let userMiddleware: Middleware<AppState, AppAction> = { state, action in
    switch action {
        
    case .initializeNetworkCallSuccessType:
        break
    case .navigationAction(let navigationAction):
        switch navigationAction {
        case .presentBottomSheet(let present):
            break
        case .presentLoginView(let present):
            break
        case .presentSignUpView(let present):
            break
        case .presentCreateWorkspaceView(let present):
            break
        }
        
    case .loginAction(let loginAction):
        switch loginAction {
            /// 로그인 버튼이 클릭된 경우
        case .login:
            /// 이메일 유효성 검사
            let isEmailValid = ValidationCheck.email(input: state.loginState.email).validation
            
            /// 비밀번호 유효성 검사
            let isPWValid = ValidationCheck.password(input: state.loginState.password).validation
            
            guard isEmailValid && isPWValid
            else {
                return Just(.loginAction(.isValid(isEmailValid: isEmailValid, isPWValid: isPWValid))).eraseToAnyPublisher()
            }
            
            /// 로그인
            return Future<AppAction, Never> { promise in
                Task {
                    do {
                        let userInfo = try await UserProvider.shared.login(
                            email: state.loginState.email,
                            password: state.loginState.password
                        )
                        guard let userInfo else { return }
                        UserDefaultsManager.setObject(userInfo, forKey: .userInfo)
                        promise(.success(.loginAction(.moveToHomeView(userInfo: userInfo))))
                    } catch {
                        promise(.success(.loginAction(.loginError(errorMesssage: error.localizedDescription))))
                    }
                }
            }.eraseToAnyPublisher()
        default: break
        }
    case .dismissToastMessage: break
    case .signUpAction(let signUpAction):
        switch signUpAction {
        case .writeEmail(let email):
            break
        case .emailDoubleCheck:
            
            /// 이메일 유효성 검사 네트워크 재요청 제한
            if state.signUpState.isEmailDoubleChecked {
                return Just(.signUpAction(.sendEmailValidation(isValid: true))).eraseToAnyPublisher()
            }
            
            /// 이메일 유효성 검사
            let isEmailValid = ValidationCheck.email(input: state.signUpState.email).validation
            guard isEmailValid else {
                return Just(.signUpAction(.sendEmailValidation(isValid: false))).eraseToAnyPublisher()
            }
            
            /// 이메일 중복 체크
            return Future<AppAction, Never> { promise in
                Task {
                    do {
                        let isValidEmail = try await UserProvider.shared.validate(email: state.signUpState.email)
                        if isValidEmail {
                            promise(.success(.signUpAction(.sendEmailValidation(isValid: true))))
                        }
                    } catch {
                        promise(.success(.signUpAction(.joinError(error))))
                    }
                }
            }.eraseToAnyPublisher()
            
        case .writeNickname(let nickname):
            break
        case .writePhoneNumber(let phoneNumber):
            break
        case .writePassword(let password):
            break
        case .writePasswordForMatchCheck(let passwordForMatchCheck):
            break
        case .join:
            /// 이메일 유효성 검사
            let isEmailValid = ValidationCheck.email(input: state.signUpState.email).validation
            /// 닉네임 유효성 검사
            let isNicknameValid = ValidationCheck.nickname(input: state.signUpState.nickname).validation
            /// 휴대폰 유효성 검사
            let isPhoneNumberValid = ValidationCheck.phoneNumber(input: state.signUpState.phoneNumber).validation
            /// 비밀번호 유효성 검사
            let isPasswordValid = ValidationCheck.password(input: state.signUpState.password).validation
            /// 비밀번호 확인 유효성 검사
            let isPasswordForMatchCheckValid = ValidationCheck.passwordForMatchCheck(input: state.signUpState.passwordForMatchCheck, password: state.signUpState.password).validation
            
            guard isEmailValid
                    && isNicknameValid
                    && isPhoneNumberValid
                    && isPasswordValid
                    && isPasswordForMatchCheckValid
            else {
                return Just(.signUpAction(
                    .isValid(
                        isEmailValid: isEmailValid,
                        isNicknameValid: isNicknameValid,
                        isPhoneNumberValid: isPhoneNumberValid,
                        isPWValid: isPasswordValid,
                        isPWForMatchCheckValid: isPasswordForMatchCheckValid)
                )).eraseToAnyPublisher()
            }
            
            /// 회원가입
            return Future<AppAction, Never> { promise in
                Task {
                    do {
                        let userInfo = try await UserProvider.shared.join(
                            email: state.signUpState.email,
                            password: state.signUpState.password,
                            nickname: state.signUpState.nickname,
                            phone: state.signUpState.phoneNumber
                        )
                        guard let userInfo else { return }
                        UserDefaultsManager.setObject(userInfo, forKey: .userInfo)
                        promise(.success(.signUpAction(.moveToStartView(userInfo: userInfo))))
                    } catch {
                        promise(.success(.signUpAction(.joinError(error))))
                    }
                }
            }.eraseToAnyPublisher()
                    
        case .sendEmailValidation(let isValid):
            break
        default: break
        }
    case .createWorkspaceAction(let createWorkspaceAction):
        switch createWorkspaceAction {
        case .writeName(let name):
            break
        case .writeDescription(let description):
            break
        }
    }
    
    return Empty().eraseToAnyPublisher()
}
