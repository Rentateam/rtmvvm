//Copyright © 2018 Rentateam. All rights reserved.

import Foundation

class ViewModelWeakList<T: AnyObject> {
    private var modelList: NSHashTable<T>
    
    init() {
        self.modelList = NSHashTable<T>.weakObjects()
    }
    
    func addViewModel(model: T) {
        if !self.modelList.contains(model) {
            self.modelList.add(model)
        }
    }
    
    func getList() -> [T] {
        return self.modelList.allObjects
    }
}
