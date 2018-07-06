//Copyright © 2018 Rentateam. All rights reserved.

import Foundation

class ViewModelSubscriberEngine<T: AnyObject> {
    private let container: ViewModelWeakList<T>
    
    init() {
        self.container = ViewModelWeakList<T>()
    }
    
    func bindHandler(subscriber: AnyObject, name: NSNotification.Name, handler: Selector) {
        NotificationCenter.default.addObserver(subscriber,
                                               selector: handler,
                                               name: name,
                                               object: nil)
    }
    
    func addViewModel(model: T) {
        self.container.addViewModel(model: model)
    }
    
    func rebuildViewModels(_ rebuildHandler: ((_ model: T) -> Void)) {
        for model in self.container.getList() {
            rebuildHandler(model)
        }
    }
}
