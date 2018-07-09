//Copyright © 2018 Rentateam. All rights reserved.

import Foundation

public class ViewModelWeakList<T: AnyObject> {
    private var modelList: NSHashTable<T>
    
    public init() {
        self.modelList = NSHashTable<T>.weakObjects()
    }
    
    public func addViewModel(model: T) {
        if !self.modelList.contains(model) {
            self.modelList.add(model)
        }
    }
    
    public func getList() -> [T] {
        return self.modelList.allObjects
    }
}
