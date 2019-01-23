//
//  UserEntityViewModel.swift
//  RTMVVM-Example
//
//  Created by A-25 on 24/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import RTMVVM

class UserEntityViewModel: NSObject, ViewModelProtocol {
    let id: String
    let name: String
    let dateField: Date?
    
    init(id: String,
         name: String,
         dateField: Date?) {
        self.id = id
        self.name = name
        self.dateField = dateField
        super.init()
    }
}
