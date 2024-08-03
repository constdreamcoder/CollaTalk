//
//  EditPhoneView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/4/24.
//

import SwiftUI

struct EditPhoneView: View {
    
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var navigationRouter: NavigationRouter
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack {
                
                NavigationFrameView(
                    title: "연락처",
                    leftButtonAction: {
                        navigationRouter.pop()
                    }
                )
                
                Spacer()
                    .frame(height: 12)
                
                InputView(
                    title: "연락처",
                    placeholder: "전화번호를 입력하세요",
                    textFieldGetter: { validateAndFormatPhoneNumber(store.state.myProfileState.phoneNumber) },
                    textFieldSetter: { store.dispatch(.editProfileAction(.writePhoneNumber(phoneNumber: $0))) },
                    secureFieldGetter: { "" },
                    secureFieldSetter: { _ in },
                    rightButtonAction: {},
                    isValid: store.state.signUpState.isPhoneNumberValid
                )
                .keyboardType(.numberPad)
                
                Spacer()
                
                CustomButton {
                    print("완료")
                } label: {
                    Text("완료")
                }
                .disabled( store.state.myProfileState.isPhoneNumberEmpty)
                .bottomButtonShape(!store.state.myProfileState.isPhoneNumberEmpty ? .brandGreen : .brandInactive)
                .padding(.bottom, 12)
            }
        }
    }
}

extension EditPhoneView {
    // TODO: - Middleware로 옮기기
    private func validateAndFormatPhoneNumber(_ phoneNumber: String) -> String {
        let cleanPhoneNumber = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        guard cleanPhoneNumber.hasPrefix("01") else {
            return phoneNumber
        }
        
        if cleanPhoneNumber.count >= 11 {
            let startIndex = cleanPhoneNumber.index(cleanPhoneNumber.startIndex, offsetBy: 3)
            let middleIndex = cleanPhoneNumber.index(cleanPhoneNumber.startIndex, offsetBy: 7)
            return "\(cleanPhoneNumber[..<startIndex])-\(cleanPhoneNumber[startIndex..<middleIndex])-\(cleanPhoneNumber[middleIndex...])"
        } else if cleanPhoneNumber.count >= 10 {
            let startIndex = cleanPhoneNumber.index(cleanPhoneNumber.startIndex, offsetBy: 3)
            let middleIndex = cleanPhoneNumber.index(cleanPhoneNumber.startIndex, offsetBy: 6)
            return "\(cleanPhoneNumber[..<startIndex])-\(cleanPhoneNumber[startIndex..<middleIndex])-\(cleanPhoneNumber[middleIndex...])"
        } else {
            return phoneNumber
        }
    }
}


#Preview {
    EditPhoneView()
}
