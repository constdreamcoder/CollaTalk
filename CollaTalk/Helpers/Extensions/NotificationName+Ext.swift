//
//  NotificationName+Ext.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/10/24.
//

import Foundation

enum NotificationNameKey {
    static let gobackToRootView = "GobackToRootView"
}

extension Notification.Name {
    static let gobackToRootView = Notification.Name(NotificationNameKey.gobackToRootView)
}
