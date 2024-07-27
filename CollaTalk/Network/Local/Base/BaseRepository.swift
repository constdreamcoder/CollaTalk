//
//  BaseRepository.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/26/24.
//

import Foundation
import RealmSwift

class BaseRepository<ModelType: Object>: RepositoryType {
    typealias T = ModelType
        
    var realm: Realm {
        try! Realm()
    }
    
    init() {}
}

extension BaseRepository {
    func getLocationOfDefaultRealm() {
        print("Realm is located at:", realm.configuration.fileURL!)
    }
    
    func read() -> Results<T> {
        return realm.objects(T.self)
    }
    
    func write(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
                print("\(T.self) 객체가 추가되었습니다.")
                getLocationOfDefaultRealm()
            }
        } catch {
            print(error)
        }
    }
    
    func write(_ object: [T]) {
        do {
            try realm.write {
                realm.add(object)
                print("\([T].self) 객체가 추가되었습니다.")
                getLocationOfDefaultRealm()
            }
        } catch {
            print(error)
        }
    }
    
    func update(_ object: T) {
        do {
            try realm.write {
                realm.add(object, update: .modified)
                print("\(T.self) 객체가 수정되었습니다.")
            }
        } catch {
            print(error)
        }
    }
    
    func delete(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
                print("\(T.self) 객체가 삭제되었습니다.")
            }
        } catch {
            print(error)
        }
    }
    
    func deleteAll() {
        do {
            try realm.write {
                realm.delete(realm.objects(T.self))
                print("\(T.self) 객체가 모두 삭제되었습니다.")
            }
        } catch {
            print(error)
        }
    }
}
