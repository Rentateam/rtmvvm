//
//  DatabaseAssembly.swift
//  Dip
//
//  Created by A-25 on 25/01/2019.
//

import Foundation
import Dip

public class DatabaseAssembly: AssemblyProtocol {
    public init() {}
    
    public func configure(container: DependencyContainer) {
        let databaseService: DatabaseProviderProtocol = DatabaseService()
        container.register(tag: AssemblyTag.databaseService) { databaseService as DatabaseProviderProtocol }
        
        container.register(.singleton, tag: AssemblyTag.backgroundQueue) { DispatchQueue.global(qos: .utility) }
    }
}
