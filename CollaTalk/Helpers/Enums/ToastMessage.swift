//
//  ToastMessage.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/10/24.
//

import Foundation

protocol ToastMessageType {
    var message: String { get }
}

enum ToastMessage: ToastMessageType {
    case login(Login)
    case signUp(SignUp)
    case modifyWorkspace(ModifyWorkspace)
    case changeWorkspaceOwner(ChangeWorkspaceOwner)
    case changeChannelOwner(ChangeChannelOwner)
    case inviteMemeber(InviteMember)
    case downloadImage(DownloadImage)
    case createOrEditChannel(CreateOrEditChannel)
    case leaveChannel(LeaveChannel)
    case leaveWorkspace(LeaveWorkspace)
    
    var message: String {
        switch self {
        case .login(let login):
            return login.message
        case .signUp(let signUp):
            return signUp.message
        case .modifyWorkspace(let modifyWorkspace):
            return modifyWorkspace.message
        case .changeWorkspaceOwner(let changeWorkspaceOwner):
            return changeWorkspaceOwner.message
        case .changeChannelOwner(let changeChannelOwner):
            return changeChannelOwner.message
        case .inviteMemeber(let inviteMember):
            return inviteMember.message
        case .downloadImage(let downloadImage):
            return downloadImage.message
        case .createOrEditChannel(let createNewChannel):
            return createNewChannel.message
        case .leaveChannel(let leaveChannel):
            return leaveChannel.message
        case .leaveWorkspace(let leaveWorkspace):
            return leaveWorkspace.message
        }
    }
    
    enum Login: ToastMessageType {
        case emailValidationError
        case passwordValidationError
        case failToLogin
        case etc
        
        var message: String {
            switch self {
            case .emailValidationError:
                return "이메일 형식이 올바르지 않습니다."
            case .passwordValidationError:
                return "비밀번호는 최소 8자 이상, 하나 이상의 대소문자/숫자/특수 문자를 설정해주세요."
            case .failToLogin:
                return "이메일 또는 비밀번호가 올바르지 않습니다."
            case .etc:
                return "에러가 발생했어요. 잠시 후 다시 시도해주세요."
            }
        }
    }
    
    enum SignUp: ToastMessageType {
        case emailValidationError
        case emailAvailable
        case emailAlreadyConfirmed
        case emailNotConfirmed
        case nicknameValidationError
        case phoneNumberValidationError
        case passwordValidationError
        case passwordForMatchCheckValidationError
        case joindAccount
        case etc
        
        var message: String {
            switch self {
            case .emailValidationError:
                return "이메일 형식이 올바르지 않습니다."
            case .emailAvailable:
                return "사용 가능한 이메일입니다."
            case .emailAlreadyConfirmed:
                return "사용 가능한 이메일입니다."
            case .emailNotConfirmed:
                return "이메일 중복 확인을 진행해주세요."
            case .nicknameValidationError:
                return "닉네임은 1글자 이상 30글자 이내로 부탁드려요."
            case .phoneNumberValidationError:
                return "잘못된 전화번호 형식입니다."
            case .passwordValidationError:
                return "비밀번호는 최소 8자 이상, 하나 이상의 대소문자/숫자/특수 문자를 설정해주세요."
            case .passwordForMatchCheckValidationError:
                return "작성하신 비밀번호가 일치하지 않습니다."
            case .joindAccount:
                return "이미 가입된 회원입니다. 로그인을 진행해주세요."
            case .etc:
                return "에러가 발생했어요. 잠시 후 다시 시도해주세요."
            }
        }
    }
    
    enum ModifyWorkspace: ToastMessageType {
        case workspaceNameError
        case noImage
        case completeEditing
        case imageDataLimit
        
        var message: String {
            switch self {
            case .workspaceNameError:
                return "워크스페이스 이름은 1~30자로 설정해주세요."
            case .noImage:
                return "워크스페이스 이미지를 등록해주세요."
            case .completeEditing:
                return "워크스페이스가 편집되었습니다."
            case .imageDataLimit:
                return "이미지 최대 크기는 1MB입니다."
            }
        }
    }
    
    enum ChangeWorkspaceOwner: ToastMessageType {
        case completeOwnershipTransfer
        
        var message: String {
            switch self {
            case .completeOwnershipTransfer:
                return "워크스페이스 관리자가 변경되었습니다."
            }
        }
    }
    
    enum ChangeChannelOwner: ToastMessageType {
        case completeOwnershipTransfer
        
        var message: String {
            switch self {
            case .completeOwnershipTransfer:
                return "채널 관리자가 변경되었습니다."
            }
        }
    }
    
    enum InviteMember: ToastMessageType {
        case completeMemberInvitation
        case alreadyInvitedMember
        case cannotFindUserInfo
        case invalidEmail
        case noRightToInviteMember
        
        var message: String {
            switch self {
            case .completeMemberInvitation:
                return "멤버를 성공적으로 초대했습니다."
            case .alreadyInvitedMember:
                return "이미 워크스페이스에 소속된 팀원이에요."
            case .cannotFindUserInfo:
                return "회원 정보를 찾을 수 없습니다."
            case .invalidEmail:
                return "올바른 이메일을 입력해주세요."
            case .noRightToInviteMember:
                return "워크스페이스 관리자만 팀원을 초대할 수 있어요.\n관리자에게 요청을 해보세요."
            }
        }
    }
    
    enum DownloadImage: ToastMessageType {
        
        case duplicatedData
        case unstableNetworkConnection
        case imageCapacityLimit
        
        var message: String {
            switch self {
            case .duplicatedData:
                return "중복된 이미지가 존재합니다."
            case .unstableNetworkConnection:
                return "네트워크가 불안정합니다."
            case .imageCapacityLimit:
                return "크키가 1MB이하인 이미지만 업로드 가능합니다."
            }
        }
    }
    
    enum CreateOrEditChannel: ToastMessageType {
        case duplicatedData
        case successToCreate
        case nameValidationError
        case successToEdit
        
        var message: String {
            switch self {
            case .duplicatedData:
                return "워크스페이스에 이미 있는 채널 이름입니다. 다른 이름을 입력해주세요. "
            case .successToCreate:
                return "채널이 생성되었습니다."
            case .nameValidationError:
                return "채널명은 1~30자까지만 가능합니다."
            case .successToEdit:
                return "채널이 편집되었습니다."
            }
        }
    }
    
    enum LeaveChannel: ToastMessageType {
        case requestDeined
        
        var message: String {
            switch self {
            case .requestDeined:
                return "일반 채널은 워크스페이스 기본 채널입니다. 기본 채널은 퇴장할 수 없습니다."
            }
        }
    }
    
    enum LeaveWorkspace: ToastMessageType {
        case requestDeined
        
        var message: String {
            switch self {
            case .requestDeined:
                return "채널 관리자이신 것 같아요. 채널 관리자는 채널에 대한 권한을 양도해야 워크스페이스를 퇴장할 수 있어요."
            }
        }
    }
}
