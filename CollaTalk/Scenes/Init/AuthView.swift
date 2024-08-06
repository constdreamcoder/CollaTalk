//
//  AuthView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/5/24.
//

import SwiftUI

struct AuthView: View {
        
    @EnvironmentObject private var store: AppStore
    @StateObject private var appleLoginCoordinator = AppleLoginCoodinator()
    @StateObject private var kakaoLoginCoordinator = KakaoLoginCoordinator()
    
    var body: some View {
        if store.state.navigationState.isBottomSheetPresented {
            BottomSheetView(
                Binding(get: { store.state.navigationState.isBottomSheetPresented },
                        set: { store.dispatch(.navigationAction(.presentBottomSheet(present: $0)))
                        }),
                height: 290
            ) {
                VStack(spacing: 16) {
                    CustomButton {
                        print("Apple으로 계속하기")
                        appleLoginCoordinator.store = store
                        appleLoginCoordinator.loginWithAppleID()
                    } label: {
                        HStack{
                            Image(.appleLogo)
                            Text("Apple으로 계속하기")
                        }
                    }
                    .bottomButtonShape(.appleLogin)
                    
                    CustomButton {
                        print("카카오톡으로 계속하기")
                        kakaoLoginCoordinator.store = store
                        kakaoLoginCoordinator.startLoginWithKakaoTalk()
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
                        store.dispatch(.navigationAction(.presentLoginView(present: true)))
                    } label: {
                        HStack{
                            Image(.emailIcon)
                            Text("이메일로 계속하기")
                        }
                    }
                    .bottomButtonShape(.brandGreen)
                    
                    CustomButton {
                        print("또는 새롭게 회원가입 하기")
                        store.dispatch(.navigationAction(.presentSignUpView(present: true)))
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
    AuthView()
}
