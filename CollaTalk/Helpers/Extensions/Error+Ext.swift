//
//  Error+Ext.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/11/24.
//

import Foundation

extension Error {
    var asOriginalError: Self {
        return self as Self
    }
}
