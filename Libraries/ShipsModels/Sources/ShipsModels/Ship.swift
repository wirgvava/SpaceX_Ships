//
//  Ship.swift
//  ShipsModels
//
//  Created by Konstantine Tsirgvava on 28/03/2026.
//

import Foundation

public struct Ship: Decodable, Sendable, Hashable, Identifiable, Equatable {
    public let id: String
    public let name: String
    public let type: String
    public let isActive: Bool
    public let image: String?
    public let homePort: String
    public let yearBuilt: Int
    public let weightLbs: Int
    public let weightKg: Int
    public let missions: [Mission]
    public let url: String
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id = "ship_id"
        case name = "ship_name"
        case type = "ship_type"
        case isActive = "active"
        case image
        case homePort = "home_port"
        case yearBuilt = "year_built"
        case weightLbs = "weight_lbs"
        case weightKg = "weight_kg"
        case missions
        case url
    }
    
    public init(id: String, name: String, type: String, isActive: Bool, image: String, homePort: String, yearBuilt: Int, weightLbs: Int, weightKg: Int, missions: [Mission], url: String) {
        self.id = id
        self.name = name
        self.type = type
        self.isActive = isActive
        self.image = image
        self.homePort = homePort
        self.yearBuilt = yearBuilt
        self.weightLbs = weightLbs
        self.weightKg = weightKg
        self.missions = missions
        self.url = url
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        self.isActive = try container.decodeIfPresent(Bool.self, forKey: .isActive) ?? false
        self.image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        self.homePort = try container.decodeIfPresent(String.self, forKey: .homePort) ?? ""
        self.yearBuilt = try container.decodeIfPresent(Int.self, forKey: .yearBuilt) ?? 0
        self.weightLbs = try container.decodeIfPresent(Int.self, forKey: .weightLbs) ?? 0
        self.weightKg = try container.decodeIfPresent(Int.self, forKey: .weightKg) ?? 0
        self.missions = try container.decodeIfPresent([Mission].self, forKey: .missions) ?? []
        self.url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
    }
    
    public var displayYear: String {
        return String(yearBuilt)
    }
    
    public var displayWeightKg: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return "\(formatter.string(from: NSNumber(value: weightKg)) ?? String(weightKg)) kg"
    }
}

extension Ship {
    public static func apiQueryParametersFilter() -> String {
        CodingKeys.allCases
            .map(\.rawValue)
            .joined(separator: ",")
    }
}

// MARK: - Ship Display Item
public struct ShipDisplayItem: Sendable, Hashable, Identifiable {
    public let ship: Ship
    public let isFavorite: Bool
    
    public var id: String { ship.id }
    
    public init(ship: Ship, isFavorite: Bool) {
        self.ship = ship
        self.isFavorite = isFavorite
    }
}
