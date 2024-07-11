//
//  WorspaceInitView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/11/24.
//

import SwiftUI

struct WorspaceInitView: View {
    var body: some View {
        
        ZStack {
            
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack {
                NavigationBarForCreatingNewFeature(title: .workspaceInit, isPresented: .constant(true))
                
                Spacer()
                    .frame(height: 35)
                
                Text("출시 준비 완료!")
                    .font(.title1)
                
                Spacer()
                    .frame(height: 24)

                Text("옹골찬 고래밥님의 조직을 위해 새로운 새싹톡 워크스페이스를 시작할 준비가 완료되었어요!")
                    .multilineTextAlignment(.center)
                    .font(.body)
                
                Spacer()
                    .frame(height: 15)
                
                Image(.launching)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Spacer()
                
                CustomButton {
                    print("워크 스페이스 생성")
                } label: {
                    Text("워크 스페이스 생성")
                }
                .bottomButtonShape(.brandGreen)
                
                Spacer()
                    .frame(height: 24)
            }
        }
    }
}

#Preview {
    WorspaceInitView()
}
