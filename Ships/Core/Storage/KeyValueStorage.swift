//
//  KeyValueStorage.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 29/03/2026.
//

import Foundation

protocol KeyValueStorageProtocol {
    func set<T: Codable>(_ value: T, forKey key: String)
    func get<T: Codable>(_ type: T.Type, forKey key: String) -> T?
}

final class UserDefaultsStorage: KeyValueStorageProtocol {
    
    private let userDefaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func set<T>(_ value: T, forKey key: String) where T : Decodable, T : Encodable {
        if let data = try? encoder.encode(value) {
            userDefaults.set(data, forKey: key)
        }
    }
    
    func get<T>(_ type: T.Type, forKey key: String) -> T? where T : Decodable, T : Encodable {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        return try? decoder.decode(type, from: data)
    }
}
