//
//  StorageManager.swift
//  myPlaces
//
//  Created by Миша Вашкевич on 11.10.2021.
//

import RealmSwift

let realm = try! Realm()


class StorageManager {
    
    static func saveObject(_ place: Place) {
    
        try! realm.write {
            realm.add(place)
        }
    }
    
    static func deleteObject(_ place: Place) {
        try! realm.write {
            realm.delete(place)
        }
        
    }
}
