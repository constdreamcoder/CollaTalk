//
//  NavigationFrameView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/31/24.
//

import SwiftUI

struct NavigationFrameView: View {
    
    let title: String
    let leftButtonAction: (() -> Void)?
    let rightButtonAction: (() -> Void)?
    let isRightButtonHidden: Bool
    
    init(
        title: String = "",
        leftButtonAction: (() -> Void)? = nil,
        rightButtonAction: (() -> Void)? = nil,
        isRightButtonHidden: Bool = true
    ) {
        self.title = title
        self.leftButtonAction = leftButtonAction
        self.rightButtonAction = rightButtonAction
        self.isRightButtonHidden = isRightButtonHidden
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(
                    action: {
                        if let leftButtonAction {
                            leftButtonAction()
                        }
                    },
                    label: {
                        Image(systemName: "chevron.left")
                            .font(.title1)
                            .frame(width: 17, height: 22)
                    }
                )
                .padding(10)
                
                Spacer()
                
                Text(title)
                    .font(.title1)
                    .lineLimit(1)
                
                Spacer()
                
                Button(
                    action: {
                        if let rightButtonAction {
                            rightButtonAction()
                        }
                    },
                    label: {
                        Image(systemName: "list.bullet")
                            .font(.title1)
                            .frame(width: 18, height: 16)
                    }
                )
                .padding(.trailing, 15)
                .hidden(isRightButtonHidden)
            }
            .foregroundStyle(.brandBlack)
            
            Divider()
        }
    }
}
