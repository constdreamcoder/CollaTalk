//
//  String+Ext.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/15/24.
//

import Foundation

extension String {
    var toWorkspaceCellDateFormat: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputFormatter.date(from: self) else { return "" }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yy. MM. dd"
        
        return outputFormatter.string(from: date)
    }
    
    var toChatTime: String {
        let inputDateFormatter = ISO8601DateFormatter()
        inputDateFormatter.timeZone = .current
        inputDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = inputDateFormatter.date(from: self) else { return "" }
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.locale = Locale(identifier: "ko_KR")
        outputDateFormatter.dateFormat = "hh:mm a"
        return outputDateFormatter.string(from: date)
    }
    
    var toChatDate: String {
        let inputDateFormatter = ISO8601DateFormatter()
        inputDateFormatter.timeZone = .current
        inputDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = inputDateFormatter.date(from: self) else { return "" }
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.locale = Locale(identifier: "ko_KR")
        outputDateFormatter.dateFormat = "yyyy.MM.dd E"
        return outputDateFormatter.string(from: date)
    }
}
