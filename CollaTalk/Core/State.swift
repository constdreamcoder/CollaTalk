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
    
    var navigationState = NavigationState()
    var loginState = LoginState()
    var signUpState = SignUpState()
    var addWorkspaceState = AddWorkspaceState()
    var workspaceState = WorkspaceState()
    
    struct NavigationState {
        var isBottomSheetPresented: Bool = false
        var isLoginViewPresented: Bool = false
        var isSignUpViewPresented: Bool = false
        var isAddWorkspaceViewPresented: Bool = false
        var isSidebarVisible: Bool = false
        var showImagePicker: Bool = false
    }
   
    struct LoginState {
        var email: String = ""
        var password: String = ""
        var isEmailEmpty: Bool = true
        var isPWEmpty: Bool = true
        var isEmailValid: Bool = true
        var isPWValid: Bool = true
        
        mutating func initializeAllStates() {
            self.email = ""
            self.password = ""
            self.isEmailEmpty = true
            self.isPWEmpty = true
            self.isEmailValid = true
            self.isPWValid = true
        }
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
    
    struct AddWorkspaceState {
        var selectedImage: UIImage? = nil
        var name: String = ""
        var description: String = ""

        var isNameEmpty: Bool = true
        var isDescriptionEmpty: Bool = true
        
    }
    
    struct WorkspaceState {
        var workspaces: [Workspace] = []
    }
}
