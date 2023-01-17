//
//  LocationModel.swift
//  LocalDatabase (Homework)
//
//  Created by Ivan Kuzmenkov on 9.11.22.
//

import Foundation
import RealmSwift


class LocationModel: Object {
    
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longtitude: Double = 0.0
    @objc dynamic var time: Date = Date()
    
    convenience init(latitude: Double, longtitude: Double, time: Date) {
        self.init()
        self.latitude = latitude
        self.longtitude = longtitude
        self.time = time
    }
}
