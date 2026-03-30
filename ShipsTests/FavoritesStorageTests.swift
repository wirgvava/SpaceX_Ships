//
//  FavoritesStorageTests.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 29/03/2026.
//

import Testing
import Combine
@testable import Ships

@Suite("FavoritesStorage Tests")
struct FavoritesStorageTests {
    
    @Test("Initially has no favorites")
    @MainActor
    func initiallyEmpty() {
        let storage = MockKeyValueStorage()
        let favoritesStorage = FavoritesStorage(storage: storage)
        
        #expect(favoritesStorage.favorites.isEmpty)
    }
    
    @Test("Loads existing favorites from storage")
    @MainActor
    func loadsExistingFavorites() {
        let storage = MockKeyValueStorage()
        storage.set(["SHIP1", "SHIP2"], forKey: "favorite_ships")
        
        let favoritesStorage = FavoritesStorage(storage: storage)
        
        #expect(favoritesStorage.favorites.count == 2)
        #expect(favoritesStorage.favorites.contains("SHIP1"))
        #expect(favoritesStorage.favorites.contains("SHIP2"))
    }
    
    @Test("Toggle adds ship to favorites")
    @MainActor
    func toggleAddsFavorite() {
        let storage = MockKeyValueStorage()
        let favoritesStorage = FavoritesStorage(storage: storage)
        
        favoritesStorage.toggleFavorite(shipId: "SHIP1")
        
        #expect(favoritesStorage.isFavorite(shipId: "SHIP1"))
        #expect(favoritesStorage.favorites.count == 1)
    }
    
    @Test("Toggle removes ship from favorites")
    @MainActor
    func toggleRemovesFavorite() {
        let storage = MockKeyValueStorage()
        storage.set(["SHIP1"], forKey: "favorite_ships")
        let favoritesStorage = FavoritesStorage(storage: storage)
        
        favoritesStorage.toggleFavorite(shipId: "SHIP1")
        
        #expect(!favoritesStorage.isFavorite(shipId: "SHIP1"))
        #expect(favoritesStorage.favorites.isEmpty)
    }
    
    @Test("isFavorite returns correct value")
    @MainActor
    func isFavoriteReturnsCorrectValue() {
        let storage = MockKeyValueStorage()
        storage.set(["SHIP1"], forKey: "favorite_ships")
        let favoritesStorage = FavoritesStorage(storage: storage)
        
        #expect(favoritesStorage.isFavorite(shipId: "SHIP1"))
        #expect(!favoritesStorage.isFavorite(shipId: "SHIP2"))
    }
    
    @Test("Favorites are persisted to storage")
    @MainActor
    func favoritesPersisted() {
        let storage = MockKeyValueStorage()
        let favoritesStorage = FavoritesStorage(storage: storage)
        
        favoritesStorage.toggleFavorite(shipId: "SHIP1")
        favoritesStorage.toggleFavorite(shipId: "SHIP2")
        
        let saved: [String]? = storage.get([String].self, forKey: "favorite_ships")
        #expect(saved != nil)
        #expect(saved?.count == 2)
    }
    
    @Test("Publisher emits updates when favorites change")
    @MainActor
    func publisherEmitsUpdates() async {
        let storage = MockKeyValueStorage()
        let favoritesStorage = FavoritesStorage(storage: storage)
        var receivedValues: [Set<String>] = []
        var cancellables = Set<AnyCancellable>()
        
        favoritesStorage.favoritesPublisher
            .sink { receivedValues.append($0) }
            .store(in: &cancellables)
        
        favoritesStorage.toggleFavorite(shipId: "SHIP1")
        favoritesStorage.toggleFavorite(shipId: "SHIP2")
        
        // Initial empty + 2 toggles = 3 values
        #expect(receivedValues.count == 3)
        #expect(receivedValues[0].isEmpty)
        #expect(receivedValues[1].contains("SHIP1"))
        #expect(receivedValues[2].contains("SHIP1"))
        #expect(receivedValues[2].contains("SHIP2"))
    }
}
