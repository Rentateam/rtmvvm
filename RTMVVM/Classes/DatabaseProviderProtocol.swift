//Copyright © 2018 Rentateam. All rights reserved.

import Foundation
import RealmSwift

protocol DatabaseProviderProtocol {
    func getRealm() -> Realm
}
