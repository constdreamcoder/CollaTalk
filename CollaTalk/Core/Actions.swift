//
//  Actions.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/8/24.
//

import UIKit

enum AppAction {
    
    case dismissToastMessage
    case initializeNetworkCallSuccessType
    
    case navigationAction(NavigationAction)
    case loginAction(LoginAction)
    case signUpAction(SignUpAction)
    case modifyWorkspaceAction(ModifyWorkspaceAction)
    case workspaceAction(WorkspaceAction)
    case networkCallSuccessTypeAction(NetworkCallSuccessType)
    case alertAction(AlertAction)
    case changeWorkspaceOwnerAction(ChangeWorkspaceOwnerAction)
    case inviteMemeberAction(InviteMemeberAction)
    
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
        case presentModifyWorkspaceView(present: Bool, workspaceModificationType: WorkspaceModificationType, selectedWorkspace: Workspace? = nil)
        case showImagePickerView(show: Bool)
        case presentChangeWorkspaceOwnerView(present: Bool, workspace: Workspace? = nil)
        case presentInviteMemeberView(present: Bool)
    }
    
    enum LoginAction {
        case login
        case writeEmail(email: String)
        case writePassword(password: String)
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
    
    enum ModifyWorkspaceAction {
        case selectImage(image: UIImage)
        case dismissGallery(selectedImage: UIImage)
        case writeName(name: String)
        case writeDescription(description: String)
        case showToastMessageForImageDataLimit
        case addWorkspace
        case editWorkspace
        case fetchUpdatedWorkspaces
        case returnToSideBar(updatedWorkspaces: [Workspace])
        case isValid(isWorkspaceNameValid: Bool, isWorkspaceCoverImageValid: Bool)
        case initializeAllElements
    }
    
    enum WorkspaceAction {
        case fetchWorkspaces
        case workspaceError(Error)
        case toggleSideBarAction
        case fetchHomeDefaultViewDatas
        case completeFetchHomeDefaultViewDatas(myChennels: [Channel], dms: [DM])
        case deleteWorkspace(workspace: Workspace?)
        case selectWorkspace(workspace: Workspace?)
    }
    
    enum AlertAction {
        case showAlert(alertType: AlertType, confirmAction: () -> Void)
        case initializeAllAlertElements
    }
    
    enum ChangeWorkspaceOwnerAction {
        case fetchWorkspaceMember(workspace: Workspace?)
        case showToChangeWorkspaceOwnerView(workspaceMembers: [WorkspaceMember])
        case changeWorkspaceOwnerError(Error)
        case changeWorkspaceOwnerShip(member: WorkspaceMember)
        case fetchWorkspaceAfterUpdatingWorkspaceOwnership
        case returnToSideBar(updatedWorkspaces: [Workspace])
        case initializeAllElements
    }
    
    enum InviteMemeberAction {
        case writeEmail(email: String)
        case inviteMember
        case returnToHomeView(newWorkspaceMember: WorkspaceMember)
        case inviteMemberError(Error)
        case isValid(isEmailValid: Bool)
        case showToastMessageForNoRightToInviteMember
    }
}
