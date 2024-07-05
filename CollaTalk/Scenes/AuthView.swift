//
//  AuthView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/5/24.
//

import SwiftUI

struct AuthView: View {
    
    @Binding var isBottomSheetPresented: Bool
    @Binding var isLoginViewPresented: Bool
    @Binding var isSignUpViewPresented: Bool
    
    var body: some View {
        if isBottomSheetPresented {
            BottomSheetView($isBottomSheetPresented, height: 290) {
                VStack(spacing: 16) {
                    CustomButton {
                        print("Apple으로 계속하기")
                    } label: {
                        HStack{
                            Image(.appleLogo)
                            Text("Apple으로 계속하기")
                        }
                    }
                    .bottomButtonShape(.appleLogin)
                    
                    CustomButton {
                        print("카카오톡으로 계속하기")
                    } label: {
                        HStack{
                            Image(.kakaoLogo)
                            Text("카카오톡으로 계속하기")
                                .foregroundStyle(.brandBlack)
                        }
                    }
                    .bottomButtonShape(.kakaoLogin)
                    
                    CustomButton {
                        print("이메일로 계속하기")
                        isLoginViewPresented = true
                    } label: {
                        HStack{
                            Image(.emailIcon)
                            Text("이메일로 계속하기")
                        }
                    }
                    .bottomButtonShape(.brandGreen)
                    
                    CustomButton {
                        print("또는 새롭게 회원가입 하기")
                        isSignUpViewPresented = true
                    } label: {
                        HStack{
                            Text("또는")
                                .foregroundStyle(.brandBlack)
                            Text("새롭게 회원가입 하기")
                                .foregroundStyle(.brandGreen)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

#Preview {
    AuthView(
        isBottomSheetPresented: .constant(false),
        isLoginViewPresented: .constant(false),
        isSignUpViewPresented: .constant(false)
    )
}
