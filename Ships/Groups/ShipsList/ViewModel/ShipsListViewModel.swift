//
//  ShipsListViewModel.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 28/03/2026.
//

import Foundation
import Combine

final class ShipsListViewModel: ObservableObject {
    
    // MARK: - Dependencies
    private let networkService: ShipsNetworkServiceProtocol
    
    // MARK: - Init
    init(networkService: ShipsNetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchShips(offset: Int) async {
        do {
            let ships = try await networkService.fetchShips(offset: offset)
            print("SHIPS: \(ships)")
        } catch {
            print(error.localizedDescription)
        }
    }
}
