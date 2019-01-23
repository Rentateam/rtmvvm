//
//  AssemblyContainer.swift
//  RTMVVM-Example
//
//  Created by A-25 on 25/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import Dip
import RTMVVM

class AssemblyContainer {
    private static var dependencyContainer: DependencyContainer?
    
    public static func container() -> DependencyContainer {
        if AssemblyContainer.dependencyContainer == nil {
            let container = DependencyContainer()
            for assembly in AssemblyContainer.getAssemblies() {
                assembly.configure(container: container)
            }
            try! container.bootstrap()
            AssemblyContainer.dependencyContainer = container
            DependencyContainer.uiContainers = [container]
        }
        return AssemblyContainer.dependencyContainer!
    }
    
    static func getAssemblies() -> [AssemblyProtocol] {
        return [
            DatabaseAssembly()
            ] + AssemblyContainer.getViewControllerAssemblies()
    }
    
    static func getViewControllerAssemblies() -> [AssemblyProtocol] {
        return [
        ]
    }
}
