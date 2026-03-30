//
//  MockFavoritesStorage.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 29/03/2026.
//

import Foundation
import Combine
@testable import Ships

final class MockFavoritesStorage: FavoritesStorageProtocol, @unchecked Sendable {
    private let favoritesSubject = CurrentValueSubject<Set<String>, Never>([])
    
    var favoritesPublisher: AnyPublisher<Set<String>, Never> {
        favoritesSubject.eraseToAnyPublisher()
    }
    
    var favorites: Set<String> {
        favoritesSubject.value
    }
    
    var toggledShipIds: [String] = []
    
    func toggleFavorite(shipId: String) {
        toggledShipIds.append(shipId)
        var current = favoritesSubject.value
        if current.contains(shipId) {
            current.remove(shipId)
        } else {
            current.insert(shipId)
        }
        favoritesSubject.send(current)
    }
    
    func isFavorite(shipId: String) -> Bool {
        favoritesSubject.value.contains(shipId)
    }
    
    func setFavorites(_ ids: Set<String>) {
        favoritesSubject.send(ids)
    }
}
