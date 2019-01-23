//Copyright © 2019 Rentateam. All rights reserved.

import Foundation
import RealmSwift

public protocol ViewModelProtocol: NSObjectProtocol {
    
}

public protocol ViewModelFactoryTypeProtocol {
    associatedtype ViewModel: ViewModelProtocol
    associatedtype RealmObject: Object
}

public protocol ViewModelListFactoryProtocol: ViewModelFactoryTypeProtocol {
    func getRealmResults(realm: Realm) -> Results<RealmObject>
    func createViewModelList(results: Results<RealmObject>) -> [ViewModel]
    func createViewModelSingle(item: RealmObject) -> ViewModel
}

public protocol ViewModelSingleFactoryProtocol: ViewModelFactoryTypeProtocol {
    func getRealmObject(realm: Realm) -> RealmObject?
    func createViewModelSingle(item: RealmObject) -> ViewModel
}
