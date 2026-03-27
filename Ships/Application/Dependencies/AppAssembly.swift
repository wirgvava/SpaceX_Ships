//
//  AppAssembly.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 27/03/2026.
//

import Foundation
import ShipsCore

final class AppAssembly {
    
    private let resolver: AssemblyResolver
    
    init(container: DependencyContainer = .shared) {
        self.resolver = AssemblyResolver(container: container)
    }
    
    // MARK: - Setup
    func configure() {
        resolver.apply([
            CoreAssembly()
            //
        ])
    }
}
