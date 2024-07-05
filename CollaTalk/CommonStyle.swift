//
//  CommonStyle.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 6/30/24.
//

import SwiftUI
extension Font {
    static let title1: Font = .system(size: 22, weight: .bold)
    static let title2: Font = .system(size: 14, weight: .bold)
    static let bodyBold: Font = .system(size: 13, weight: .bold)
    static let body: Font = .system(size: 13, weight: .regular)
    static let caption: Font = .system(size: 12, weight: .regular)
}

enum CommonStyle {
    enum Typography {
        static let title1: Font = .system(size: 22, weight: .bold)
        static let title2: Font = .system(size: 14, weight: .bold)
        static let bodyBold: Font = .system(size: 13, weight: .bold)
        static let body: Font = .system(size: 13, weight: .regular)
        static let caption: Font = .system(size: 12, weight: .regular)
    }
}
