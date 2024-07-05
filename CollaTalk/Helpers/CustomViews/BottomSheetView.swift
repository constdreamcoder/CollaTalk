//
//  BottomSheetView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/5/24.
//

import SwiftUI

struct BottomSheetView<Content>: View where Content: View {
    
    @Binding var isPresented: Bool
    private var height: CGFloat
    private var content: Content
    
    @GestureState private var translation: CGFloat = .zero
    
    init(_ isPresented: Binding<Bool>, height: CGFloat, content: () -> Content) {
        self._isPresented = isPresented
        self.height = height
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            Color.black.opacity(0.1)
                .opacity(isPresented ? 1 : 0)
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(spacing: .zero) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .frame(height: 30)
                    .overlay(
                        BottomViewGrabber()
                    )
                
                self.content
                    .frame(height: self.height)
            }
            .frame(height: self.height+30)
            .background(
                Rectangle()
                    .fill(.white)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                    .edgesIgnoringSafeArea([.bottom, .horizontal])
            )
            .transition(.opacity.combined(with: .move(edge: .bottom)))
            .offset(y: translation)
            .gesture(
                DragGesture()
                    .updating($translation) { value, state, _ in
                        if value.translation.height >= 0 {
                            state = value.translation.height
                        }
                    }
                    .onEnded({ value in
                        if value.translation.height >= height / 3 {
                            isPresented = false
                        }
                    })
            )
        }
        .ignoresSafeArea()
    }
}

#Preview {
    BottomSheetView(.constant(true), height: 300) {
        Text("안뇽")
    }
}
