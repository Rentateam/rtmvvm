//Copyright © 2019 Rentateam. All rights reserved.

import Foundation
import RealmSwift

//After you delete your RealmObject from database, realmObject returns nil.
//If you want to add the same object one more time after deletion, you should reinstaniate
//repository subscriber one more time.
public class VMRepositorySingleSubscriber<F: ViewModelSingleFactoryProtocol> {
    let factory: F
    let repository: VMRepositorySingleProtocol
    let bgQueue: DispatchQueue
    let databaseService: DatabaseProviderProtocol
    private lazy var realmObject: F.RealmObject? = {
        return self.factory.getRealmObject(realm: self.databaseService.getRealm())
    }()
    private var notificationToken: NotificationToken?
    
    public init(factory: F,
                repository: VMRepositorySingleProtocol,
                databaseService: DatabaseProviderProtocol,
                bgQueue: DispatchQueue,
                shouldBindToDatabase: Bool = true) {
        self.factory = factory
        self.repository = repository
        self.bgQueue = bgQueue
        self.databaseService = databaseService
        if shouldBindToDatabase {
            self.bindNotifications()
        }
    }
    
    deinit {
        self.notificationToken?.invalidate()
    }
    
    private func bindNotifications() {
        self.notificationToken = self.realmObject?.observe({ change in
            switch change {
            case .change:
                guard let realmObj = self.realmObject else {
                    NSLog("VMRepositorySubscriber, realm object is nil while changing is emitted")
                    return
                }
                
                let objectRef = ThreadSafeReference(to: realmObj)
                self.bgQueue.async { [weak self] in
                    autoreleasepool {
                        guard let weakSelf = self else {
                            return
                        }
                        
                        let realm = weakSelf.databaseService.getRealm()
                        var viewModel: F.ViewModel?
                        if let objectInThread = realm.resolve(objectRef) {
                            viewModel = weakSelf.factory.createViewModelSingle(item: objectInThread)
                        }
                        DispatchQueue.main.async { [weak self] in
                            if let theViewModel = viewModel {
                                self?.repository.setEmbedViewModel(viewModel: theViewModel)
                            }
                        }
                    }
                }
                break
            case .deleted:
                DispatchQueue.main.async { [weak self] in
                    self?.repository.setEmbedViewModel(viewModel: nil)
                }
                break
            case .error:
                break
            }
        })
    }
}
