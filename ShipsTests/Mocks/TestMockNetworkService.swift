//
//  TestMockNetworkService.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 29/03/2026.
//

import Foundation
import ShipsModels
@testable import Ships

final class TestMockNetworkService: ShipsNetworkServiceProtocol, @unchecked Sendable {
    var shipsToReturn: [Ship] = []
    var errorToThrow: Error?
    var fetchCallCount = 0
    var lastRequestedOffset: Int?
    
    func fetchShips(offset: Int) async throws -> [Ship] {
        fetchCallCount += 1
        lastRequestedOffset = offset
        
        if let error = errorToThrow {
            throw error
        }
        return shipsToReturn
    }
}
