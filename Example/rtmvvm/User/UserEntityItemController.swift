//
//  TestEntityItemController.swift
//  RTMVVM-Example
//
//  Created by A-25 on 24/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import RealmSwift
import RTMVVM
import KVOController

class VMUserVMRepository: NSObject, VMRepositorySingleProtocol {
    func getEmbedViewModel() -> NSObjectProtocol? {
        return self.viewModel
    }
    
    func setEmbedViewModel(viewModel: NSObjectProtocol?) {
        guard viewModel != nil else {
            self.viewModel = nil
            return
        }
        
        if let setViewModel = viewModel as? UserEntityViewModel {
            self.viewModel = setViewModel
        }
    }
    
    @objc dynamic var viewModel: UserEntityViewModel?
}

class UserEntityItemController: UIViewController {
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameFieldLabel: UILabel!
    @IBOutlet weak var dateFieldLabel: UILabel!

    private var viewModelRepositorySubscriber: VMRepositorySingleSubscriber<UserViewModelFactory>!
    @objc var repository: VMUserVMRepository!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        
        NSLog("Insert object")
        realm.beginWrite()
        let userObj = UserEntityObject()
        userObj.id = "useridentifier"
        userObj.name = "Test Name"
        userObj.dateField = Date()
        realm.add(userObj)
        try! realm.commitWrite()
        
        let factory = UserViewModelFactory()
        self.repository = VMUserVMRepository()
        self.viewModelRepositorySubscriber = VMRepositorySingleSubscriber<UserViewModelFactory>(factory: factory, repository: self.repository, databaseService: DatabaseService(), bgQueue: DispatchQueue.global(), shouldBindToDatabase: true)
        
        self.kvoController.observe(self.repository,
                                   keyPath: #keyPath(VMUserVMRepository.viewModel),
                                   options: [.new, .old, .initial],
                                   action: #selector(self.onViewModelChanged))
        
        DispatchQueue.global().async {
            let realm = try! Realm()
            
            NSLog("Update object")
            realm.beginWrite()
            realm.objects(UserEntityObject.self).forEach{
                $0.name = "Updated Test Name"
            }
            try! realm.commitWrite()
            
            sleep(2)
            
            NSLog("Delete object")
            realm.beginWrite()
            realm.delete(realm.objects(UserEntityObject.self))
            try! realm.commitWrite()
        }
    }
    
    @objc func onViewModelChanged() {
        guard let viewModel = self.repository.viewModel else {
            self.idLabel.text = "View model is nil"
            self.nameFieldLabel.text = nil
            self.dateFieldLabel.text = nil
            return
        }
        
        self.idLabel.text = "Id: \(viewModel.id)"
        self.nameFieldLabel.text = "Name: \(viewModel.name)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/mm/yyyy"
        self.dateFieldLabel.text = (viewModel.dateField != nil) ? "Date: \(dateFormatter.string(from: viewModel.dateField!))" : "Date: nil"
    }
}
