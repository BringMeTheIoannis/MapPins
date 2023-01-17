//
//  RealmManager.swift
//  LocalDatabase (Homework)
//
//  Created by Ivan Kuzmenkov on 9.11.22.
//

import Foundation
import RealmSwift

class RealmManager<T> where T: Object {
    
    var realm = try! Realm()
    
    func write(object: T) {
        try? realm.write{
            realm.add(object)
        }
    }
    
    func delete(object: Results<T>) {
        try? realm.write{
            realm.delete(object)
        }
    }
    
    func read() -> Results<T> {
        return realm.objects(T.self)
    }
}
