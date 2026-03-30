//
//  TestDataFactory.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 29/03/2026.
//

import Foundation
import ShipsModels

enum TestDataFactory {
    static func makeShip(
        id: String = "TESTSHIP",
        name: String = "Test Ship",
        type: String = "Cargo",
        isActive: Bool = true
    ) -> Ship {
        Ship(
            id: id,
            name: name,
            type: type,
            isActive: isActive,
            image: "https://example.com/image.jpg",
            homePort: "Test Port",
            yearBuilt: 2020,
            weightLbs: 100000,
            weightKg: 45359,
            missions: [],
            url: "https://example.com"
        )
    }
    
    static func makeShips(count: Int) -> [Ship] {
        (0..<count).map { index in
            makeShip(
                id: "SHIP\(index)",
                name: "Ship \(index)",
                type: index.isMultiple(of: 2) ? "Cargo" : "Tug"
            )
        }
    }
}
