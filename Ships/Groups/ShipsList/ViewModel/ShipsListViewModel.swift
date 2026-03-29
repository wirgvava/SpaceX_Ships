//
//  ShipsListViewModel.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 28/03/2026.
//

import Foundation
import Combine
import ShipsModels

final class ShipsListViewModel: ObservableObject {
    
    @Published private var ships: [ShipDisplayItem] = []
    @Published private(set) var filteredShips: [ShipDisplayItem] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    @Published var searchText: String = .empty
    
    // MARK: - Navigation (for UIKit)
    let navigationPublisher = PassthroughSubject<ShipsListDestination, Never>()
    
    // MARK: - Dependencies
    private let networkService: ShipsNetworkServiceProtocol
    
    // MARK: - Properties
    private var allShips: [Ship] = []
    private var cancellables = Set<AnyCancellable>()
    private(set) var currentOffset: Int = .zero
    private(set) var hasMorePages: Bool = true
    private let pageSize: Int = 10
    
    // MARK: - Init
    init(networkService: ShipsNetworkServiceProtocol) {
        self.networkService = networkService
        self.setupBindings()
    }
    
    // MARK: - Methods
    private func setupBindings() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.filterShips()
            }
            .store(in: &cancellables)
    }
    
    func fetchShips(offset: Int) async {
        guard !isLoading else { return }
        
        isLoading = true
        
        do {
            let newShips = try await networkService.fetchShips(offset: offset)
            offset == .zero ? allShips = newShips : allShips.append(contentsOf: newShips)
            
            currentOffset = offset
            hasMorePages = newShips.count >= pageSize
            updateDisplayItems()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func loadNextPage() async {
        guard hasMorePages, !isLoading else { return }
        await fetchShips(offset: currentOffset + pageSize)
    }
    
    func toggleFavorite(for ship: Ship) {
        // TODO: -
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    func selectShip(_ ship: ShipDisplayItem) {
        navigationPublisher.send(.shipDetails(ship))
    }
    
    private func updateDisplayItems() {
        ships = allShips.map { ship in
            ShipDisplayItem(ship: ship, isFavorite: false) // TODO: - do something with isFavorite later.
        }
        filterShips()
    }
    
    private func filterShips() {
        let query = searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if query.isEmpty {
            filteredShips = ships
        } else {
            filteredShips = ships.filter { item in
                let nameMatch = item.ship.name.lowercased().contains(query)
                let typeMatch = item.ship.type.lowercased().contains(query)
                return nameMatch || typeMatch
            }
        }
    }
}
