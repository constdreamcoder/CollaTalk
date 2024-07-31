//
//  CellHeader.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/31/24.
//

import SwiftUI

struct CellHeader: View {
    
    @Binding var isExpanded: Bool
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
            
            Spacer()
            
            Image(systemName: isExpanded ? "chevron.down" : "chevron.forward")
                .font(.title2)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isExpanded.toggle()
                    }
                }
        }
        .frame(height: 56)
    }
}
