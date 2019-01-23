//Copyright © 2019 Rentateam. All rights reserved.

import Foundation
import RealmSwift

public class VMRepositoryListSubscriber<F: ViewModelListFactoryProtocol> {
    let factory: F
    let repository: VMRepositoryListProtocol
    let bgQueue: DispatchQueue
    let databaseService: DatabaseProviderProtocol
    private lazy var realmResults: Results<F.RealmObject> = {
        return self.factory.getRealmResults(realm: self.databaseService.getRealm())
    }()
    private var notificationToken: NotificationToken?
    private let shouldBindToDatabase: Bool
    
    public init(factory: F,
                repository: VMRepositoryListProtocol,
                databaseService: DatabaseProviderProtocol,
                bgQueue: DispatchQueue,
                shouldBindToDatabase: Bool = true) {
        self.factory = factory
        self.repository = repository
        self.bgQueue = bgQueue
        self.databaseService = databaseService
        self.shouldBindToDatabase = shouldBindToDatabase
        self.bindNotifications()
    }
    
    deinit {
        self.notificationToken?.invalidate()
    }
    
    private func bindNotifications() {
        self.notificationToken = self.realmResults.observe{ changes in
            switch changes {
            case .initial(let results):
                let resultsRef = ThreadSafeReference(to: results)
                self.bgQueue.async { [weak self] in
                    autoreleasepool {
                        guard let weakSelf = self else {
                            return
                        }
                        
                        let realm = weakSelf.databaseService.getRealm()
                        var viewModel: [F.ViewModel]?
                        if let resultsInThread = realm.resolve(resultsRef) {
                            viewModel = weakSelf.factory.createViewModelList(results: resultsInThread)
                        }
                        DispatchQueue.main.async { [weak self] in
                            if let theViewModel = viewModel {
                                self?.repository.setEmbedViewModel(viewModel: theViewModel)
                            }
                        }
                    }
                }
                break
            case .update(let results, let deletions, let insertions, let modifications):
                if !self.shouldBindToDatabase {
                    break
                }
                let resultsRef = ThreadSafeReference(to: results)
                self.bgQueue.async { [weak self] in
                    autoreleasepool {
                        guard let weakSelf = self else {
                            return
                        }
                        
                        guard let embedViewModel = weakSelf.repository.getEmbedViewModel() as? [F.ViewModel] else {
                            let embeddedViewModel = weakSelf.repository.getEmbedViewModel()
                            let embeddedViewModelType = embeddedViewModel != nil ? String(describing: type(of: embeddedViewModel)) : "nil"
                            assertionFailure("VMRepository, embedViewModel is of wrong type, needed \(F.ViewModel.self), found \(embeddedViewModelType)")
                            return
                        }
                        let realm = weakSelf.databaseService.getRealm()
                        guard let resultsInThread = realm.resolve(resultsRef) else {
                            return
                        }
                        
                        var currentViewModel = embedViewModel
                        currentViewModel = weakSelf.getProcessedDeletions(viewModel: currentViewModel, deletions: deletions)
                        currentViewModel = weakSelf.getProcessedInsertions(viewModel: currentViewModel, collection: resultsInThread, insertions: insertions)
                        currentViewModel = weakSelf.getProcessedModifications(viewModel: currentViewModel, collection: resultsInThread, modifications: modifications)
                        DispatchQueue.main.async { [weak self] in
                            self?.repository.setEmbedViewModel(viewModel: currentViewModel)
                        }
                    }
                }
                break
            case .error:
                break
            }
        }
    }
    
    private func getProcessedDeletions(viewModel: [F.ViewModel], deletions: [Int]) -> [F.ViewModel] {
        return viewModel.enumerated().filter({ !deletions.contains($0.offset)}).map({ $0.element })
    }
    
    private func getProcessedInsertions(viewModel: [F.ViewModel], collection: Results<F.RealmObject>, insertions: [Int]) -> [F.ViewModel] {
        var currentViewModel = viewModel
        insertions.forEach {
            let item = collection[$0]
            currentViewModel.insert(self.factory.createViewModelSingle(item: item), at: $0)
        }
        return currentViewModel
    }
    
    private func getProcessedModifications(viewModel: [F.ViewModel], collection: Results<F.RealmObject>, modifications: [Int]) -> [F.ViewModel] {
        var currentViewModel = viewModel
        modifications.forEach {
            let item = collection[$0]
            currentViewModel[$0] = self.factory.createViewModelSingle(item: item)
        }
        return currentViewModel
    }
}
