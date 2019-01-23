//
//  TestEntityObject.swift
//  rtmvvm
//
//  Created by A-25 on 23/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import RealmSwift

class TestEntityObject: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var boolField = false
    @objc dynamic var dateField: Date?
    @objc dynamic var sortOrder = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
