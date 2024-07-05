//
//  OnboardingView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/5/24.
//

import SwiftUI

struct OnboardingView: View {
    
    @Binding var isBottomSheetPresented: Bool
    
    var body: some View {
        VStack {
            Spacer()
    
            Text("CollaTalk을 사용하면 어디서나\n팀을 모을 수 있습니다")
                .multilineTextAlignment(.center)
                .font(.title1)
            
            Spacer()
            
            Image(.onboarding)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Spacer()
            
            CustomButton {
                print("시작하기")
                isBottomSheetPresented = true
            } label: {
                Text("시작하기")
            }
            .bottomButtonShape(.brandGreen)
            
            Spacer()
                .frame(height: 45)
        }
    }
}

#Preview {
    OnboardingView(isBottomSheetPresented: .constant(false))
}
