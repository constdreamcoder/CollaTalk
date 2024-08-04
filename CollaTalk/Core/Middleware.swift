//
//  Middleware.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/8/24.
//

import Foundation
import Combine
import UIKit

typealias Middleware<State, Action> = (State, Action) -> AnyPublisher<Action, Never>

let appMiddleware: Middleware<AppState, AppAction> = { state, action in
    switch action {
        
    case .dismissToastMessage: break
        
    case .homeAction(let homeAction):
        switch homeAction {
        case .refresh:
            return Just(.workspaceAction(.fetchHomeDefaultViewDatas)).eraseToAnyPublisher()
        }
        
    case .tabAction(let tabAction):
        switch tabAction {
        case .moveToDMTabWithNetowrkCall:
            return Future<AppAction, Never> { promise in
                Task {
                    do {
                        let workspace = UserDefaultsManager.getObject(forKey: .selectedWorkspace, as: Workspace.self)
                        
                        guard let workspace else { return }
                        
                        /// 워크스페이스 멤버 목록 조회
                        async let workspaceMembers = try await WorkspaceProvider.shared.fetchWorkspaceMembers(workspaceID: workspace.workspaceId)
                        /// DM방 목록 조회
                        async let dmRooms = try await WorkspaceProvider.shared.fetchMyDMRooms(workspaceID: workspace.workspaceId)
                        
                        let workspaceMembersResult = try await workspaceMembers
                        let dmRoomsResult = try await dmRooms
                        
                        guard let workspaceMembersResult, let dmRoomsResult else { return }
                        
                        guard dmRoomsResult.count > 0
                        else {
                            
                            promise(.success(.dmAction(.completeConfigrationDMView(workspaceMembers: workspaceMembersResult, dmRooms: []))))
                            return
                        }
                        
                        /// 각 DM 방 로컬 DB(Realm)에 저장
                        let convertedDMRooms = dmRoomsResult.map {
                            if let existingDMRoom = LocalDMRoomRepository.shared.findOne($0.roomId) {
                                return existingDMRoom
                            } else {
                                return $0.convertToLocalDMRoom
                            }
                        }
                        LocalDMRoomRepository.shared.updateDMRoomList(convertedDMRooms)
                        
                        /// 각 DM 방 마지막 DM 업데이트 병렬 처리
                        let fetchLastDMTasks = dmRoomsResult.map { dmRoom in
                            Task {
                                do {
                                    let lastDMInLocal = LocalDMRoomRepository.shared.findOne(dmRoom.roomId)?.lastDM
                                    
                                    /// 각 DM 방 채팅내역 조회
                                    let dmList = try await DMProvider.shared.fetchDMHistory(
                                        workspaceID: workspace.workspaceId,
                                        roomID: dmRoom.roomId,
                                        cursorDate: lastDMInLocal?.createdAt
                                    )
                                    
                                    guard let dmList = dmList, dmList.count > 0 else { return }
                                    guard let lastDMFromRemote = dmList.last else { return }
                                    
                                    let lastSender: LocalWorkspaceMember?
                                    if LocalWorkspaceMemberRepository.shared.isExist(lastDMFromRemote.user.userId) {
                                        lastSender = LocalWorkspaceMemberRepository.shared.findOne(lastDMFromRemote.user.userId)
                                    } else {
                                        lastSender = .init(
                                            userId: lastDMFromRemote.user.userId,
                                            email: lastDMFromRemote.user.email,
                                            nickname: lastDMFromRemote.user.nickname,
                                            profileImage: lastDMFromRemote.user.profileImage
                                        )
                                    }
                                    
                                    /// 마지막 DM 업데이트
                                    LocalDMRoomRepository.shared.updateLastDM(lastDMFromRemote, lastSender: lastSender)
                                } catch {
                                    promise(.success(.dmAction(.dmError(error))))
                                }
                            }
                        }
                        
                        /// 각 DM 방 읽지 않은 채팅 개수 조회 병렬 처리
                        let fetchUnreadDMCountsTasks = dmRoomsResult.map { dmRoom in
                            Task {
                                do {
                                    let lastDMInLocal = LocalDMRoomRepository.shared.findOne(dmRoom.roomId)?.lastDM
                                    
                                    /// 각 DM 방 읽지 않은 채팅 개수 조회
                                    let unreadDMCount = try await DMProvider.shared.fetchUnreadDMCount(
                                        workspaceID: workspace.workspaceId,
                                        roomID: dmRoom.roomId,
                                        after: lastDMInLocal?.createdAt
                                    )
                                    
                                    guard let unreadDMCount else { return }
                                    
                                    /// 읽지 않은 DM 채팅 개수 업데이트
                                    LocalDMRoomRepository.shared.updateUnreadDMCount(unreadDMCount)
                                } catch {
                                    promise(.success(.dmAction(.dmError(error))))
                                }
                            }
                        }
                        
                        await withTaskGroup(of: Void.self) { group in
                            for task in fetchLastDMTasks {
                                group.addTask {
                                    await task.value
                                }
                            }
                        }
                        
                        await withTaskGroup(of: Void.self) { group in
                            for task in fetchUnreadDMCountsTasks {
                                await task.value
                            }
                        }
                        
                        DispatchQueue.main.async {
                            let updatedDmRooms: [LocalDMRoom] = LocalDMRoomRepository.shared.localDMRoomsSortedByDescending
                            
                            promise(.success(.dmAction(.completeConfigrationDMView(workspaceMembers: workspaceMembersResult, dmRooms: updatedDmRooms))))
                        }
                    } catch {
                        promise(.success(.dmAction(.dmError(error))))
                    }
                }
            }.eraseToAnyPublisher()
            
        case .moveToDMTab:
            break
        case .moveToHomeTab:
            break
        }
        
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
        case .setHomeDefaultView(let workspaces, let selectedWorkspace):
            if workspaces.count > 0 {
                return Just(.workspaceAction(.fetchHomeDefaultViewDatas)).eraseToAnyPublisher()
            }
        case .setDMChatView: break
        case .setNone: break
        case .setChannelChatView: break
        case .setChannelSettingView(let channelDetails):
            break
        case .setEditProfileView(let myProfile):
            break
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
        case .showImagePickerView(let show, let isEditProfileMode):
            break
        case .presentChangeWorkspaceOwnerView(let present, let workspace):
            if present {
                return Just(.changeWorkspaceOwnerAction(.fetchWorkspaceMember(workspace: workspace))).eraseToAnyPublisher()
            }
        case .presentInviteMemeberView(let present):
            break
        case .presentCreateOrEditChannelView(let present, let isEditMode):
            break
        case .presentSearchChannelView(let present, let allChannels):
            break
        case .presentChangeChannelOwnerView(let present):
            if present {
                return Just(.changeChannelOwnerViewAction(.fetchChannelMembers)).eraseToAnyPublisher()
            }
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
            guard let imageData = image.pngData() else {
                return Empty().eraseToAnyPublisher()
            }
            
            if imageData.count > 0 && imageData.count <= 1 * 1024 * 1024 {
                return Just(.modifyWorkspaceAction(.dismissGallery(selectedImage: image))).eraseToAnyPublisher()
            } else {
                return Just(.modifyWorkspaceAction(.showToastMessageForImageDataLimit)).eraseToAnyPublisher()
            }
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
                        
                        UserDefaultsManager.setObject(updatedWorkspace, forKey: .selectedWorkspace)
                        promise(.success(.modifyWorkspaceAction(.fetchUpdatedWorkspaces)))
                    } catch {
                        promise(.success(.workspaceAction(.workspaceError(error))))
                    }
                }
            }.eraseToAnyPublisher()
        case .initializeAllElements:
            break
        case .fetchUpdatedWorkspaces:
            return Future<AppAction, Never> { promise in
                Task {
                    do {
                        let updatedWorkspaces = try await WorkspaceProvider.shared.fetchWorkspaces()
                        guard let updatedWorkspaces else { return }
                        promise(.success(.modifyWorkspaceAction(.returnToSideBar(updatedWorkspaces: updatedWorkspaces))))
                    } catch {
                        promise(.success(.workspaceAction(.workspaceError(error))))
                    }
                }
            }.eraseToAnyPublisher()
        case .returnToSideBar(let updatedWorkspaces):
            break
        case .dismissGallery(let selectedImage):
            break
        case .showToastMessageForImageDataLimit:
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
                            
                            guard let selectedWorkspace = UserDefaultsManager.getObject(forKey: .selectedWorkspace, as: Workspace.self) else {
                                
                                /// UserDefaults에 조회된 첫번재 워크스페이스 저장
                                UserDefaultsManager.setObject(workspaces[0], forKey: .selectedWorkspace)
                                
                                /// UserDefaults에 저장된 현재 선택된 워크스페이스 조회
                                guard let selectedWorkspace = UserDefaultsManager.getObject(forKey: .selectedWorkspace, as: Workspace.self) else { return }
                                
                                promise(.success(.networkCallSuccessTypeAction(.setHomeDefaultView(workspaces: workspaces, selectedWorkspace: selectedWorkspace))))
                                return
                            }
                           
                            promise(.success(.networkCallSuccessTypeAction(.setHomeDefaultView(workspaces: workspaces, selectedWorkspace: selectedWorkspace))))
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
                    /// 모든 기록 삭제
                    BaseRepository.deleteAllObjects()
                    
                    do {
                        guard let workspace = state.workspaceState.selectedWorkspace else { return }
                        
                        /// 로그인한 유저가 속한 채널 목록 조회
                        async let myChannels = try await WorkspaceProvider.shared.fetchMyChannels(workspaceID: workspace.workspaceId)
                        /// DM방 목록 조회
                        async let dms = try await WorkspaceProvider.shared.fetchMyDMRooms(workspaceID: workspace.workspaceId)
                        
                        let channelsResult = try await myChannels
                        let dmRoomsResult = try await dms
                        
                        guard let channelsResult, let dmRoomsResult else { return }
                        
                        guard channelsResult.count > 0
                        else {
                            DispatchQueue.main.async {
                                promise(.success(.workspaceAction(.completeFetchHomeDefaultViewDatas(myChennels: [], dmRooms: []))))
                            }
                            return
                        }
                        
                        /// 각 channel 로컬(Realm)에 저장
                        let convertedChannel = channelsResult.map {
                            if let existingChannel = LocalChannelRepository.shared.findOne($0.channelId) {
                                return existingChannel
                            } else {
                                return $0.convertToLocalChannel
                            }
                        }
                        LocalChannelRepository.shared.updateChannelList(convertedChannel)
                        
                        /// 각 채널 마지막 채팅 업데이트 병렬 처리
                        let fetchLastChannelChatTasks = channelsResult.map { channel in
                            Task {
                                do {
                                    let lastChannelChatInLocal = LocalChannelRepository.shared.findOne(channel.channelId)?.lastChat
                                    
                                    /// 각 채널 채팅내역 조회
                                    let channelChatList = try await ChannelProvider.shared.fetchChannelChats(
                                        workspaceID: workspace.workspaceId,
                                        channelID: channel.channelId,
                                        cursorDate: lastChannelChatInLocal?.createdAt
                                    )
                                    
                                    guard let channelChatList = channelChatList, channelChatList.count > 0 else { return }
                                    guard let lastChannelChatFromRemote = channelChatList.last else { return }
                                    
                                    let lastSender: LocalWorkspaceMember?
                                    if LocalWorkspaceMemberRepository.shared.isExist(lastChannelChatFromRemote.user?.userId ?? "") {
                                        lastSender = LocalWorkspaceMemberRepository.shared.findOne(lastChannelChatFromRemote.user?.userId ?? "")
                                    } else {
                                        lastSender = .init(
                                            userId: lastChannelChatFromRemote.user?.userId ?? "",
                                            email: lastChannelChatFromRemote.user?.email ?? "",
                                            nickname: lastChannelChatFromRemote.user?.nickname ?? "",
                                            profileImage: lastChannelChatFromRemote.user?.profileImage
                                        )
                                    }
                                    
                                    /// 마지막 채널 채팅 업데이트
                                    LocalChannelRepository.shared.updateLastChannelChat(lastChannelChatFromRemote, lastSender: lastSender)
                                } catch {
                                    promise(.success(.channelAction(.channelError(error))))
                                }
                            }
                        }
                        
                        /// 각 채널의 읽지 않은 채팅 개수 조회 병렬 처리
                        let fetchUnreadChannelChatCountsTasks = channelsResult.map { channel in
                            Task {
                                do {
                                    let lastChannelChatInLocal = LocalChannelRepository.shared.findOne(channel.channelId)?.lastChat
                                    
                                    /// 각 채널의 읽지 않은 채팅 개수 조회
                                    let unreadChannelChatCount = try await ChannelProvider.shared.fetchUnreadChannelChats(
                                        workspaceID: workspace.workspaceId,
                                        channelID: channel.channelId,
                                        after: lastChannelChatInLocal?.createdAt
                                    )
                                    
                                    guard let unreadChannelChatCount else { return }
                                    
                                    /// 읽지 않은 채널 채팅 개수 업데이트
                                    LocalChannelRepository.shared.updateUnreadChannelChatCount(unreadChannelChatCount)
                                } catch {
                                    promise(.success(.dmAction(.dmError(error))))
                                }
                            }
                        }
                        
                        await withTaskGroup(of: Void.self) { group in
                            for task in fetchLastChannelChatTasks {
                                group.addTask {
                                    await task.value
                                }
                            }
                        }
                        
                        await withTaskGroup(of: Void.self) { group in
                            for task in fetchUnreadChannelChatCountsTasks {
                                await task.value
                            }
                        }
                        
                        guard dmRoomsResult.count > 0
                        else {
                            DispatchQueue.main.async {
                                let updatedChannel: [LocalChannel] = LocalChannelRepository.shared.localChannelsSortedByDescending
                                
                                promise(.success(.workspaceAction(.completeFetchHomeDefaultViewDatas(myChennels: updatedChannel, dmRooms: []))))
                            }
                            return
                        }
                        
                        /// 각 DM 방 로컬 DB(Realm)에 저장
                        let convertedDMRooms = dmRoomsResult.map {
                            if let existingDMRoom = LocalDMRoomRepository.shared.findOne($0.roomId) {
                                return existingDMRoom
                            } else {
                                return $0.convertToLocalDMRoom
                            }
                        }
                        LocalDMRoomRepository.shared.updateDMRoomList(convertedDMRooms)
                        
                        /// 각 DM 방 마지막 채팅 업데이트 병렬 처리
                        let fetchLastDMTasks = dmRoomsResult.map { dmRoom in
                            Task {
                                do {
                                    let lastDMInLocal = LocalDMRoomRepository.shared.findOne(dmRoom.roomId)?.lastDM
                                    
                                    /// 각 DM 방 채팅내역 조회
                                    let dmList = try await DMProvider.shared.fetchDMHistory(
                                        workspaceID: workspace.workspaceId,
                                        roomID: dmRoom.roomId,
                                        cursorDate: lastDMInLocal?.createdAt
                                    )
                                    
                                    guard let dmList = dmList, dmList.count > 0 else { return }
                                    guard let lastDMFromRemote = dmList.last else { return }
                                    
                                    let lastSender: LocalWorkspaceMember?
                                    if LocalWorkspaceMemberRepository.shared.isExist(lastDMFromRemote.user.userId) {
                                        lastSender = LocalWorkspaceMemberRepository.shared.findOne(lastDMFromRemote.user.userId)
                                    } else {
                                        lastSender = .init(
                                            userId: lastDMFromRemote.user.userId,
                                            email: lastDMFromRemote.user.email,
                                            nickname: lastDMFromRemote.user.nickname,
                                            profileImage: lastDMFromRemote.user.profileImage
                                        )
                                    }
                                    
                                    /// 마지막 DM 업데이트
                                    LocalDMRoomRepository.shared.updateLastDM(lastDMFromRemote, lastSender: lastSender)
                                } catch {
                                    promise(.success(.dmAction(.dmError(error))))
                                }
                            }
                        }
                        
                        /// 각 DM 방 읽지 않은 채팅 개수 조회 병렬 처리
                        let fetchUnreadDMCountsTasks = dmRoomsResult.map { dmRoom in
                            Task {
                                do {
                                    let lastDMInLocal = LocalDMRoomRepository.shared.findOne(dmRoom.roomId)?.lastDM
                                    
                                    /// 각 DM 방 읽지 않은 채팅 개수 조회
                                    let unreadDMCount = try await DMProvider.shared.fetchUnreadDMCount(
                                        workspaceID: workspace.workspaceId,
                                        roomID: dmRoom.roomId,
                                        after: lastDMInLocal?.createdAt
                                    )
                                    
                                    guard let unreadDMCount else { return }
                                    
                                    /// 읽지 않은 DM 채팅 개수 업데이트
                                    LocalDMRoomRepository.shared.updateUnreadDMCount(unreadDMCount)
                                } catch {
                                    promise(.success(.dmAction(.dmError(error))))
                                }
                            }
                        }
                        
                        await withTaskGroup(of: Void.self) { group in
                            for task in fetchLastDMTasks {
                                group.addTask {
                                    await task.value
                                }
                            }
                        }
                        
                        await withTaskGroup(of: Void.self) { group in
                            for task in fetchUnreadDMCountsTasks {
                                await task.value
                            }
                        }
                        
                        DispatchQueue.main.async {
                            let updatedChannel: [LocalChannel] = LocalChannelRepository.shared.localChannelsSortedByDescending
                            
                            let updatedDmRooms: [LocalDMRoom] = LocalDMRoomRepository.shared.localDMRoomsSortedByDescending
                            
                            promise(.success(.workspaceAction(.completeFetchHomeDefaultViewDatas(myChennels: updatedChannel, dmRooms: updatedDmRooms))))
                        }
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
        case .selectWorkspace(let workspace):            
            /// UserDefaults에 현재 선택된 워크스페이스 저장
            UserDefaultsManager.setObject(workspace, forKey: .selectedWorkspace)
            return Just(.workspaceAction(.fetchHomeDefaultViewDatas)).eraseToAnyPublisher()
        case .leaveWorkspace(let workspace):
            return Future<AppAction, Never> { promise in
                Task {
                    do {
                        guard let workspace else { return }
                        
                        let updatedWorkspaceList = try await WorkspaceProvider.shared.leaveWorkspace(workspaceID: workspace.workspaceId)
                        print("2")
                        guard let updatedWorkspaceList else { return }
                        
                        promise(.success(.workspaceAction(.fetchWorkspaces)))
                    } catch {
                        promise(.success(.workspaceAction(.workspaceError(error))))
                    }
                }
            }.eraseToAnyPublisher()
        }
    case .changeWorkspaceOwnerAction(let changeWorkspaceOwnerAction):
        switch changeWorkspaceOwnerAction {
        case .fetchWorkspaceMember(let workspace):
            return Future<AppAction, Never> { promise in
                Task {
                    do {
                        /// 워크스페이스 멤버 조회
                        guard let workspace else { return }
                        let workspaceMemebers = try await WorkspaceProvider.shared.fetchWorkspaceMembers(workspaceID: workspace.workspaceId)
                        
                        guard let workspaceMemebers else { return }
                        promise(.success(.changeWorkspaceOwnerAction(.showToChangeWorkspaceOwnerView(workspaceMembers: workspaceMemebers))))
                    } catch {
                        promise(.success(.changeWorkspaceOwnerAction(.changeWorkspaceOwnerError(error))))
                    }
                }
            }.eraseToAnyPublisher()
        case .showToChangeWorkspaceOwnerView(let workspaceMembers):
            break
        case .changeWorkspaceOwnerError(let error):
            break
        case .changeWorkspaceOwnerShip(let member):
            return Future<AppAction, Never> { promise in
                Task {
                    do {
                        /// 워크스페이스 관리자 변경
                        guard let workspace = state.changeWorkspaceOwnerState.selectedWorkspace else { return }
                        let updatedWorkspace = try await WorkspaceProvider.shared.transferWorkspaceOnwnership(
                            workspaceID: workspace.workspaceId,
                            memberID: member.userId
                        )
                        
                        guard let updatedWorkspace else { return }
                        promise(.success(.changeWorkspaceOwnerAction(.fetchWorkspaceAfterUpdatingWorkspaceOwnership)))
                    } catch {
                        promise(.success(.changeWorkspaceOwnerAction(.changeWorkspaceOwnerError(error))))
                    }
                }
            }.eraseToAnyPublisher()
        case .fetchWorkspaceAfterUpdatingWorkspaceOwnership:
            return Future<AppAction, Never> { promise in
                Task {
                    do {
                        /// 워크스페이스 관리자 변경 후, 업데이트된 워크스페이스 목록 조회
                        let updatedWorkspaces = try await WorkspaceProvider.shared.fetchWorkspaces()
                        guard let updatedWorkspaces else { return }
                        
                        promise(.success(.changeWorkspaceOwnerAction(.returnToSideBar(updatedWorkspaces: updatedWorkspaces))))
                    } catch {
                        promise(.success(.workspaceAction(.workspaceError(error))))
                    }
                }
            }.eraseToAnyPublisher()
            
        case .returnToSideBar(let updatedWorkspaces):
            break
        case .initializeAllElements:
            break
        }
    case .inviteMemeberAction(let inviteMemberAction):
        switch inviteMemberAction {
        case .writeEmail(let email):
            break
        case .inviteMember:
            
            /// 이메일 유효성 검사
            let isEmailValid = ValidationCheck.email(input: state.inviteMemberState.email).validation
            
            guard isEmailValid else {
                return Just(.inviteMemeberAction(.isValid(isEmailValid: isEmailValid))).eraseToAnyPublisher()
            }
            
            return Future<AppAction, Never> { promise in
                Task {
                    do {
                        /// 현재 홈 화면에 보이는 워크스페이스
                        guard let selectedWorkspace = UserDefaultsManager.getObject(forKey: .selectedWorkspace, as: Workspace.self) else { return }
                        
                        /// 워크스페이스에 멤버 초대
                        let newWorkspaceMember = try await WorkspaceProvider.shared.inviteMember(
                            workspaceID: selectedWorkspace.workspaceId,
                            email: state.inviteMemberState.email
                        )
                        guard let newWorkspaceMember else { return }
                        promise(.success(.inviteMemeberAction(.returnToHomeView(newWorkspaceMember: newWorkspaceMember))))
                    } catch {
                        promise(.success(.inviteMemeberAction(.inviteMemberError(error))))
                    }
                }
            }.eraseToAnyPublisher()
        case .returnToHomeView(let newWorkspaceMember):
            break
        case .inviteMemberError(let error):
            break
        case .isValid(let isEmailValid):
            break
        case .showToastMessageForNoRightToInviteMember:
            break
        }
    case .dmAction(let dmAction):
        switch dmAction {
        case .completeConfigrationDMView:
            break
        case .dmError(let error):
            break
        case .createOrFetchChatRoom(let chatRoomType, let opponent):
            if chatRoomType == .dm {
                return Future<AppAction, Never> { promise in
                    Task {
                        do {
                            let workspace = UserDefaultsManager.getObject(forKey: .selectedWorkspace, as: Workspace.self)
                            guard let workspace else { return }
                            
                            /// 채팅방 생성 혹은 기존 채팅방 조회
                            let dmRoom = try await DMProvider.shared.createOrFetchChatRoom(
                                workspaceID: workspace.workspaceId,
                                opponentID: opponent.userId
                            )
                            guard let dmRoom else { return }
                            
                            /// 기존 채팅방 존재 여부 판별
                            if LocalDMRoomRepository.shared.isExist(dmRoom.roomId) {
                                print("이미 존재하는 채팅방입니다.")
                            } else {
                                /// 로컬 DB(Realm)에 저장
                                LocalDMRoomRepository.shared.write(dmRoom)
                            }
                            
                            /// 로컬 DB에서 가장 마지막 DM 채팅 기록 조회
                            let lastestDMInLocal = LocalDirectMessageRepository.shared.findLastestDM(dmRoom.roomId)
                            
                            /// 최근 추가된 DM 채팅 기록 조회
                            let dmList = try await DMProvider.shared.fetchDMHistory(
                                workspaceID: workspace.workspaceId,
                                roomID: dmRoom.roomId,
                                cursorDate: lastestDMInLocal?.createdAt
                            )
                            
                            guard let dmList = dmList, dmList.count > 0 else {
                                DispatchQueue.main.async {
                                    /// 기존 DM 기록 조회
                                    let existingLocalDirectMessages: [LocalDirectMessage] =
                                    LocalDirectMessageRepository.shared.read().filter { $0.roomId == dmRoom.roomId }
                                    
                                    /// DM 채팅 기록 날짜별 그룹화
                                    let groupedDM = Dictionary(grouping: existingLocalDirectMessages) { dm -> String in
                                        return dm.createdAt.toChatDate
                                    }
                                    let sortedGroupedDMs: groupdDMsType = groupedDM.keys.sorted().map { key in (key, groupedDM[key]!) }
                                    
                                    /// 소켓 연결
                                    SocketIOManager.shared.setupSocketEventListeners(.dm(roomId: dmRoom.roomId))
                                    SocketIOManager.shared.establishConnection()
                                    
                                    /// DM 채팅방으로 이동
                                    promise(.success(.networkCallSuccessTypeAction(.setDMChatView(chatRoom: dmRoom, dms: sortedGroupedDMs))))
                                }
                                return
                            }
                            
                            DispatchQueue.main.async {
                                /// 새로 추가된 DM 로컬 DB(Realm)에 추가
                                let latestDmList: [LocalDirectMessage] = dmList.map {
                                    let convertedDM = $0.convertToLocalDirectMessage
                                    let sender = LocalWorkspaceMemberRepository.shared.findOne(convertedDM.user?.userId ?? "" )
                                    convertedDM.user = sender
                                    return convertedDM
                                }
                                LocalDMRoomRepository.shared.updateDMs(latestDmList, roomId: dmRoom.roomId)
                                
                                /// 최신 DM 기록 조회
                                let updatedLocalDirectMessages: [LocalDirectMessage] = LocalDirectMessageRepository.shared.read().filter { $0.roomId == dmRoom.roomId }
                                
                                /// DM 채팅 기록 날짜별 그룹화
                                let groupedDM = Dictionary(grouping: updatedLocalDirectMessages) { dm -> String in
                                    return dm.createdAt.toChatDate
                                }
                                let sortedGroupedDMs: groupdDMsType = groupedDM.keys.sorted().map { key in (key, groupedDM[key]!) }
                                
                                /// 소켓 연결
                                SocketIOManager.shared.setupSocketEventListeners(.dm(roomId: dmRoom.roomId))
                                SocketIOManager.shared.establishConnection()
                                
                                /// 채팅화면으로 이동
                                promise(.success(.networkCallSuccessTypeAction(.setDMChatView(chatRoom: dmRoom, dms: sortedGroupedDMs))))
                            }
                        } catch {
                            promise(.success(.dmAction(.dmError(error))))
                        }
                    }
                }.eraseToAnyPublisher()
            } else {
                
                // TODO: - 채널 채팅방 생성 기능 구현
                break
            }
        case .refresh:
            return Just(.tabAction(.moveToDMTabWithNetowrkCall)).eraseToAnyPublisher()
        }
    case .chatAction(let chatAction):
        switch chatAction {
        case .chatError(let error):
            break
        case .initializeAllElements:
            SocketIOManager.shared.leaveConnection()
            SocketIOManager.shared.removeAllEventHandlers()
        case .sendNewMessage:
            return Future<AppAction, Never> { promise in
                guard let workspace = UserDefaultsManager.getObject(forKey: .selectedWorkspace, as: Workspace.self) else { return }
                
                let imageFiles = state.chatState.selectedImages.map { image in
                    return ImageFile(
                        imageData: image.pngData() ?? Data(),
                        name: Date().timeIntervalSince1970.description,
                        mimeType: .png
                    )
                }
                
                if state.chatState.chatRoomType == .dm {
                    /// DM 전송
                    Task {
                        do {
                            let _ = try await DMProvider.shared.sendDirectMessage(
                                workspaceID: workspace.workspaceId,
                                roomID: state.dmState.dmRoom?.roomId ?? "",
                                message: state.chatState.message,
                                files: imageFiles
                            )
                            
                            promise(.success(.chatAction(.completeSendDMAction)))
                        } catch {
                            promise(.success(.chatAction(.chatError(error))))
                        }
                    }
                } else if state.chatState.chatRoomType == .channel {
                    /// 채널 채팅 전송
                    Task {
                        do {
                            let newChannelChat = try await ChannelProvider.shared.sendChannelChat(
                                workspaceID:  workspace.workspaceId,
                                channelID: state.channelState.channel?.channelId ?? "",
                                message: state.chatState.message,
                                files: imageFiles
                            )
                            
                            promise(.success(.chatAction(.completeSendChannelChatAction)))
                            
                        } catch {
                            promise(.success(.chatAction(.chatError(error))))
                        }
                    }
                }
                
                
            }.eraseToAnyPublisher()
        case .writeMessage(let message):
            break
        case .removeSelectedImage(let image):
            break
        case .handleSelectedPhotos(let newPhotos):
            return Future<AppAction, Never> { promise in
                Task {
                    var newImages: [UIImage] = []
                    for newPhoto in newPhotos {
                        do {
                            if
                                let data = try await newPhoto.loadTransferable(type: Data.self),
                                let newImage = UIImage(data: data)
                            {
                                /// 이미지 파일 크기 제한 1MB 여부 확인
                                if data.count >= 1 * 1024 * 1024 {
                                    promise(.success(.chatAction(.chatError(DownloadImageError.imageCapacityLimit))))
                                }
                                
                                /// 중복된 이미지가 있는지 화인
                                if !state.chatState.selectedImages.contains(where: { $0.pngData() == newImage.pngData() }) {
                                    newImages.append(newImage)
                                } else {
                                    promise(.success(.chatAction(.chatError(DownloadImageError.duplicatedData))))
                                }
                            }
                        } catch {
                            print("Image Fetching Error From Gallery", error)
                            promise(.success(.chatAction(.chatError(DownloadImageError.unstableNetworkConnection))))
                        }
                    }
                    
                    guard newImages.count > 0 else { return }
                    promise(.success(.chatAction(.appendNewImages(newImages: newImages))))
                }
            }.eraseToAnyPublisher()
        case .appendNewImages(let newImages):
            break
        case .receiveNewDirectMessage(let receivedDM):
            /// 기존 DM 작성자가 있는지 여부 확인
            let sender = LocalWorkspaceMemberRepository.shared.createSender(receivedDM)
            
            /// 로컬 DB(Realm)에 새로운 DM 저장
            LocalDirectMessageRepository.shared.write(
                newDirectMessage: receivedDM,
                sender: sender
            )
            
            /// 로컬 DB(Realm)에 마지막 DM 업데이트
            LocalDMRoomRepository.shared.updateLastDM(
                receivedDM,
                lastSender: sender
            )
            
            let updatedLocalDirectMessages: [LocalDirectMessage] = LocalDirectMessageRepository.shared.read().map { $0 }
            
            /// DM 채팅 기록 날짜별 그룹화
            let groupedDM = Dictionary(grouping: updatedLocalDirectMessages) { dm -> String in
                return dm.createdAt.toChatDate
            }
            let sortedGroupedDMs: groupdDMsType = groupedDM.keys.sorted().map { key in (key, groupedDM[key]!) }
            
            return Just(.chatAction(.updateDirectMessages(dms: sortedGroupedDMs))).eraseToAnyPublisher()
        case .completeSendDMAction:
            break
        case .updateDirectMessages(let dms):
            break
        case .completeSendChannelChatAction:
            break
        case .receiveNewChannelChat(let receivedChannelChat):
            /// 기존 채널 채팅 작성자가 있는지 여부 확인
            let sender = LocalWorkspaceMemberRepository.shared.createSender(receivedChannelChat)
            
            /// 로컬 DB(Realm)에 새로운 채널 채팅 저장
            LocalChannelChatRepository.shared.write(
                newChannelChat: receivedChannelChat,
                sender: sender
            )
            
            /// 로컬 DB(Realm)에 마지막 채널 채팅 업데이트
            LocalChannelRepository.shared.updateLastChannelChat(
                receivedChannelChat,
                lastSender: sender
            )
            
            let updatedLocalChannelChats: [LocalChannelChat] = LocalChannelChatRepository.shared.read().map { $0 }
            
            /// 채널 채팅 기록 날짜별 그룹화
            let groupeChannelChat = Dictionary(grouping: updatedLocalChannelChats) { channelChat -> String in
                return channelChat.createdAt.toChatDate
            }
            let sortedGroupedChannelChats: groupdChannelChatsType = groupeChannelChat.keys.sorted().map { key in (key, groupeChannelChat[key]!) }
            
            return Just(.chatAction(.updateChannelChats(channelChats: sortedGroupedChannelChats))).eraseToAnyPublisher()
        case .updateChannelChats(let channelChats):
            break
        }
    case .channelAction(let channelAction):
        switch channelAction {
        case .fetchChannelChats(let chatRoomType, let channel, let isRefreshing):
            return Future<AppAction, Never> { promise in
                Task {
                    do {
                        guard let workspace = UserDefaultsManager.getObject(forKey: .selectedWorkspace, as: Workspace.self) else { return }
                        guard let channel else { return }
                        
                        let lastChannelChatInLocal = LocalChannelChatRepository.shared.findLastestChannelChat(channel.channelId)
                        
                        let channelChats = try await ChannelProvider.shared.fetchChannelChats(
                            workspaceID: workspace.workspaceId,
                            channelID: channel.channelId,
                            cursorDate: lastChannelChatInLocal?.createdAt
                        )
                        
                        guard let channelChats = channelChats, channelChats.count > 0 else {
                            DispatchQueue.main.async {
                                
                                /// 기존 채널 채팅 기록 조회
                                let existingLocalChannelChats: [LocalChannelChat] =
                                LocalChannelChatRepository.shared.read().filter { $0.channelId == channel.channelId }
                                
                                /// 채널 채팅 기록 날짜별 그룹화
                                let groupedChannelChat = Dictionary(grouping: existingLocalChannelChats) { channelChat -> String in
                                    return channelChat.createdAt.toChatDate
                                }
                                
                                let sortedGroupedChannelChats: groupdChannelChatsType = groupedChannelChat.keys.sorted().map { key in (key, groupedChannelChat[key]!) }
                                
                                /// 소켓 연결
                                SocketIOManager.shared.setupSocketEventListeners(.channel(channelId: channel.channelId))
                                SocketIOManager.shared.establishConnection()
                                
                                /// 채널 채팅방으로 이동
                                promise(.success(.networkCallSuccessTypeAction(.setChannelChatView(channel: channel, channelChats: sortedGroupedChannelChats))))
                            }
                            return
                        }
                        
                        DispatchQueue.main.async {
                            /// 새로 추가된 채널 채팅 로컬 DB(Realm)에 추가
                            let latestChannelChatList: [LocalChannelChat] = channelChats.map {
                                let convertedChannelChat = $0.convertToLocalChannelChat
                                if let sender = LocalWorkspaceMemberRepository.shared.findOne(convertedChannelChat.sender?.userId ?? "" ) {
                                    
                                    convertedChannelChat.sender = sender
                                }
                                return convertedChannelChat
                            }
                            LocalChannelRepository.shared.updateChannelChats(latestChannelChatList, channelId: channel.channelId)
                            
                            /// 최신 채널 채팅 기록 조회
                            let updatedLocalChannelChats: [LocalChannelChat] = LocalChannelChatRepository.shared.read().filter { $0.channelId == channel.channelId }
                            
                            /// 채널 채팅 기록 날짜별 그룹화
                            let groupedChannelChat = Dictionary(grouping: updatedLocalChannelChats) { channelChat -> String in
                                return channelChat.createdAt.toChatDate
                            }
                            
                            let sortedGroupedChannelChats: groupdChannelChatsType = groupedChannelChat.keys.sorted().map { key in (key, groupedChannelChat[key]!) }
                            
                            /// 소켓 연결
                            SocketIOManager.shared.setupSocketEventListeners(.channel(channelId: channel.channelId))
                            SocketIOManager.shared.establishConnection()
                            
                            if !isRefreshing {
                                /// 채팅화면으로 이동
                                promise(.success(.networkCallSuccessTypeAction(.setChannelChatView(channel: channel, channelChats: sortedGroupedChannelChats))))
                            }
                        }
                    } catch {
                        promise(.success(.channelAction(.channelError(error))))
                    }
                }
            }.eraseToAnyPublisher()
        case .channelError(let error):
            break
        }
    case .createOrEditChannelAction(let createNewChannelAction):
        switch createNewChannelAction {
        case .writeName(let name): break
        case .writeDescription(let description): break
        case .createNewChannel:
            return Future<AppAction, Never> { promise in
                guard ValidationCheck.channelName(input: state.createOrEditChannel.channelName).validation
                else {
                    promise(.success(.createOrEditChannelAction(.nameValidationError)))
                    return
                }
                guard let workspace = UserDefaultsManager.getObject(forKey: .selectedWorkspace, as: Workspace.self) else { return }
                Task {
                    do {
                        let newChannel = try await ChannelProvider.shared.createNewChannel(
                            workspaceID: workspace.workspaceId,
                            name: state.createOrEditChannel.channelName,
                            description: state.createOrEditChannel.channelDescription
                        )
                        
                        promise(.success(.createOrEditChannelAction(.returnToHomeView)))
                    } catch {
                        promise(.success(.createOrEditChannelAction(.createOrEditChannelError(error))))
                    }
                }
            }.eraseToAnyPublisher()
        case .createOrEditChannelError(let error):
            break
        case .returnToHomeView:
            return Just(.homeAction(.refresh)).eraseToAnyPublisher()
        case .nameValidationError:
            break
        case .moveToEditChannelView:
            return Just(.navigationAction(.presentCreateOrEditChannelView(present: true, isEditMode: true))).eraseToAnyPublisher()
        case .editChannel:
            return Future<AppAction, Never> { promise in
                Task {
                    do {
                        let updatedChannel = try await ChannelProvider.shared.editChannelDetails(
                            workspaceID: state.workspaceState.selectedWorkspace?.workspaceId ?? "",
                            channelID: state.channelSettingState.channelDetails?.channelId ?? "",
                            name: state.createOrEditChannel.channelName,
                            description: state.createOrEditChannel.channelDescription
                        )
                        
                        guard let updatedChannel else { return }
                        
                        /// 로컬 DB(Realm) 업데이트
                        LocalChannelRepository.shared.updateChannelNameAndDescription(with: updatedChannel)
                        
                        promise(.success(.createOrEditChannelAction(.returnToChannelSettingView)))
                    } catch {
                        promise(.success(.createOrEditChannelAction(.createOrEditChannelError(error))))
                    }
                }
            }.eraseToAnyPublisher()
        case .returnToChannelSettingView:
            return Just(.channelSettingAction(.fetchChannel)).eraseToAnyPublisher()
        }
    case .searchChannelAction(let searchAction):
        switch searchAction {
        case .fetchAllChannels:
            return Future<AppAction, Never> { promise in
                Task {
                    do {
                        let allChannels = try await ChannelProvider.shared.fetchAllChannels(
                            workspaceID: state.workspaceState.selectedWorkspace?.workspaceId ?? ""
                        )
                        
                        guard let allChannels else { return }
                        promise(.success(.navigationAction(.presentSearchChannelView(present: true, allChannels: allChannels))))
                    } catch {
                        promise(.success(.searchChannelAction(.SearchChannelError(error))))
                    }
                }
            }.eraseToAnyPublisher()
        case .SearchChannelError(let error):
            break
        case .compareIfMember(let selectedChannel, let confirmAction):
            return Future<AppAction, Never> { promise in
                Task {
                    do {
                        let myChannels = try await WorkspaceProvider.shared.fetchMyChannels(
                            workspaceID: state.workspaceState.selectedWorkspace?.workspaceId ?? ""
                        )
                        
                        guard let myChannels else { return }
                        
                        /// 유저가 속한 채널인지 확인
                        if myChannels.contains(where: { $0.channelId == selectedChannel.channelId }) {
                            promise(.success(.searchChannelAction(.dismissSearchChannelViewAndMoveToChannelChatView(selectedChannel: selectedChannel))))
                        } else {
                            guard let confirmAction else { return }
                            promise(.success(.alertAction(.showAlert(alertType: .joinChannel(channelName: selectedChannel.name), confirmAction: confirmAction))))
                        }
                        
                    } catch {
                        promise(.success(.searchChannelAction(.SearchChannelError(error))))
                    }
                }
            }.eraseToAnyPublisher()
        case .dismissSearchChannelViewAndMoveToChannelChatView(let selectedChannel):
            return Just(.channelAction(.fetchChannelChats(chatRoomType: .channel, channel: selectedChannel))).eraseToAnyPublisher()
        }
    case .channelSettingAction(let channelSettingAction):
        switch channelSettingAction {
        case .fetchChannel:
            return Future<AppAction, Never> { promise in
                Task {
                    do {
                        let channelDetails = try await ChannelProvider.shared.fetchChannelDetails(
                            workspaceID: state.workspaceState.selectedWorkspace?.workspaceId ?? "",
                            channelID: state.channelState.channel?.channelId ?? ""
                        )
                        
                        guard let channelDetails else { return }
                        
                        promise(.success(.networkCallSuccessTypeAction(.setChannelSettingView(channelDetails: channelDetails))))
                    } catch {
                        promise(.success(.channelSettingAction(.channelSettingError(error))))
                    }
                }
            }.eraseToAnyPublisher()
        case .channelSettingError(let error):
            break
        case .leaveChannel:
            return Future<AppAction, Never> { promise in
                Task {
                    guard
                        let workspace = state.workspaceState.selectedWorkspace,
                        let channel = state.channelSettingState.channelDetails
                    else { return }
                    do {
                        /// 채널 퇴장
                        let updatedChannels = try await ChannelProvider.shared.leaveChannel(
                            workspaceID: workspace.workspaceId,
                            channelID: channel.channelId
                        )
                        
                        guard let updatedChannels else { return }
                        
                        DispatchQueue.main.async {
                            /// 퇴장한 채널에 대한 로컬 DB(Realm)에서 삭제
                            if let existingChannel = LocalChannelRepository.shared.findOne(channel.channelId) {
                                LocalChannelRepository.shared.delete(existingChannel)
                            }
                            
                            /// 로컬 DB(Realm)에 채널 목록 업데이트
                            LocalChannelRepository.shared.updateChannelList(updatedChannels)
                            
                            let updatedChannelsInLocal: [LocalChannel] = LocalChannelRepository.shared.localChannelsSortedByDescending
                            
                            promise(.success(.channelSettingAction(.completeLeaveChannelAction(updatedChannels: updatedChannelsInLocal))))
                        }
                        
                    } catch {
                        promise(.success(.channelSettingAction(.channelSettingError(error))))
                    }
                }
            }.eraseToAnyPublisher()
        case .completeLeaveChannelAction:
            break
        case .deleteChannel:
            return Future<AppAction, Never> { promise in
                Task {
                    guard
                        let workspace = state.workspaceState.selectedWorkspace,
                        let channel = state.channelSettingState.channelDetails
                    else { return }
                    
                    do {
                        /// 채널 삭제
                        let result = try await ChannelProvider.shared.deleteChannel(
                            workspaceID: workspace.workspaceId,
                            channelID: channel.channelId
                        )
                        DispatchQueue.main.async {
                            /// 로컬DB(Realm)에서 해당 채널 삭제
                            if let existingChannel = LocalChannelRepository.shared.findOne(channel.channelId) {
                                LocalChannelRepository.shared.delete(existingChannel)
                            }
                            
                            /// 로컬DB(Realm)에서 업데이트된 채널 목록 조회
                            let updatedChannels: [LocalChannel] = LocalChannelRepository.shared.localChannelsSortedByDescending
                            
                            promise(.success(.channelSettingAction(.completeDeleteChannelAction(updatedChannels: updatedChannels))))
                        }
                    } catch {
                        promise(.success(.channelSettingAction(.channelSettingError(error))))
                    }
                }
            }.eraseToAnyPublisher()
        case .completeDeleteChannelAction(let updateChannels):
            break
        }
    case .changeChannelOwnerViewAction(let changeChannelOwnerViewAction):
        switch changeChannelOwnerViewAction {
        case .fetchChannelMembers:
            return Future<AppAction, Never> { promise in
                Task {
                    do {
                        
                        guard let workspaceID = state.workspaceState.selectedWorkspace?.workspaceId,
                              let channelID = state.channelSettingState.channelDetails?.channelId
                        else { return }
                        
                        let channelMembers = try await ChannelProvider.shared.fetchChannelMembers(
                            workspaceID: workspaceID,
                            channelID: channelID
                        )
                        
                        guard let channelMembers else { return }
                        
                        /// 채널 멤버 로컬 DB(Realm) 타입으로 변환: WorkspaceMember -> LocalWorkspaceMember
                        let convertedChannelMembers: [LocalWorkspaceMember] = channelMembers.map {
                            if let existingWorkspaceMember = LocalWorkspaceMemberRepository.shared.findOne($0.userId) {
                                return existingWorkspaceMember
                            }
                            return $0.convertToLocalWorkspaceMember
                        }
                        
                        /// 새로 조회된 채널 멤버 로컬 DB(Realm)에 업데이트
                        LocalChannelRepository.shared.updateChannelMembers(
                            channelId: channelID,
                            newChannelMembers: convertedChannelMembers
                        )
                        
                        promise(.success(.changeChannelOwnerViewAction(.completeFetchChannelMembers(channelMembers: channelMembers))))
                    } catch {
                        promise(.success(.changeChannelOwnerViewAction(.changeChannelOwnerViewActionError(error))))
                    }
                }
            }.eraseToAnyPublisher()
        case .changeChannelOwnerViewActionError(let error):
            break
        case .completeFetchChannelMembers:
            break
        case .changeChannelOwnerShip(let channelMember):
            return Future<AppAction, Never> { promise in
                Task {
                    guard let workspaceID = state.workspaceState.selectedWorkspace?.workspaceId,
                          let channelID = state.channelSettingState.channelDetails?.channelId
                    else { return }
                    
                    do {
                        let updatedChannel = try await ChannelProvider.shared.changeChannelOwnership(
                            workspaceID: workspaceID,
                            channelID: channelID,
                            ownerId: channelMember.userId
                        )
                        
                        guard let updatedChannel else { return }
                        
                        /// 로컬 DB(Realm) 채널 관리자 업데이트
                        LocalChannelRepository.shared.updateChannelOwner(
                            updatedChannel.channelId,
                            newOwnerId: updatedChannel.ownerId
                        )
                        
                        promise(.success(.changeChannelOwnerViewAction(.completeChangeChannelOwnerShip(updatedChannel: updatedChannel))))
                    } catch {
                        promise(.success(.changeChannelOwnerViewAction(.changeChannelOwnerViewActionError(error))))
                    }
                }
            }.eraseToAnyPublisher()
        case .completeChangeChannelOwnerShip(let updatedChannel):
            break
        }
    case .editProfileAction(let editProfileAction):
        switch editProfileAction {
        case .fetchMyProfile:
            return Future<AppAction, Never> { promise in
                Task {
                    do {
                        /// 내 프로필 조회 기능 구현
                        let myProfile = try await ProfileProvider.shared.fetchMyProfile()
                        
                        guard let myProfile else { return }
                        
                        promise(.success(.networkCallSuccessTypeAction(.setEditProfileView(myProfile: myProfile))))
                    } catch {
                        promise(.success(.editProfileAction(.editProfileError(error))))
                    }
                }
            }.eraseToAnyPublisher()
        case .editProfileError(let error):
            break
        case .writeNickname(let nickname):
            break
        case .writePhoneNumber(let phoneNumber):
            break
        case .changeProfileImage(let image):
            return Future<AppAction, Never> { promise in
                Task {
                    guard let imageData = image.pngData(), imageData.count > 0 else {
                        promise(.success(.editProfileAction(.noImageDataError)))
                        return
                    }
                    
                    if imageData.count > 1 * 1024 * 1024 {
                        promise(.success(.editProfileAction(.profileImageDataLimitError)))
                    }
                    
                    do {
                        /// 프로필 이미지 수정
                        let imageFile = ImageFile(
                            imageData: imageData,
                            name: (Date().timeIntervalSince1970 + 233).description,
                            mimeType: .png
                        )
                        let changedProfile = try await ProfileProvider.shared.changeProfileImage(image: imageFile)
                        
                        guard let changedProfile else { return }
                        
                        promise(.success(.editProfileAction(.updateUserInfo(updatedUserInfo: changedProfile))))
                    } catch {
                        promise(.success(.editProfileAction(.editProfileError(error))))
                    }
                }
            }.eraseToAnyPublisher()
        case .profileImageDataLimitError:
            break
        case .noImageDataError:
            break
        case .updateUserInfo(let updatedUserInfo):
            break
        }
    }
    
    return Empty().eraseToAnyPublisher()
}
