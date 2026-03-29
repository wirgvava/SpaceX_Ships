//
//  ShipDetailsAssembly.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 29/03/2026.
//

import ShipsCore
import ShipsModels

final class ShipDetailsAssembly: Assembly {
    func assemble(container: ShipsCore.DependencyContainer) {
        container.register(ShipDetailsViewModel.self) { resolver, item in
            ShipDetailsViewModel(item: item)
        }
    }
    
    static func resolve(item: ShipDisplayItem) -> ShipDetailsViewModel {
        DependencyContainer.shared.resolve(ShipDetailsViewModel.self, argument: item)
    }
    
    static func makeView(item: ShipDisplayItem) -> ShipDetailsView {
        ShipDetailsView(item: item)
    }
}
