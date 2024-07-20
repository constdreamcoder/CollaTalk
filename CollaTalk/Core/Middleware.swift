//
//  Middleware.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/8/24.
//

import Foundation
import Combine

typealias Middleware<State, Action> = (State, Action) -> AnyPublisher<Action, Never>

let appMiddleware: Middleware<AppState, AppAction> = { state, action in
    switch action {
    case .dismissToastMessage: break
        
    case .alertAction(let alertAction):
        switch alertAction {
        case .showAlert(let alertType, let confirmAction):
            break
        case .initializeAllAlertElements:
            break
        }
   
    case .initializeNetworkCallSuccessType:
        break
        
    case .networkCallSuccessTypeAction(let networkCallSuccessTypeAction):
        switch networkCallSuccessTypeAction {
        case .setStartView: break
        case .setHomeEmptyView: break
        case .setHomeDefaultView(let workspaces):
            if workspaces.count > 0 {
                return Just(.workspaceAction(.fetchHomeDefaultViewDatas)).eraseToAnyPublisher()
            }
        case .setNone: break
        }
        
    case .navigationAction(let navigationAction):
        switch navigationAction {
        case .presentBottomSheet(let present):
            break
        case .presentLoginView(let present):
            break
        case .presentSignUpView(let present):
            break
        case .presentModifyWorkspaceView(let present, let workspaceModificationType, let selectedWorkspace):
            break
        case .showImagePickerView(let show):
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
                        promise(.success(.workspaceAction(.fetchWorkspaces)))
                    } catch {
                        promise(.success(.loginAction(.loginError(errorMesssage: error.localizedDescription))))
                    }
                }
            }.eraseToAnyPublisher()
        default: break
        }
        
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
        
    case .modifyWorkspaceAction(let addWorkspaceAction):
        switch addWorkspaceAction {
        case .writeName(let name):
            break
        case .writeDescription(let description):
            break
        case .selectImage(let image):
            break
        case .addWorkspace:
            
            let imageData = state.modifyWorkspaceState.selectedImageFromGallery?.pngData() ?? Data()
            
            /// 워크스페이스명 유효성 검사
            let isWorkspaceNameValid = ValidationCheck.workspaceName(input: state.modifyWorkspaceState.name).validation
            
            /// 워크스페이스 커버 이미지 유효성 검사
            let isWorkspaceCoverImageValid = ValidationCheck.workspaceCoverImage(input: imageData).validation
            
            guard isWorkspaceNameValid && isWorkspaceCoverImageValid
            else {
                return Just(
                    .modifyWorkspaceAction(
                        .isValid(
                            isWorkspaceNameValid: isWorkspaceNameValid,
                            isWorkspaceCoverImageValid: isWorkspaceCoverImageValid)
                    )).eraseToAnyPublisher()
            }
            
            return Future<AppAction, Never> { promise in
                Task {
                    do {
                        let image = ImageFile(
                            imageData: imageData,
                            name: Date().timeIntervalSince1970.description,
                            mimeType: .png
                        )
                        
                        let newWorkspace = try await WorkspaceProvider.shared.createWorkspace(
                            name: state.modifyWorkspaceState.name,
                            description: state.modifyWorkspaceState.description,
                            image: image
                        )
                        guard let newWorkspace else { return }
                        print("newWorkspace", newWorkspace)
                        UserDefaultsManager.setObject(newWorkspace, forKey: .selectedWorkspace)
                        promise(.success(.workspaceAction(.fetchWorkspaces)))
                    } catch {
                        promise(.success(.workspaceAction(.workspaceError(error))))
                    }
                }
            }.eraseToAnyPublisher()
        case .isValid(let isWorkspaceNameValid, let isWorkspaceCoverImageValid):
            break
        case .editWorkspace:
            
            let imageData: Data
            
            if state.modifyWorkspaceState.selectedImageFromGallery != nil {
                imageData = state.modifyWorkspaceState.selectedImageFromGallery?.pngData() ?? Data()
            } else {
                guard let existingImageURL = URL(string: "\(APIKeys.baseURL)\(state.modifyWorkspaceState.existingWorkspace?.coverImage ?? "")") else {
                    return Empty().eraseToAnyPublisher()
                }
                imageData = ImageCacheManager.shared.get(for: existingImageURL)?.pngData() ?? Data()
            }

            /// 워크스페이스명 유효성 검사
            let isWorkspaceNameValid = ValidationCheck.workspaceName(input: state.modifyWorkspaceState.name).validation
            
            /// 워크스페이스 커버 이미지 유효성 검사
            let isWorkspaceCoverImageValid = ValidationCheck.workspaceCoverImage(input: imageData).validation
            
            guard isWorkspaceNameValid && isWorkspaceCoverImageValid
            else {
                return Just(
                    .modifyWorkspaceAction(
                        .isValid(
                            isWorkspaceNameValid: isWorkspaceNameValid,
                            isWorkspaceCoverImageValid: isWorkspaceCoverImageValid)
                    )).eraseToAnyPublisher()
            }
            
            return Future<AppAction, Never> { promise in
                Task {
                    do {
                        let image = ImageFile(
                            imageData: imageData,
                            name: Date().timeIntervalSince1970.description,
                            mimeType: .png
                        )
                        
                        let updatedWorkspace = try await WorkspaceProvider.shared.editWorkspace(
                            workspaceId: state.modifyWorkspaceState.existingWorkspace?.workspaceId ?? "",
                            name: state.modifyWorkspaceState.name,
                            description: state.modifyWorkspaceState.description,
                            image: image
                        )
                        guard let updatedWorkspace else { return }
                        print("updatedWorkspace", updatedWorkspace)
                        UserDefaultsManager.setObject(updatedWorkspace, forKey: .selectedWorkspace)
                        promise(.success(.workspaceAction(.fetchWorkspaces)))
                    } catch {
                        promise(.success(.workspaceAction(.workspaceError(error))))
                    }
                }
            }.eraseToAnyPublisher()
        case .initializeAllElements:
            break
        }
        
    case .workspaceAction(let workspaceAction):
        switch workspaceAction {
        case .fetchWorkspaces:
            return Future<AppAction, Never> { promise in
                Task {
                    do {
                        let workspaces = try await WorkspaceProvider.shared.fetchWorkspaces()
                        guard let workspaces else { return }
                        
                        if workspaces.count == 0 {
                            UserDefaultsManager.removeObject(forKey: .selectedWorkspace)
                            promise(.success(.networkCallSuccessTypeAction(.setHomeEmptyView)))
                        } else if workspaces.count >= 1 {
                            if let selectedWorkspace = workspaces.first {
                                UserDefaultsManager.setObject(selectedWorkspace, forKey: .selectedWorkspace)
                            }
                            promise(.success(.networkCallSuccessTypeAction(.setHomeDefaultView(workspaces: workspaces))))
                        }
                    } catch {
                        promise(.success(.workspaceAction(.workspaceError(error))))
                    }
                }
            }.eraseToAnyPublisher()
        case .workspaceError(let error):
            break
        case .toggleSideBarAction:
            break
        case .fetchHomeDefaultViewDatas:
            return Future<AppAction, Never> { promise in
                Task {
                    do {
                        
                        guard let workspace = state.workspaceState.selectedWorkspace else { return }
                        
                        /// 로그인한 유저가 속한 채널 목록 조회
                        async let myChannels = try await WorkspaceProvider.shared.fetchMyChannels(workspaceID: workspace.workspaceId)
                        /// DM방 목록 조회
                        async let dms = try await WorkspaceProvider.shared.fetchMyDMs(workspaceID: workspace.workspaceId)
                        
                        let channelsResult = try await myChannels
                        let dmsResult = try await dms
                        
                        guard let channelsResult, let dmsResult else { return }
                        promise(.success(.workspaceAction(.completeFetchHomeDefaultViewDatas(myChennels: channelsResult, dms: dmsResult))))
                    } catch {
                        promise(.success(.workspaceAction(.workspaceError(error))))
                    }
                }
            }.eraseToAnyPublisher()
        case .completeFetchHomeDefaultViewDatas(let myChennels, let dms):
            break
        case .deleteWorkspace(let workspace):
            return Future<AppAction, Never> { promise in
                Task {
                    do {
                        /// 워크스페이스 삭제
                        guard let workspace else { return }
                        try await WorkspaceProvider.shared.deleteWorkspace(workspaceId: workspace.workspaceId)
                        
                        /// 이전 선택된 워크스페이스 UserDefaults에서 제거
                        UserDefaultsManager.removeObject(forKey: .selectedWorkspace)
                        promise(.success(.workspaceAction(.fetchWorkspaces)))
                    } catch {
                        promise(.success(.workspaceAction(.workspaceError(error))))
                    }
                }
            }.eraseToAnyPublisher()
        }
    }
    
    return Empty().eraseToAnyPublisher()
}
