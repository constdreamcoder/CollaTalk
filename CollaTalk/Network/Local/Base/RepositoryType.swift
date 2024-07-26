//
//  RepositoryType.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/26/24.
//

import Foundation
import RealmSwift

protocol RepositoryType {
    associatedtype T: Object
        
    func getLocationOfDefaultRealm()
    func read() -> Results<T>
    func write(_ object: T)
    func update(_ object: T)
    func delete(_ object: T)
    func deleteAll()
}
