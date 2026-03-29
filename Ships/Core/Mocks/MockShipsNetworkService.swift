//
//  MockShipsNetworkService.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 29/03/2026.
//

import ShipsModels

final class MockShipsNetworkService: ShipsNetworkServiceProtocol {
    func fetchShips(offset: Int) async throws -> [Ship] {
        [
            Ship(
                id: "AMERICANCHAMPION",
                name: "American Champion",
                type: "Tug",
                isActive: false,
                image: "https://i.imgur.com/woCxpkj.jpg",
                homePort: "Port of Los Angeles",
                yearBuilt: 1976,
                weightLbs: 588000,
                weightKg: 266712,
                missions: [
                    Mission(name: "COTS 1", flight: 7),
                    Mission(name: "COTS 2", flight: 8)
                ],
                url: "https://www.marinetraffic.com/en/ais/details/ships/shipid:434663/vessel:AMERICAN%20CHAMPION"
            )
        ]
    }
}
