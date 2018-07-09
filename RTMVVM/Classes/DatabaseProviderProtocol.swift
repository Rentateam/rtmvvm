//Copyright © 2018 Rentateam. All rights reserved.

import Foundation
import RealmSwift

public protocol DatabaseProviderProtocol {
    func getRealm() -> Realm
}
