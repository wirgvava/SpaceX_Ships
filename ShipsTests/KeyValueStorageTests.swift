//
//  KeyValueStorageTests.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 29/03/2026.
//

import Testing

@Suite("KeyValueStorage Tests")
struct KeyValueStorageTests {
    
    @Test("MockKeyValueStorage stores and retrieves values")
    @MainActor
    func mockStorageWorks() {
        let storage = MockKeyValueStorage()
        
        storage.set(["item1", "item2"], forKey: "testKey")
        let retrieved: [String]? = storage.get([String].self, forKey: "testKey")
        
        #expect(retrieved != nil)
        #expect(retrieved?.count == 2)
        #expect(retrieved?.contains("item1") == true)
    }
    
    @Test("MockKeyValueStorage returns nil for missing key")
    @MainActor
    func mockStorageReturnsNilForMissingKey() {
        let storage = MockKeyValueStorage()
        
        let retrieved: [String]? = storage.get([String].self, forKey: "nonexistent")
        
        #expect(retrieved == nil)
    }
    
    @Test("MockKeyValueStorage clear removes all data")
    @MainActor
    func mockStorageClear() {
        let storage = MockKeyValueStorage()
        storage.set("value", forKey: "key1")
        storage.set(123, forKey: "key2")
        
        storage.clear()
        
        #expect(storage.get(String.self, forKey: "key1") == nil)
        #expect(storage.get(Int.self, forKey: "key2") == nil)
    }
}
