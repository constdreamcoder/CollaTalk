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
}

extension BaseRepository {
    func getLocationOfDefaultRealm() {
        let realm = try! Realm()
        print("Realm is located at:", realm.configuration.fileURL!)
    }
    
    func read() -> Results<T> {
        let realm = try! Realm()
        return realm.objects(T.self)
    }
    
    func write(_ object: T) {
        do {
            let realm = try Realm()
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
            let realm = try Realm()
            try realm.write {
                realm.add(object)
                print("\([T].self) 객체가 추가되었습니다.")
                getLocationOfDefaultRealm()
            }
        } catch {
            print(error)
        }
    }
    
    func delete(_ object: T) {
        do {
            let realm = try Realm()
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
            let realm = try Realm()
            try realm.write {
                realm.delete(realm.objects(T.self))
                print("\(T.self) 객체가 모두 삭제되었습니다.")
            }
        } catch {
            print(error)
        }
    }
    
    static func deleteAllObjects() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
                print("Realm에 있는 모든 객체가 삭제되었습니다.")
            }
        } catch {
            print(error)
        }
    }
}
