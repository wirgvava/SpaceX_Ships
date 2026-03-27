//
//  Assembly.swift
//  ShipsCore
//
//  Created by Konstantine Tsirgvava on 27/03/2026.
//

import Foundation

public protocol Assembly {
    func assemble(container: DependencyContainer)
}

public final class AssemblyResolver {
    
    private let container: DependencyContainer
    
    // Init
    public init(container: DependencyContainer = .shared) {
        self.container = container
    }
    
    // Apply all assemblies
    public func apply(_ assemblies: [Assembly]) {
        for assembly in assemblies {
            assembly.assemble(container: container)
        }
    }
}
