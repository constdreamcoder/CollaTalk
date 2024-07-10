//
//  InputView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/5/24.
//

import SwiftUI

struct InputView: View {
    
    private let title: String
    private let placeholder: String
    private let showRightButton: Bool
    private let isSecure: Bool
    private let isRightButtonAble: Bool
    private let textFieldGetter: () -> String
    private let textFieldSetter: (String) -> Void
    private let secureFieldGetter: () -> String
    private let secureFieldSetter: (String) -> Void
    private let rightButtonAction: () -> Void
    private let isValid: Bool
    
    init(
        title: String,
        placeholder: String,
        showRightButton: Bool = false,
        isSecure: Bool = false,
        isRightButtonAble: Bool = false,
        textFieldGetter: @escaping (() -> String),
        textFieldSetter: @escaping (String) -> Void,
        secureFieldGetter: @escaping () -> String,
        secureFieldSetter: @escaping (String) -> Void,
        rightButtonAction: @escaping () -> Void,
        isValid: Bool = true
    ) {
        self.title = title
        self.placeholder = placeholder
        self.showRightButton = showRightButton
        self.isSecure = isSecure
        self.isRightButtonAble = isRightButtonAble
        self.textFieldGetter = textFieldGetter
        self.textFieldSetter = textFieldSetter
        self.secureFieldGetter = secureFieldGetter
        self.secureFieldSetter = secureFieldSetter
        self.rightButtonAction = rightButtonAction
        self.isValid = isValid
    }
    
        
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundStyle(isValid ? .brandBlack : .brandError)
                .font(.system(size: 15, weight: .bold))
            
            HStack {
                
                Group {
                    if isSecure {
                        SecureField(
                            placeholder,
                            text: Binding(
                                get: secureFieldGetter,
                                set: secureFieldSetter
                            )
                        )
                    } else {
                        TextField(
                            placeholder,
                            text: Binding(
                                get: textFieldGetter,
                                set: textFieldSetter
                            )
                        )
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
                    .bottomButtonShape(isRightButtonAble ? .brandGreen : .brandInactive)
                    .frame(width: 120, height: 45)
                    .disabled(!isRightButtonAble)
                }
            }
        }
        .background(.clear)
        .padding(.leading, 16)
        .padding(.trailing, showRightButton ? 0 : 16)
    }
}

#Preview {
    InputView(title: "이메일", placeholder: "이메일을 입력하세요",  textFieldGetter: {""}, textFieldSetter: { _ in }, secureFieldGetter: {""}, secureFieldSetter: { _ in }, rightButtonAction: {})
}
