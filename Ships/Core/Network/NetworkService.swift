//
//  NetworkService.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 28/03/2026.
//

import ShipsNetworking
import ShipsModels

protocol ShipsNetworkServiceProtocol: Sendable {
    func fetchShips(offset: Int) async throws -> [Ship]
}

final class ShipsNetworkService: @unchecked Sendable, ShipsNetworkServiceProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: - Methods
    func fetchShips(offset: Int) async throws -> [Ship] {
        try await networkService.execute(
            endpoint: APIEndpoint.ships(
                filter: Ship.apiQueryParametersFilter(),
                limit: 10,
                offset: offset
            )
        )
    }
}
