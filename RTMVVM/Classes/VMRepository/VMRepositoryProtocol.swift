//Copyright © 2019 Rentateam. All rights reserved.

import Foundation

@objc public protocol VMRepositoryListProtocol: NSObjectProtocol {
    func getEmbedViewModel() -> [NSObjectProtocol]?
    func setEmbedViewModel(viewModel: [NSObjectProtocol]?)
}

@objc public protocol VMRepositorySingleProtocol: NSObjectProtocol {
    func getEmbedViewModel() -> NSObjectProtocol?
    func setEmbedViewModel(viewModel: NSObjectProtocol?)
}
