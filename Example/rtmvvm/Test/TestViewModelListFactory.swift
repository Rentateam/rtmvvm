//
//  TestViewModelListFactory.swift
//  RTMVVM-Example
//
//  Created by A-25 on 23/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import RTMVVM
import RealmSwift

class TestViewModelListFactory: ViewModelListFactoryProtocol {
    typealias ViewModel = TestEntityViewModel
    typealias RealmObject = TestEntityObject
    
    func getRealmResults(realm: Realm) -> Results<RealmObject> {
        return realm.objects(TestEntityObject.self).sorted(byKeyPath: "sortOrder", ascending: true)
    }
    
    func createViewModelList(results: Results<RealmObject>) -> [ViewModel] {
        var list = [ViewModel]()
        results.forEach{
            list.append(self.createViewModelSingle(item: $0))
        }
        return list
    }
    
    func createViewModelSingle(item: RealmObject) -> ViewModel {
        return ViewModel(id: item.id,
                                   boolField: item.boolField,
                                   dateField: item.dateField)
    }
}
