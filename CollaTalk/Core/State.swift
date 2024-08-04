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
    var changeChannelOwnerState = ChangeChannelOwnerState()
    var inviteMemberState = InviteMemberState()
    var createOrEditChannel = CreateOrEditChannelState()
    var dmState = DMState()
    var chatState = ChatState()
    var channelState = ChannelState()
    var searchChannelState = SearchChannelState()
    var channelSettingState = ChannelSettingState()
    var myProfileState = MyProfileState()
    var editNicknameState = EditNicknameState()
    var editPhoneState = EditPhoneState()
    var imagePickerState = ImagePickerState()
    var coinShopState = CoinShopState()
    
    struct NavigationState {
        var isBottomSheetPresented: Bool = false
        var isLoginViewPresented: Bool = false
        var isSignUpViewPresented: Bool = false
        var isModifyWorkspaceViewPresented: Bool = false
        var isSidebarVisible: Bool = false
        var showImagePicker: Bool = false
        var isChangeWorkspaceOwnerViewPresented: Bool = false
        var isChangeChannelOwnerViewPresented: Bool = false
        var isInviteMemeberViewPresented: Bool = false
        var isCreateOrEditChannelViewPresented: Bool = false
        var isSearchChannelViewPresented: Bool = false
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
        var myChannels: [LocalChannel] = []
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
    
    struct ChangeChannelOwnerState {
        var channelMembers: [WorkspaceMember] = []
    }
    
    struct InviteMemberState {
        var email: String = ""
        var isEmailEmpty: Bool = true
    }
    
    struct CreateOrEditChannelState {
        var channelName: String = ""
        var isChannelNameEmpty: Bool = true
        var channelDescription: String = ""
        var isEditMode: Bool = false
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
    
    /// 채널 채팅 화면 State
    struct ChannelState {
        var channel: Channel? = nil
        var channelChats: groupdChannelChatsType = []
        var channelChatCount: Int = 0
    }
    
    struct SearchChannelState {
        var allChannels: [Channel] = []
        var isAlreadyJoined: Bool = false
    }
    
    struct ChannelSettingState {
        var channelDetails: Channel? = nil
    }
    
    struct MyProfileState {
        var myProfile: MyProfile? = nil
    }
    
    struct ImagePickerState {
        var isEditProfileMode: Bool = false
    }
    
    struct EditNicknameState {
        var nickname: String = ""
        var isNicknameEmpty: Bool = true
    }
    
    struct EditPhoneState {
        var phoneNumber: String = ""
        var isPhoneNumberEmpty: Bool = true
    }
    
    struct CoinShopState {
        var coinItemList: [CoinItem] = []
    }
}
