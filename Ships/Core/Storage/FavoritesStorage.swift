//
//  FavoritesStorage.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 29/03/2026.
//

import Foundation
import Combine

protocol FavoritesStorageProtocol: AnyObject {
    var favoritesPublisher: AnyPublisher<Set<String>, Never> { get }
    var favorites: Set<String> { get }
    
    func toggleFavorite(shipId: String)
    func isFavorite(shipId: String) -> Bool
}

final class FavoritesStorage: FavoritesStorageProtocol {
    
    private enum Keys {
        static let favorites = "favorite_ships"
    }
    
    // MARK: - Properties
    private let storage: KeyValueStorageProtocol
    private let favoritesSubject: CurrentValueSubject<Set<String>, Never>
    
    var favoritesPublisher: AnyPublisher<Set<String>, Never> {
        favoritesSubject.eraseToAnyPublisher()
    }
    
    var favorites: Set<String> {
        favoritesSubject.value
    }
    
    // MARK: - Init
    init(storage: KeyValueStorageProtocol = UserDefaultsStorage()) {
        self.storage = storage
        
        let savedFavorites: [String] = storage.get([String].self, forKey: Keys.favorites) ?? []
        self.favoritesSubject = CurrentValueSubject(Set(savedFavorites))
    }
    
    // MARK: - Methods
    func toggleFavorite(shipId: String) {
        if isFavorite(shipId: shipId) {
            removeFavorite(shipId: shipId)
        } else {
            addFavorite(shipId: shipId)
        }
    }
    
    func isFavorite(shipId: String) -> Bool {
        favoritesSubject.value.contains(shipId)
    }
    
    private func addFavorite(shipId: String) {
        var current = favoritesSubject.value
        current.insert(shipId)
        save(favorites: current)
    }
    
    private func removeFavorite(shipId: String) {
        var current = favoritesSubject.value
        current.remove(shipId)
        save(favorites: current)
    }
    
    private func save(favorites: Set<String>) {
        storage.set(Array(favorites), forKey: Keys.favorites)
        favoritesSubject.send(favorites)
    }
}
