//
//  Mission.swift
//  ShipsModels
//
//  Created by Konstantine Tsirgvava on 28/03/2026.
//

import Foundation

public struct Mission: Decodable, Sendable, Hashable, Identifiable {
    public let id = UUID()
    
    public let name: String
    public let flight: Int
    
    enum CodingKeys: String, CodingKey {
        case name, flight
    }
    
    public init(name: String, flight: Int) {
        self.name = name
        self.flight = flight
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.flight = try container.decodeIfPresent(Int.self, forKey: .flight) ?? 0
    }
}
