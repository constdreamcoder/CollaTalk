//
//  UserDefaultsManager.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/9/24.
//

import Foundation

struct UserDefaultsManager {
    enum Key: String {
        case userInfo = "userInfo"
        case selectedWorkspace = "selectedWorkspace"
    }
    
    private static let standard = UserDefaults.standard
    
    static func setObject<T: Codable>(_ object: T, forKey key: Key) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            standard.set(encoded, forKey: key.rawValue)
        }
    }
    
    static func getObject<T: Codable>(forKey key: Key, as type: T.Type) -> T? {
        guard let data = standard.data(forKey: key.rawValue) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
    
    static func removeObject(forKey key: Key) {
        standard.removeObject(forKey: key.rawValue)
    }
}
