//
//  Actions.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/8/24.
//

import UIKit

enum AppAction {
    case navigationAction(NavigationAction)
    case loginAction(LoginAction)
    case signUpAction(SignUpAction)
    case addWorkspaceAction(AddWorkspaceAction)
    case workspaceAction(WorkspaceAction)
    case networkCallSuccessTypeAction(NetworkCallSuccessType)
    case dismissToastMessage
    case initializeNetworkCallSuccessType
    
    enum NetworkCallSuccessType {
        case setStartView
        case setHomeEmptyView
        case setHomeDefaultView(workspaces: [Workspace])
        case setNone
    }
    
    enum NavigationAction {
        case presentBottomSheet(present: Bool)
        case presentLoginView(present: Bool)
        case presentSignUpView(present: Bool)
        case presentAddWorkspaceView(present: Bool)
        case showImagePickerView(show: Bool)
    }
    
    enum LoginAction {
        case login
        case writeEmail(email: String)
        case writePassword(password: String)
        case moveToHomeView(userInfo: UserInfo)
        case isValid(isEmailValid: Bool, isPWValid: Bool)
        case loginError(errorMesssage: String?)
        case disappearView
    }
    
    enum SignUpAction {
        case writeEmail(email: String)
        case emailDoubleCheck
        case writeNickname(nickname: String)
        case writePhoneNumber(phoneNumber: String)
        case writePassword(password: String)
        case writePasswordForMatchCheck(passwordForMatchCheck: String)
        case join
        case sendEmailValidation(isValid: Bool)
        case isValid(isEmailValid: Bool, isNicknameValid: Bool, isPhoneNumberValid: Bool, isPWValid: Bool, isPWForMatchCheckValid: Bool)
        case joinError(Error)
        case moveToStartView(userInfo: UserInfo)
    }
    
    enum AddWorkspaceAction {
        case selectImage(image: UIImage)
        case writeName(name: String)
        case writeDescription(description: String)
        case addWorkspace
        case moveToHomeView(newWorkspace: Workspace)
        case isValid(isWorkspaceNameValid: Bool, isWorkspaceCoverImageValid: Bool)
    }
    
    enum WorkspaceAction {
        case fetchWorkspaces
        case workspaceError(Error)
        case toggleSideBarAction
        case fetchHomeDefaultViewDatas
        case completeFetchHomeDefaultViewDatas(myChennels: [Channel])
    }
}
