//
//  ShipDetailsViewModel.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 29/03/2026.
//

import SwiftUI
import Combine
import ShipsModels

final class ShipDetailsViewModel: ObservableObject {
    
    @Published private(set) var item: ShipDisplayItem
    
    init(item: ShipDisplayItem) {
        self.item = item
    }
    
    func toggleFavorite() {
        // TODO: -
    }
    
    func openLink() {
        guard let url = URL(string: item.ship.url) else { return }
        UIApplication.shared.open(url)
    }
}
