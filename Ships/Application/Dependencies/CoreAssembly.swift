//
//  CoreAssembly.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 27/03/2026.
//

import Foundation
import ShipsCore
import ShipsNetworking

final class CoreAssembly: Assembly {
    
    func assemble(container: DependencyContainer) {
        // Base Network Service
        container.register(NetworkServiceProtocol.self) { _ in
            NetworkService()
        }
        
        // Ships Network Service
        container.register(ShipsNetworkServiceProtocol.self) { resolver in
            ShipsNetworkService(networkService: resolver.resolve(NetworkServiceProtocol.self))
        }
    }
}
