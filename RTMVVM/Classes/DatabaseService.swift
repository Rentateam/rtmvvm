//
//  DatabaseService.swift
//  RTMVVM
//
//  Created by A-25 on 25/01/2019.
//

import Foundation
import RealmSwift

public class DatabaseService: DatabaseProviderProtocol {
    private let multithreadLock = DispatchSemaphore(value: 1)
    
    public init() {}
    
    public func getRealm() -> Realm {
        self.multithreadLock.wait()
        defer {
            self.multithreadLock.signal()
        }
        
        let realm = try! Realm()
        realm.refresh()
        return realm
    }
    
    //Метод для ограниченного использования - только там, где нужно
    public func getRealmWithoutRefresh() -> Realm {
        self.multithreadLock.wait()
        defer {
            self.multithreadLock.signal()
        }
        
        return try! Realm()
    }
}
