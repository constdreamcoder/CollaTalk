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
        
    case .homeAction(let homeAction):
        switch homeAction {
        case .refresh:
            mutatingState.isLoading = true
        }
    case .tabAction(let tabAction):
        switch tabAction {
        case .moveToDMTabWithNetowrkCall:
            mutatingState.isLoading = true
            break
        case .moveToDMTab:
            mutatingState.tabState.currentTab = .dm
        case .moveToHomeTab:
            mutatingState.tabState.currentTab = .home
        }
    case .initializeNetworkCallSuccessType:
        mutatingState.networkCallSuccessType = .none
        
    case .alertAction(let alertAction):
        switch alertAction {
        case .showAlert(let alertType, let confirmAction):
            mutatingState.alertState.showAlert = (alertType, confirmAction)
        case .initializeAllAlertElements:
            mutatingState.alertState.showAlert = (.none, {})
            mutatingState.alertState.dismissAlert = false
        }
        
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
        case .presentModifyWorkspaceView(let present, let workspaceModificationType, let selectedWorkspace):
            mutatingState.navigationState.isModifyWorkspaceViewPresented = present
            mutatingState.modifyWorkspaceState.workspaceModificationType = workspaceModificationType
            switch workspaceModificationType {
            case .edit:
                if selectedWorkspace != nil {
                    mutatingState.modifyWorkspaceState.existingWorkspace = selectedWorkspace
                    mutatingState.modifyWorkspaceState.name = selectedWorkspace?.name ?? ""
                    mutatingState.modifyWorkspaceState.description = selectedWorkspace?.description ?? ""
                }
            default: break
            }
        case .showImagePickerView(let show):
            mutatingState.navigationState.showImagePicker = show
        case .presentChangeWorkspaceOwnerView(let present, let workspace):
            mutatingState.navigationState.isChangeWorkspaceOwnerViewPresented = present
        case .presentInviteMemeberView(let present):
            mutatingState.navigationState.isInviteMemeberViewPresented = present
        case .presentCreateOrEditChannelView(let present, let isEditMode):
            mutatingState.navigationState.isCreateOrEditChannelViewPresented = present
            mutatingState.createOrEditChannel.isEditMode = isEditMode
        case .presentSearchChannelView(let present, let allChannels):
            mutatingState.isLoading = false
            mutatingState.navigationState.isSearchChannelViewPresented = present
            mutatingState.searchChannelState.allChannels = allChannels
        case .presentChangeChannelOwnerView(let present):
            mutatingState.navigationState.isChangeChannelOwnerViewPresented = present
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
        
    case .modifyWorkspaceAction(let addWorkspaceAction):
        switch addWorkspaceAction {
        case .writeName(let name):
            mutatingState.modifyWorkspaceState.name = name
            mutatingState.modifyWorkspaceState.isNameEmpty = name.isEmpty
        case .writeDescription(let description):
            mutatingState.modifyWorkspaceState.description = description
            mutatingState.modifyWorkspaceState.isDescriptionEmpty = description.isEmpty
        case .selectImage(let image):
            break
        case .addWorkspace:
            mutatingState.isLoading = true
        case .isValid(let isWorkspaceNameValid, let isWorkspaceCoverImageValid):
            
            mutatingState.isLoading = false
            
            if !isWorkspaceNameValid {
                mutatingState.toastMessage = ToastMessage.modifyWorkspace(.workspaceNameError).message
            } else if !isWorkspaceCoverImageValid {
                mutatingState.toastMessage = ToastMessage.modifyWorkspace(.noImage).message
            }
            
            mutatingState.showToast = true
        case .editWorkspace:
            mutatingState.isLoading = true
        case .initializeAllElements:
            mutatingState.modifyWorkspaceState.workspaceModificationType = .create
            mutatingState.modifyWorkspaceState.selectedImageFromGallery = nil
            mutatingState.modifyWorkspaceState.existingWorkspace = nil
            mutatingState.modifyWorkspaceState.name = ""
            mutatingState.modifyWorkspaceState.description = ""
            
            mutatingState.modifyWorkspaceState.isNameEmpty = true
            mutatingState.modifyWorkspaceState.isDescriptionEmpty = true
        case .fetchUpdatedWorkspaces:
            mutatingState.isLoading = true
        case .returnToSideBar(let updatedWorkspaces):
            mutatingState.isLoading = false
            mutatingState.workspaceState.workspaces = updatedWorkspaces
            
            mutatingState.navigationState.isModifyWorkspaceViewPresented = false
            
            mutatingState.toastMessage = ToastMessage.modifyWorkspace(.completeEditing).message
            mutatingState.showToast = true
        case .dismissGallery(let selectedImage):
            mutatingState.modifyWorkspaceState.selectedImageFromGallery = selectedImage
            mutatingState.modifyWorkspaceState.existingWorkspace?.coverImage = ""
            
            mutatingState.navigationState.showImagePicker = false
        case .showToastMessageForImageDataLimit:
            mutatingState.showToast = true
            mutatingState.toastMessage = ToastMessage.modifyWorkspace(.imageDataLimit).message
        }
    case .workspaceAction(let workspaceAction):
        switch workspaceAction {
        case .fetchWorkspaces:
            mutatingState.user = UserDefaultsManager.getObject(forKey: .userInfo, as: UserInfo.self)
            
            mutatingState.alertState.dismissAlert = true
            
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
            } else if let error = error as? FetchMyChannelsError {
                switch error {
                case .noData:
                    print(error.localizedDescription)
                }
            } else if let error = error as? FetchDMsError {
                switch error {
                case .noData:
                    print(error.localizedDescription)
                }
            } else if let error = error as? EditWorkspaceError {
                switch error {
                case .badRequest:
                    print(error.localizedDescription)
                case .duplicatedData:
                    print(error.localizedDescription)
                case .noData:
                    print(error.localizedDescription)
                case .noAccess:
                    print(error.localizedDescription)
                }
            } else if let error = error as? DeleteWorkspaceError {
                switch error {
                case .noData:
                    print(error.localizedDescription)
                case .noAccess:
                    print(error.localizedDescription)
                }
            }
            
            mutatingState.isLoading = false
            
        case .toggleSideBarAction:
            mutatingState.navigationState.isSidebarVisible.toggle()
        case .fetchHomeDefaultViewDatas:
            mutatingState.isLoading = true
        case .completeFetchHomeDefaultViewDatas(let myChennels, let dmRooms):
            mutatingState.isLoading = false

            mutatingState.workspaceState.myChannels = myChennels
            mutatingState.workspaceState.dmRooms = dmRooms
           
            /// 채널 관리자 변경 후, 화면 전환 중인지 여부에 따른 분기처리
            if mutatingState.networkCallSuccessType == .popFromChannelSettingViewToSideBar {
                mutatingState.networkCallSuccessType = .none
            } else {
                mutatingState.navigationState.isSidebarVisible = false
            }
                                    
        case .deleteWorkspace(let workspace):
            mutatingState.isLoading = true
        case .selectWorkspace(let workspace):
            mutatingState.workspaceState.selectedWorkspace = workspace
        }
    case .networkCallSuccessTypeAction(let networkCallSuccessTypeAction):
        switch networkCallSuccessTypeAction {
        case .setStartView: break
        case .setHomeEmptyView:
            mutatingState.networkCallSuccessType = .homeView
            mutatingState.workspaceState.selectedWorkspace = nil
        case .setHomeDefaultView(let workspaces):
            mutatingState.workspaceState.workspaces = workspaces
            mutatingState.workspaceState.selectedWorkspace = workspaces.first
        
            /// 채널 관리자 변경 후, 화면 전환 중이지 않을 때만 홈 화면으로 이동
            if !(mutatingState.networkCallSuccessType == .popFromChannelSettingViewToSideBar) {
                mutatingState.networkCallSuccessType = .homeView
            }
            
        case .setDMChatView(let chatRoom, let dms):
            mutatingState.isLoading = false
            
            mutatingState.dmState.dmRoom = chatRoom
            mutatingState.dmState.dms = dms
            mutatingState.dmState.dmCount = dms.count
            
            mutatingState.networkCallSuccessType = .chatView
        case .setNone: break
        case .setChannelChatView(let channel, let channelChats):
            mutatingState.isLoading = false
            
            mutatingState.channelState.channel = channel
            mutatingState.channelState.channelChats = channelChats
            mutatingState.channelState.channelChatCount = channelChats.count
            
            mutatingState.networkCallSuccessType = .chatView
        case .setChannelSettingView(let channelDetails):
            mutatingState.isLoading = false
            
            mutatingState.channelSettingState.channelDetails = channelDetails
            
            /// 채널 편집 모드일 때
            if mutatingState.createOrEditChannel.isEditMode {
                mutatingState.navigationState.isCreateOrEditChannelViewPresented = false
                mutatingState.createOrEditChannel.isEditMode = false
            } else {
                mutatingState.networkCallSuccessType = .channelSettingView
            }
        }
        mutatingState.isLoading = false
    case .changeWorkspaceOwnerAction(let changeWorkspaceOwnerAction):
        switch changeWorkspaceOwnerAction {
        case .fetchWorkspaceMember(let workspace):
            mutatingState.changeWorkspaceOwnerState.selectedWorkspace = workspace
            mutatingState.isLoading = true
        case .showToChangeWorkspaceOwnerView(let workspaceMembers):
            mutatingState.changeWorkspaceOwnerState.workspaceMembers = workspaceMembers
            
            mutatingState.isLoading = false
        case .changeWorkspaceOwnerError(let error):
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
            } else if let error = error as? FetchWorkspaceMembersError {
                switch error {
                case .noData:
                    print(error.localizedDescription)
                }
            }
            
            mutatingState.isLoading = false
            
        case .changeWorkspaceOwnerShip(let member):
            mutatingState.isLoading = true
        case .fetchWorkspaceAfterUpdatingWorkspaceOwnership:
            mutatingState.isLoading = true
            break
        case .returnToSideBar(let updatedWorkspaces):
            mutatingState.workspaceState.workspaces = updatedWorkspaces
            mutatingState.isLoading = false
            mutatingState.alertState.dismissAlert = true
            mutatingState.navigationState.isChangeWorkspaceOwnerViewPresented = false
            
            mutatingState.toastMessage = ToastMessage.changeWorkspaceOwner(.completeOwnershipTransfer).message
            mutatingState.showToast = true
        case .initializeAllElements:
            mutatingState.changeWorkspaceOwnerState.selectedWorkspace = nil
            mutatingState.changeWorkspaceOwnerState.workspaceMembers = []
        }
    case .inviteMemeberAction(let inviteMemberAction):
        switch inviteMemberAction {
        case .writeEmail(let email):
            mutatingState.inviteMemberState.email = email
            mutatingState.inviteMemberState.isEmailEmpty = email.isEmpty
        case .inviteMember:
            mutatingState.isLoading = true
        case .returnToHomeView(let newWorkspaceMember):
            
            mutatingState.isLoading = false
            
            mutatingState.navigationState.isInviteMemeberViewPresented = false
            
            mutatingState.toastMessage = ToastMessage.inviteMemeber(.completeMemberInvitation).message
            mutatingState.showToast = true
        case .inviteMemberError(let error):
            mutatingState.isLoading = false
            
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
                    mutatingState.toastMessage = ToastMessage.inviteMemeber(.cannotFindUserInfo).message
                    mutatingState.showToast = true
                case .excesssiveCalls:
                    print(error.localizedDescription)
                case .serverError:
                    print(error.localizedDescription)
                }
            } else if let error = error as? InviteMemberError {
                switch error {
                case .badRequest:
                    print(error.localizedDescription)
                case .duplicatedData:
                    print(error.localizedDescription)
                    mutatingState.toastMessage = ToastMessage.inviteMemeber(.alreadyInvitedMember).message
                    mutatingState.showToast = true
                case .noData:
                    print(error.localizedDescription)
                    mutatingState.toastMessage = ToastMessage.inviteMemeber(.cannotFindUserInfo).message
                    mutatingState.showToast = true
                case .noAccess:
                    print(error.localizedDescription)
                }
            }
        case .isValid(let isEmailValid):
            mutatingState.isLoading = false
            
            if !isEmailValid {
                mutatingState.toastMessage = ToastMessage.inviteMemeber(.invalidEmail).message
                mutatingState.showToast = true
            }
        case .showToastMessageForNoRightToInviteMember:
            mutatingState.toastMessage = ToastMessage.inviteMemeber(.noRightToInviteMember).message
            mutatingState.showToast = true
        }
    case .dmAction(let dmAction):
        switch dmAction {
        case .completeConfigrationDMView(let workspaceMembers, let dmRooms):
            mutatingState.isLoading = false
            
            mutatingState.workspaceState.workspaceMembers = workspaceMembers
            mutatingState.workspaceState.dmRooms = dmRooms
            
            mutatingState.tabState.currentTab = .dm
        case .dmError(let error):
            mutatingState.isLoading = false
            
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
            } else if let error = error as? FetchWorkspaceMembersError {
                switch error {
                case .noData:
                    print(error.localizedDescription)
                }
            } else if let error = error as? CreateOrFetchChatRoomError {
                switch error {
                case .badRequest:
                    print(error.localizedDescription)
                case .noData:
                    print(error.localizedDescription)
                }
            } else if let error = error as? FetchDMHistoryError {
                switch error {
                case .noData:
                    print(error.localizedDescription)
                }
            } else {
                print(error.localizedDescription)
            }
        case .createOrFetchChatRoom(let chatRoomType, let opponent):
            mutatingState.isLoading = true
            
            mutatingState.chatState.chatRoomType = chatRoomType
            mutatingState.dmState.opponent = opponent
        case .refresh:
            mutatingState.isLoading = true
        }
    case .chatAction(let chatAction):
        switch chatAction {
        case .chatError(let error):
            mutatingState.isLoading = false
            
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
            } else if let error = error as? DownloadImageError {
                switch error {
                case .invalidURL:
                    print(error.localizedDescription)
                case .unstableNetworkConnection:
                    print(error.localizedDescription)
                    mutatingState.toastMessage = ToastMessage.downloadImage(.unstableNetworkConnection).message
                    mutatingState.showToast = true
                case .duplicatedData:
                    print(error.localizedDescription)
                    mutatingState.toastMessage = ToastMessage.downloadImage(.duplicatedData).message
                    mutatingState.showToast = true
                case .imageCapacityLimit:
                    print(error.localizedDescription)
                    mutatingState.toastMessage = ToastMessage.downloadImage(.imageCapacityLimit).message
                    mutatingState.showToast = true
                }
            } else if let error = error as? SendDirectMessageError {
                switch error {
                case .badRequest:
                    print(error.localizedDescription)
                case .noData:
                    print(error.localizedDescription)
                }
            } else if let error = error as? SendChannelChatError {
                switch error {
                case .badRequest:
                    print(error.localizedDescription)
                case .noData:
                    print(error.localizedDescription)
                }
            }
        case .initializeAllElements:
            mutatingState.dmState.dmRoom = nil
            mutatingState.dmState.opponent = nil
            mutatingState.dmState.dms = []
            mutatingState.dmState.dmCount = 0
            
            mutatingState.channelState.channel = nil
            mutatingState.channelState.channelChats = []
            mutatingState.channelState.channelChatCount = 0
            
            mutatingState.chatState.chatRoomType = .dm
            mutatingState.chatState.message = ""
            mutatingState.chatState.isMessageEmpty = false
            mutatingState.chatState.selectedImages = []
        case .sendNewMessage:
            mutatingState.isLoading = true
        case .writeMessage(let message):
            mutatingState.chatState.message = message
            mutatingState.chatState.isMessageEmpty = message.isEmpty

        case .removeSelectedImage(let image):
            mutatingState.chatState.selectedImages.removeAll(where: { $0 == image })
        case .handleSelectedPhotos(let newPhotos):
            mutatingState.isLoading = true
        case .appendNewImages(let newImages):
            mutatingState.chatState.selectedImages.append(contentsOf: newImages)
            mutatingState.isLoading = false
        case .receiveNewDirectMessage(let receivedDM):
            break
        case .completeSendDMAction:
            mutatingState.isLoading = false
        case .updateDirectMessages(let dms):
            mutatingState.dmState.dms = dms
            mutatingState.dmState.dmCount += 1
        case .updateChannelChats(let channelChats):
            mutatingState.channelState.channelChats = channelChats
            mutatingState.channelState.channelChatCount += 1
        case .completeSendChannelChatAction:
            mutatingState.isLoading = false
        case .receiveNewChannelChat(let receivedChannelChat):
            break
        }
    case .channelAction(let channelAction):
        switch channelAction {
        case .fetchChannelChats(let chatRoomType, let channel, let isRefreshing):
            mutatingState.isLoading = true
            
            mutatingState.chatState.chatRoomType = chatRoomType
        case .channelError(let error ):
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
            } else if let error = error as? FetchChannelChatsError {
                switch error {
                case .noData:
                    print(error.localizedDescription)
                }
            }
        }
    case .createOrEditChannelAction(let createNewChannelAction):
        switch createNewChannelAction {
        case .writeName(let name):
            mutatingState.createOrEditChannel.channelName = name
            mutatingState.createOrEditChannel.isChannelNameEmpty = name.isEmpty
        case .writeDescription(let description):
            mutatingState.createOrEditChannel.channelDescription = description
        case .createNewChannel:
            mutatingState.isLoading = true
        case .createOrEditChannelError(let error):
            mutatingState.isLoading = false
            
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
            } else if let error = error as? CreateNewChannelError {
                switch error {
                case .badRequest:
                    print(error.localizedDescription)
                case .duplicatedData:
                    print(error.localizedDescription)
                    mutatingState.toastMessage = ToastMessage.createOrEditChannel(.duplicatedData).message
                    mutatingState.showToast = true
                case .noData:
                    print(error.localizedDescription)
                }
            } else if let error = error as? EditChannelDetailsError {
                switch error {
                case .badRequest:
                    print(error.localizedDescription)
                case .duplicatedData:
                    print(error.localizedDescription)
                    mutatingState.toastMessage = ToastMessage.createOrEditChannel(.duplicatedData).message
                    mutatingState.showToast = true
                case .noData:
                    print(error.localizedDescription)
                case .noAccess:
                    print(error.localizedDescription)
                }
            }
        case .returnToHomeView:
            mutatingState.isLoading = false
            
            mutatingState.navigationState.isCreateOrEditChannelViewPresented = false
            
            mutatingState.toastMessage = ToastMessage.createOrEditChannel(.successToCreate).message
            mutatingState.showToast = true
        case .nameValidationError:
            mutatingState.isLoading = false
            
            mutatingState.toastMessage = ToastMessage.createOrEditChannel(.nameValidationError).message
            mutatingState.showToast = true
        case .moveToEditChannelView:
            mutatingState.createOrEditChannel.channelName = mutatingState.channelSettingState.channelDetails?.name ?? ""
            mutatingState.createOrEditChannel.channelDescription = mutatingState.channelSettingState.channelDetails?.description ?? ""
        case .editChannel:
            mutatingState.isLoading = true
        case .returnToChannelSettingView:
            mutatingState.isLoading = false
            
            mutatingState.toastMessage = ToastMessage.createOrEditChannel(.successToEdit).message
            mutatingState.showToast = true
        }
    case .searchChannelAction(let searchChannelAction):
        switch searchChannelAction {
        case .fetchAllChannels:
            mutatingState.isLoading = true
        case .SearchChannelError(let error):
            mutatingState.isLoading = false
            
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
            } else if let error = error as? FetchAllChannelsError {
                switch error {
                case .noData:
                    print(error.localizedDescription)
                }
            }
        case .compareIfMember(let selectedChannel, let confirmAction):
            mutatingState.isLoading = true
        case .dismissSearchChannelViewAndMoveToChannelChatView(let selectedChannel):
            mutatingState.isLoading = false
            
            mutatingState.navigationState.isSearchChannelViewPresented = false
        }
    case .channelSettingAction(let channelSettingAction):
        switch channelSettingAction {
        case .fetchChannel:
            mutatingState.isLoading = true
        case .channelSettingError(let error):
            mutatingState.isLoading = false
            
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
            } else if let error = error as? FetchChannelDetailsError {
                switch error {
                case .noData:
                    print(error.localizedDescription)
                }
            } else if let error = error as? LeaveChannelParamsError {
                switch error {
                case .badRequest:
                    print(error.localizedDescription)
                case .noData:
                    print(error.localizedDescription)
                case .requestDenied:
                    print(error.localizedDescription)
                    mutatingState.toastMessage = ToastMessage.leaveChannel(.requestDeined).message
                    mutatingState.showToast = true
                }
            }
        case .leaveChannel:
            mutatingState.isLoading = true
        case .completeLeaveChannelAction:
            mutatingState.isLoading = false
            
            mutatingState.channelSettingState.channelDetails = nil
            mutatingState.networkCallSuccessType = .popFromChannelSettingViewToHomeView
        }
    case .changeChannelOwnerViewAction(let changeChannelOwnerViewAction):
        switch changeChannelOwnerViewAction {
        case .fetchChannelMembers:
            mutatingState.isLoading = true
        case .changeChannelOwnerViewActionError(let error):
            mutatingState.isLoading = false
            
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
            } else if let error = error as? FetchChannelMembersError {
                switch error {
                case .noData:
                    print(error.localizedDescription)
                }
            } else if let error = error as? ChangeChannelOwnershipError {
                switch error {
                case .badRequest:
                    print(error.localizedDescription)
                case .noData:
                    print(error.localizedDescription)
                case .noAccess:
                    print(error.localizedDescription)
                }
            }
        case .completeFetchChannelMembers(let channelMembers):
            mutatingState.isLoading = false
            
            mutatingState.changeChannelOwnerState.channelMembers = channelMembers
        case .changeChannelOwnerShip(let channelMember):
            mutatingState.isLoading = true
        case .completeChangeChannelOwnerShip(let updatedChannel):
            mutatingState.isLoading = false
            
            mutatingState.channelState.channel = updatedChannel
            
            mutatingState.navigationState.isChangeChannelOwnerViewPresented = false
            
            mutatingState.toastMessage = ToastMessage.changeChannelOwner(.completeOwnershipTransfer).message
            mutatingState.showToast = true
            
            mutatingState.networkCallSuccessType = .popFromChannelSettingViewToSideBar
        }
    }
    return mutatingState
}
