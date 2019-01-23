//
//  UserEntityObject.swift
//  RTMVVM-Example
//
//  Created by A-25 on 24/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import RealmSwift

class UserEntityObject: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name = ""
    @objc dynamic var dateField: Date?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
