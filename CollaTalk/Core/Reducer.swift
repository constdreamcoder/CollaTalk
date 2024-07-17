//
//  Reducer.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/8/24.
//

import Foundation

typealias Reducer<State, Action> = (State, Action) -> State

let appReducer: Reducer<AppState, AppAction> = { state, action in
    var mutatingState = state
    
    switch action {
    case .initializeNetworkCallSuccessType:
        mutatingState.networkCallSuccessType = .none
        
    case .dismissToastMessage:
        mutatingState.showToast = false
        
    case .navigationAction(let navigationAction):
        switch navigationAction {
        case .presentBottomSheet(let present):
            mutatingState.navigationState.isBottomSheetPresented = present
        case .presentLoginView(let present):
            mutatingState.navigationState.isLoginViewPresented = present
        case .presentSignUpView(let present):
            mutatingState.navigationState.isSignUpViewPresented = present
        case .presentAddWorkspaceView(let present):
            mutatingState.navigationState.isAddWorkspaceViewPresented = present
        case .showImagePickerView(let show):
            mutatingState.navigationState.showImagePicker = show
        }
            
    case .loginAction(let loginAction):
        switch loginAction {
        case .writeEmail(let email):
            mutatingState.loginState.email = email
            mutatingState.loginState.isEmailEmpty = email.isEmpty
        case .writePassword(let password):
            mutatingState.loginState.password = password
            mutatingState.loginState.isPWEmpty = password.isEmpty
        case .loginError(let errorMessage):
            mutatingState.isLoading = false
            
            mutatingState.toastMessage = ToastMessage.login(.failToLogin).message
            mutatingState.showToast = true
        case .isValid(let isEmailValid, let isPWValid):
            mutatingState.loginState.isEmailValid = isEmailValid
            mutatingState.loginState.isPWValid = isPWValid
            if !isEmailValid {
                mutatingState.toastMessage = ToastMessage.login(.emailValidationError).message
            } else if !isPWValid {
                mutatingState.toastMessage = ToastMessage.login(.passwordValidationError).message
            } else {
                mutatingState.toastMessage = ToastMessage.login(.etc).message
            }
            
            mutatingState.isLoading = false
            
            mutatingState.showToast = !isEmailValid || !isPWValid
        case .disappearView:
            mutatingState.showToast = false
            mutatingState.toastMessage = ""
            
            mutatingState.loginState.email = ""
            mutatingState.loginState.password = ""
            mutatingState.loginState.isEmailEmpty = true
            mutatingState.loginState.isPWEmpty = true
            mutatingState.loginState.isEmailValid = true
            mutatingState.loginState.isPWValid = true
            
        case .login:
            mutatingState.isLoading = true
        }
        
    case .signUpAction(let signUpAction):
        switch signUpAction {
        case .writeEmail(let email):
            mutatingState.signUpState.email = email
            mutatingState.signUpState.isEmailEmpty = email.isEmpty
            mutatingState.signUpState.isEmailDoubleChecked = false
        case .writeNickname(let nickname):
            mutatingState.signUpState.nickname = nickname
            mutatingState.signUpState.isNicknameEmpty = nickname.isEmpty
        case .writePhoneNumber(let phoneNumber):
            mutatingState.signUpState.phoneNumber = phoneNumber
        case .writePassword(let password):
            mutatingState.signUpState.password = password
            mutatingState.signUpState.isPWEmpty = password.isEmpty
        case .writePasswordForMatchCheck(let passwordForMatchCheck):
            mutatingState.signUpState.passwordForMatchCheck = passwordForMatchCheck
            mutatingState.signUpState.isPWForMatchCheckEmpty = passwordForMatchCheck.isEmpty
        case .sendEmailValidation(let isValid):
            mutatingState.signUpState.isEmailDoubleChecked = isValid
            mutatingState.toastMessage = isValid ? ToastMessage.signUp(.emailAvailable).message : ToastMessage.signUp(.emailNotConfirmed).message
            
            mutatingState.showToast = true
        case .isValid(
            let isEmailValid,
            let isNicknameValid,
            let isPhoneNumberValid,
            let isPWValid,
            let isPWForMatchCheckValid):
            
            mutatingState.signUpState.isEmailValid = isEmailValid && mutatingState.signUpState.isEmailDoubleChecked
            mutatingState.signUpState.isNicknameValid = isNicknameValid
            mutatingState.signUpState.isPhoneNumberValid = isPhoneNumberValid
            mutatingState.signUpState.isPWValid = isPWValid
            mutatingState.signUpState.isPWForMatchCheckValid = isPWForMatchCheckValid
            
            if !isEmailValid || !mutatingState.signUpState.isEmailDoubleChecked {
                mutatingState.toastMessage = ToastMessage.signUp(.emailNotConfirmed).message
            } else if !isNicknameValid {
                mutatingState.toastMessage = ToastMessage.signUp(.nicknameValidationError).message
            } else if !isPhoneNumberValid {
                mutatingState.toastMessage = ToastMessage.signUp(.phoneNumberValidationError).message
            } else if !isPWValid {
                mutatingState.toastMessage = ToastMessage.signUp(.passwordValidationError).message
            } else if !isPWForMatchCheckValid {
                mutatingState.toastMessage = ToastMessage.signUp(.passwordForMatchCheckValidationError).message
            } else {
                mutatingState.toastMessage = ToastMessage.signUp(.etc).message
            }
            
            mutatingState.isLoading = false
            
            mutatingState.showToast = isEmailValid || isNicknameValid || isPhoneNumberValid || isPWValid || isPWForMatchCheckValid
            
        case .emailDoubleCheck:
            break
        case .join:
            mutatingState.isLoading = true
            
        case .joinError(let error):
            
            if let error = error as? JoinError {
                if error == JoinError.duplicatedData {
                    mutatingState.toastMessage = ToastMessage.signUp(.joindAccount).message
                } else if error == JoinError.badRequest {
                    mutatingState.toastMessage = ToastMessage.signUp(.etc).message
                }
                
                mutatingState.isLoading = false
                
                mutatingState.showToast = true
            }
        case .moveToStartView(let userInfo):
            mutatingState.signUpState.email = ""
            mutatingState.signUpState.nickname = ""
            mutatingState.signUpState.phoneNumber = ""
            mutatingState.signUpState.password = ""
            mutatingState.signUpState.passwordForMatchCheck = ""
            
            mutatingState.user = userInfo
            
            mutatingState.isLoading = false
            
            mutatingState.networkCallSuccessType = .startView
        }
        
    case .addWorkspaceAction(let addWorkspaceAction):
        switch addWorkspaceAction {
        case .writeName(let name):
            mutatingState.addWorkspaceState.name = name
            mutatingState.addWorkspaceState.isNameEmpty = name.isEmpty
        case .writeDescription(let description):
            mutatingState.addWorkspaceState.description = description
            mutatingState.addWorkspaceState.isDescriptionEmpty = description.isEmpty
        case .selectImage(let imageData):
            mutatingState.addWorkspaceState.selectedImage = imageData
        case .addWorkspace:
            mutatingState.isLoading = true
        case .moveToHomeView(let newWorkspace):
            mutatingState.workspaceState.workspaces.insert(newWorkspace, at: 0)
            mutatingState.workspaceState.selectedWorkspace = newWorkspace
            
            mutatingState.isLoading = false
            
            mutatingState.networkCallSuccessType = .homeView
        case .isValid(let isWorkspaceNameValid, let isWorkspaceCoverImageValid):
            
            mutatingState.isLoading = false

            if !isWorkspaceNameValid {
                mutatingState.toastMessage = ToastMessage.addWorkspace(.workspaceNameError).message
            } else if !isWorkspaceCoverImageValid {
                mutatingState.toastMessage = ToastMessage.addWorkspace(.noImage).message
            }
            
            mutatingState.showToast = true
        }
    case .workspaceAction(let workspaceAction):
        switch workspaceAction {
        case .fetchWorkspaces:
            mutatingState.user = UserDefaultsManager.getObject(forKey: .userInfo, as: UserInfo.self)
            mutatingState.isLoading = true
        case .workspaceError(let error):
            if let error = error as? CommonError {
                switch error {
                case .invalidAccessAuthorization:
                    print(error.localizedDescription)
                case .unknownRouterRoute:
                    print(error.localizedDescription)
                case .expiredAccessToken:
                    print(error.localizedDescription)
                case .invalidToken:
                    print(error.localizedDescription)
                case .unknownUser:
                    print(error.localizedDescription)
                case .excesssiveCalls:
                    print(error.localizedDescription)
                case .serverError:
                    print(error.localizedDescription)
                }
            } else if let error = error as? CreateWorkspaceError {
                switch error {
                case .badRequest:
                    print(error.localizedDescription)
                case .duplicatedData:
                    print(error.localizedDescription)
                case .lackOfCoins:
                    print(error.localizedDescription)
                }
            }
            mutatingState.isLoading = false

        case .toggleSideBarAction:
            mutatingState.navigationState.isSidebarVisible.toggle()
        case .fetchHomeDefaultViewDatas:
            mutatingState.isLoading = true
        case .completeFetchHomeDefaultViewDatas(let myChennels, let dms):
            mutatingState.workspaceState.myChannels = myChennels
            mutatingState.workspaceState.dms = dms
            
            mutatingState.isLoading = false
        }
    case .networkCallSuccessTypeAction(let networkCallSuccessTypeAction):
        switch networkCallSuccessTypeAction {
        case .setStartView: break
        case .setHomeEmptyView:
            mutatingState.networkCallSuccessType = .homeView
        case .setHomeDefaultView(let workspaces):
            mutatingState.networkCallSuccessType = .homeView
            mutatingState.workspaceState.workspaces = workspaces
            mutatingState.workspaceState.selectedWorkspace = UserDefaultsManager.getObject(forKey: .selectedWorkspace, as: Workspace.self) ?? workspaces.first
        case .setNone: break
        }
        mutatingState.isLoading = false
    }
    return mutatingState
}
