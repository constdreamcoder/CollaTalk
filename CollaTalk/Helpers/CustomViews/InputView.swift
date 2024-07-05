//
//  InputView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/5/24.
//

import SwiftUI

struct InputView: View {
    
    @Binding var text: String

    private let title: String
    private let placeholder: String
    private let showRightButton: Bool
    private let isSecure: Bool
    private let isRightButtonDisable: Bool
    private let rightButtonAction: () -> Void
    
    init(
        text: Binding<String>,
        title: String,
        placeholder: String,
        showRightButton: Bool = false,
        isSecure: Bool = false,
        isRightButtonDisable: Bool = true,
        rightButtonAction: @escaping () -> Void
    ) {
        self._text = text
        self.title = title
        self.placeholder = placeholder
        self.showRightButton = showRightButton
        self.isSecure = isSecure
        self.isRightButtonDisable = isRightButtonDisable
        self.rightButtonAction = rightButtonAction
    }
        
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 15, weight: .bold))
            
            HStack {
                
                Group {
                    if isSecure {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .font(.title2)
                .disableAutocorrection(true)
                .padding(.vertical, 14)
                .padding(.leading, 12)
                .padding(.trailing, showRightButton ? 0 : 12)
                .background(.brandWhite)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                if showRightButton {
                    CustomButton(action: {
                        rightButtonAction()
                    }, label: {
                        Text("중복 확인")
                    })
                    .bottomButtonShape(isRightButtonDisable ? .brandInactive : .brandGreen)
                    .frame(width: 120, height: 45)
                    .disabled(isRightButtonDisable)
                }
            }
        }
        .background(.clear)
        .padding(.leading, 16)
        .padding(.trailing, showRightButton ? 0 : 16)
    }
}

#Preview {
    InputView(text: .constant(""), title: "이메일", placeholder: "이메일을 입력하세요",  rightButtonAction: {})
}
