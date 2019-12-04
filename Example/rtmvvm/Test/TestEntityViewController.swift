//
//  TestEntityViewController.swift
//  RTMVVM-Example
//
//  Created by A-25 on 23/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import RealmSwift
import RTMVVM

class VMTestVMRepositoryList: NSObject, VMRepositoryListProtocol {
    func getEmbedViewModel() -> [NSObjectProtocol]? {
        return self.viewModel
    }
    
    func setEmbedViewModel(viewModel: [NSObjectProtocol]?) {
        guard viewModel != nil else {
            self.viewModel = nil
            return
        }
        
        if let setViewModel = viewModel as? [TestEntityViewModel] {
            self.viewModel = setViewModel
        }
    }
    
    @objc dynamic var viewModel: [TestEntityViewModel]?
}

class TestEntityViewController: UITableViewController {
    
    private var viewModelRepositorySubscriber: VMRepositoryListSubscriber<TestViewModelListFactory>!
    @objc var repository: VMTestVMRepositoryList!
    private var observationTokens = [NSKeyValueObservation]()
    
    deinit {
        observationTokens.removeAll()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let objectsNumber = 100;
        
        let factory = TestViewModelListFactory()
        self.repository = VMTestVMRepositoryList()
        self.viewModelRepositorySubscriber = VMRepositoryListSubscriber<TestViewModelListFactory>(factory: factory, repository: self.repository, databaseService: DatabaseService(), bgQueue: DispatchQueue.global(), shouldBindToDatabase: true)
        
        let token = self.repository.observe(\VMTestVMRepositoryList.viewModel,
                                options: [.new, .old, .initial]) { [weak self] _, _ in
                                    self?.onViewModelChanged()
        }
        observationTokens.append(token)
        
        
        DispatchQueue.global().async {
            NSLog("Insert many objects")
            let realm = try! Realm()
            
            //Insert many objects
            realm.beginWrite()
            for i in 1...objectsNumber {
                let testObj = TestEntityObject()
                testObj.id = "\(i)"
                testObj.boolField = true
                testObj.dateField = Date()
                testObj.sortOrder = i
                realm.add(testObj)
            }
            try! realm.commitWrite()
            
            sleep(2)
            
            NSLog("Update objects")
            //Update objects
            realm.beginWrite()
            realm.objects(TestEntityObject.self).forEach{
                if $0.id.count == 1 {
                    $0.boolField = false
                }
            }
            try! realm.commitWrite()
            
            sleep(2)
            
            NSLog("Insert new objects")
            
            //Insert new objects
            realm.beginWrite()
            for i in objectsNumber+1...objectsNumber*2 {
                let testObj = TestEntityObject()
                testObj.id = "\(i)"
                testObj.boolField = true
                testObj.dateField = Date()
                testObj.sortOrder = i
                realm.add(testObj)
            }
            try! realm.commitWrite()
            
            sleep(2)
            
            NSLog("Delete objects")
            
            //Delete objects
            realm.beginWrite()
            let objectsToDelete = realm.objects(TestEntityObject.self).filter({
                return $0.id.count == 2
            })
            realm.delete(objectsToDelete)
            try! realm.commitWrite()
        }
    }
    
    @objc func onViewModelChanged() {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repository.viewModel?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        if let item = self.repository.viewModel?[indexPath.row] {
            cell.textLabel?.text = item.id
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/mm/yyyy"
            cell.detailTextLabel?.text = (item.dateField != nil) ? dateFormatter.string(from: item.dateField!) : nil
            cell.accessoryType = item.boolField ? .disclosureIndicator : .none
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
