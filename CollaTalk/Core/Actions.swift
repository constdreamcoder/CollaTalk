//
//  Actions.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/8/24.
//

import UIKit
import _PhotosUI_SwiftUI

enum AppAction {
    
    case dismissToastMessage
    case initializeNetworkCallSuccessType
    
    case navigationAction(NavigationAction)
    case loginAction(LoginAction)
    case signUpAction(SignUpAction)
    case homeAction(HomeAction)
    case tabAction(TabAction)
    case modifyWorkspaceAction(ModifyWorkspaceAction)
    case workspaceAction(WorkspaceAction)
    case networkCallSuccessTypeAction(NetworkCallSuccessType)
    case alertAction(AlertAction)
    case changeWorkspaceOwnerAction(ChangeWorkspaceOwnerAction)
    case inviteMemeberAction(InviteMemeberAction)
    case createNewChannelAction(CreateNewChannelAction)
    case dmAction(DMAction)
    case channelAction(ChannelAction)
    case chatAction(ChatAction)
    case searchChannelAction(SearchChannelAction)
    
    enum LoadingAction {
        case isLoadingDisplayed(isLoading: Bool)
    }
    
    enum NetworkCallSuccessType {
        case setStartView
        case setHomeEmptyView
        case setHomeDefaultView(workspaces: [Workspace])
        case setDMChatView(chatRoom: DMRoom, dms: groupdDMsType)
        case setChannelChatView(channel: Channel, channelChats: groupdChannelChatsType)
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
        case presentCreateNewChannelView(present: Bool)
        case presentSearchChannelView(present: Bool, allChannels: [Channel])
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
    
    enum HomeAction {
        case refresh
    }
    
    enum TabAction {
        case moveToHomeTab
        case moveToDMTabWithNetowrkCall
        case moveToDMTab
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
        case completeFetchHomeDefaultViewDatas(myChennels: [LocalChannel], dmRooms: [LocalDMRoom])
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
    
    enum CreateNewChannelAction {
        case writeName(name: String)
        case writeDescription(description: String)
        case createNewChannel
        case createNewChannelError(Error)
        case returnToHomeView
        case nameValidationError
    }
    
    enum DMAction {
        case refresh
        case completeConfigrationDMView(workspaceMembers: [WorkspaceMember], dmRooms: [LocalDMRoom])
        case dmError(Error)
        case createOrFetchChatRoom(chatRoomType: ChatRoomType, opponent: WorkspaceMember)
    }
    
    enum ChannelAction {
        case fetchChannelChats(chatRoomType: ChatRoomType, channel: Channel)
        case channelError(Error)
    }
    
    enum ChatAction {
        case chatError(Error)
        case initializeAllElements
        case sendNewMessage
        case completeSendDMAction
        case completeSendChannelChatAction
        case writeMessage(message: String)
        case appendNewImages(newImages: [UIImage])
        case removeSelectedImage(image: UIImage)
        case handleSelectedPhotos(newPhotos: [PhotosPickerItem])
        case receiveNewDirectMessage(receivedDM: DirectMessage)
        case receiveNewChannelChat(receivedChannelChat: ChannelChat)
        case updateDirectMessages(dms: groupdDMsType)
        case updateChannelChats(channelChats: groupdChannelChatsType)
    }
    
    enum SearchChannelAction {
        case fetchAllChannels
        case SearchChannelError(Error)
    }
}
