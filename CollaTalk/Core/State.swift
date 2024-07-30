//
//  State.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/8/24.
//

import UIKit

struct AppState {
    
    var user: UserInfo? = nil
    var showToast: Bool = false
    var toastMessage: String = ""
    var isLoading: Bool = false
    var networkCallSuccessType: PathType = .none
    
    var tabState = TabState()
    var alertState = AlertState()
    var navigationState = NavigationState()
    var loginState = LoginState()
    var signUpState = SignUpState()
    var modifyWorkspaceState = ModifyWorkspaceState()
    var workspaceState = WorkspaceState()
    var changeWorkspaceOwnerState = ChangeWorkspaceOwnerState()
    var inviteMemberState = InviteMemberState()
    var dmState = DMState()
    var chatState = ChatState()
    var channelState = ChannelState()
    
    struct NavigationState {
        var isBottomSheetPresented: Bool = false
        var isLoginViewPresented: Bool = false
        var isSignUpViewPresented: Bool = false
        var isModifyWorkspaceViewPresented: Bool = false
        var isSidebarVisible: Bool = false
        var showImagePicker: Bool = false
        var isChangeWorkspaceOwnerViewPresented: Bool = false
        var isInviteMemeberViewPresented: Bool = false
    }
   
    struct LoginState {
        var email: String = ""
        var password: String = ""
        var isEmailEmpty: Bool = true
        var isPWEmpty: Bool = true
        var isEmailValid: Bool = true
        var isPWValid: Bool = true
    }
    
    struct SignUpState {
        var email: String = ""
        var nickname: String = ""
        var phoneNumber: String = ""
        var password: String = ""
        var passwordForMatchCheck: String = ""
        var isEmailEmpty: Bool = true
        var isNicknameEmpty: Bool = true
        var isPWEmpty: Bool = true
        var isPWForMatchCheckEmpty: Bool = true
        
        var isEmailDoubleChecked: Bool = false
        
        var isEmailValid: Bool = true
        var isNicknameValid: Bool = true
        var isPhoneNumberValid: Bool = true
        var isPWValid: Bool = true
        var isPWForMatchCheckValid: Bool = true
    }
    
    struct ModifyWorkspaceState {
        var workspaceModificationType: WorkspaceModificationType = .create
        var selectedImageFromGallery: UIImage? = nil
        var existingWorkspace: Workspace? = nil
        var name: String = ""
        var description: String = ""

        var isNameEmpty: Bool = true
        var isDescriptionEmpty: Bool = true
    }
    
    struct WorkspaceState {
        var selectedWorkspace: Workspace? = nil
        var workspaces: [Workspace] = []
        var myChannels: [Channel] = []
        var dmRooms: [LocalDMRoom] = [] // DM 화면 DM 방 목록, TODO: 추후 WorkspaceState로 통합
        var workspaceMembers: [WorkspaceMember] = []
    }
    
    struct TabState {
        var currentTab: MainTab = .home
    }
    
    struct AlertState {
        var showAlert: (alertType: AlertType, confirmAction: () -> Void) = (.none, {})
        var dismissAlert: Bool = false
    }
    
    struct ChangeWorkspaceOwnerState {
        var selectedWorkspace: Workspace? = nil
        var workspaceMembers: [WorkspaceMember] = []
    }
    
    struct InviteMemberState {
        var email: String = ""
        var isEmailEmpty: Bool = true
    }
    /// DM 화면 데이터
    struct DMState {
        var opponent: WorkspaceMember? = nil
        var dmRoom: DMRoom? = nil
        var dms: groupdDMsType = []
        var dmCount: Int = 0
    }
    
    struct ChatState {
        var chatRoomType: ChatRoomType = .dm
        var message: String = ""
        var isMessageEmpty: Bool = false
        var selectedImages: [UIImage] = []
    }
    
    struct ChannelState {
        var channel: Channel? = nil
        var channelChats: groupdChannelChatsType = []
        var channelChatCount: Int = 0
    }
}
