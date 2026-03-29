//
//  ShipsListAssembly.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 28/03/2026.
//

import Foundation
import ShipsCore

final class ShipsListAssembly: Assembly {
    func assemble(container: ShipsCore.DependencyContainer) {
        container.register(ShipsListViewModel.self) { resolver in
            ShipsListViewModel(
                networkService: resolver.resolve(ShipsNetworkServiceProtocol.self),
                favoritesStorage: resolver.resolve(FavoritesStorageProtocol.self)
            )
        }
    }
    
    static func resolve() -> ShipsListViewModel {
        DependencyContainer.shared.resolve(ShipsListViewModel.self)
    }
}
