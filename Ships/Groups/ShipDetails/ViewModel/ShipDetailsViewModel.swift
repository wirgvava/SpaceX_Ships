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
    @Published var isFavorite: Bool
    
    // MARK: - Dependencies
    private let favoritesStorage: FavoritesStorageProtocol
    
    // MARK: - Init
    init(item: ShipDisplayItem, favoritesStorage: FavoritesStorageProtocol) {
        self.item = item
        self.favoritesStorage = favoritesStorage
        self.isFavorite = favoritesStorage.isFavorite(shipId: item.ship.id)
        self.setupBindings()
    }
    
    private func setupBindings() {
        favoritesStorage.favoritesPublisher
            .receive(on: DispatchQueue.main)
            .map { [weak self] favorites in
                guard let self = self else { return false }
                return favorites.contains(self.item.ship.id)
            }
            .assign(to: &$isFavorite)
    }
    
    func toggleFavorite() {
        favoritesStorage.toggleFavorite(shipId: item.ship.id)
    }
    
    func openLink() {
        guard let url = URL(string: item.ship.url) else { return }
        UIApplication.shared.open(url)
    }
}
