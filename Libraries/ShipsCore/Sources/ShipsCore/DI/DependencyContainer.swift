//
//  DependencyContainer.swift
//  ShipsCore
//
//  Created by Konstantine Tsirgvava on 27/03/2026.
//

import Foundation

public enum DependencyScope {
    case transient
    case singleton
}

public protocol Resolver {
    func resolve<T>(_ type: T.Type) -> T
}

public final class DependencyContainer: @unchecked Sendable, Resolver {
    
    public static let shared = DependencyContainer()
    
    // Storage
    private var factories: [ObjectIdentifier: Any] = [:]
    private var singletons: [ObjectIdentifier: Any] = [:]
    private var singletonKeys: Set<ObjectIdentifier> = []
    
    private let lock = NSRecursiveLock()
    
    // Init
    public init() {}
    
    // Registration
    public func register<T>(_ type: T.Type, scope: DependencyScope = .transient, factory: @escaping (any Resolver) -> T) {
        let key = ObjectIdentifier(type)
        lock.lock()
        defer { lock.unlock() }
        
        factories[key] = factory
        if scope == .singleton {
            singletonKeys.insert(key)
        }
    }
    
    public func register<T, Arg>(_ type: T.Type, factory: @escaping (any Resolver, Arg) -> T) {
        let key = ObjectIdentifier(type)
        lock.lock()
        defer { lock.unlock() }
        
        factories[key] = factory
    }
    
    // Resolution
    public func resolve<T>(_ type: T.Type) -> T {
        let key = ObjectIdentifier(type)
        lock.lock()
        defer { lock.unlock() }
        
        /// Chek existing singleton at first
        if singletonKeys.contains(key),
           let existing = singletons[key] as? T {
            return existing
        }
        
        /// Get factory
        guard let factory = factories[key] as? (any Resolver) -> T else {
            fatalError("No registration found for type: \(type)")
        }
        
        /// Create instance
        let instance = factory(self)
        
        /// Store singleton if needed
        if singletonKeys.contains(key) {
            singletons[key] = instance
        }
        
        return instance
    }
    
    public func resolve<T, Arg>(_ type: T.Type, argument: Arg) -> T {
        let key = ObjectIdentifier(type)
        lock.lock()
        defer { lock.unlock() }
        
        guard let factory = factories[key] as? (any Resolver, Arg) -> T else {
            fatalError("No registration found for type: \(type) with argument")
        }
        
        return factory(self, argument)
    }
    
    // Convinece Resolution
    public func resolve<T>() -> T {
        resolve(T.self)
    }
}
