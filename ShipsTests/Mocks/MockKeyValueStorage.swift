//
//  MockKeyValueStorage.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 29/03/2026.
//

import Foundation
@testable import Ships

final class MockKeyValueStorage: KeyValueStorageProtocol {
    var storage: [String: Data] = [:]
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func set<T: Codable>(_ value: T, forKey key: String) {
        storage[key] = try? encoder.encode(value)
    }
    
    func get<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = storage[key] else { return nil }
        return try? decoder.decode(type, from: data)
    }
    
    func clear() {
        storage.removeAll()
    }
}
