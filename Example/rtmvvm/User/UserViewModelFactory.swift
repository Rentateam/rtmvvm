//
//  UserViewModelFactory.swift
//  RTMVVM-Example
//
//  Created by A-25 on 24/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import RTMVVM
import RealmSwift

class UserViewModelFactory: ViewModelSingleFactoryProtocol {
    typealias ViewModel = UserEntityViewModel
    typealias RealmObject = UserEntityObject
    
    func getRealmObject(realm: Realm) -> RealmObject? {
        return realm.objects(UserEntityObject.self).first
    }
    
    func createViewModelSingle(item: RealmObject) -> ViewModel {
        return ViewModel(id: item.id,
                                   name: item.name,
                                   dateField: item.dateField)
    }
}
