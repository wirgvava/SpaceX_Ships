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
        container.register(NetworkServiceProtocol.self, scope: .singleton) { _ in
            NetworkService()
        }
        
        // Ships Network Service
        container.register(ShipsNetworkServiceProtocol.self, scope: .singleton) { resolver in
            ShipsNetworkService(networkService: resolver.resolve(NetworkServiceProtocol.self))
        }
        
        // Key-Value storage
        container.register(KeyValueStorageProtocol.self, scope: .singleton) { _ in
            UserDefaultsStorage()
        }
        
        // Favorites storage
        container.register(FavoritesStorageProtocol.self, scope: .singleton) { resolver in
            FavoritesStorage(storage: resolver.resolve(KeyValueStorageProtocol.self))
        }
    }
}
