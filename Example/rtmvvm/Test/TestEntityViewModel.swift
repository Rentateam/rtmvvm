//
//  TestEntityViewModel.swift
//  RTMVVM
//
//  Created by A-25 on 23/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import RTMVVM

class TestEntityViewModel: NSObject, ViewModelProtocol {
    let id: String
    let boolField: Bool
    let dateField: Date?
    
    init(id: String,
         boolField: Bool,
         dateField: Date?) {
        self.id = id
        self.boolField = boolField
        self.dateField = dateField
        super.init()
    }
}
