//Copyright © 2018 Rentateam. All rights reserved.

import Foundation

public class ViewModelSubscriberEngine<T: AnyObject> {
    private let container: ViewModelWeakList<T>
    
    public init() {
        self.container = ViewModelWeakList<T>()
    }
    
    public func bindHandler(subscriber: AnyObject, name: NSNotification.Name, handler: Selector) {
        NotificationCenter.default.addObserver(subscriber,
                                               selector: handler,
                                               name: name,
                                               object: nil)
    }
    
    public func addViewModel(model: T) {
        self.container.addViewModel(model: model)
    }
    
    public func rebuildViewModels(_ rebuildHandler: ((_ model: T) -> Void)) {
        for model in self.container.getList() {
            rebuildHandler(model)
        }
    }
}
