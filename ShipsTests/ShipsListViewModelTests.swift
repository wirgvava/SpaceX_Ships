//
//  ShipsListViewModelTests.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 29/03/2026.
//

import Testing
import Foundation
import ShipsModels
@testable import Ships

@Suite("ShipsListViewModel Tests")
struct ShipsListViewModelTests {
    
    @Test("Initially has empty state")
    @MainActor
    func initialState() {
        let networkService = TestMockNetworkService()
        let favoritesStorage = MockFavoritesStorage()
        let viewModel = ShipsListViewModel(
            networkService: networkService,
            favoritesStorage: favoritesStorage
        )
        
        #expect(viewModel.filteredShips.isEmpty)
        #expect(!viewModel.isLoading)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.searchText.isEmpty)
        #expect(viewModel.hasMorePages)
        #expect(viewModel.currentOffset == 0)
    }
    
    @Test("Fetches ships successfully")
    @MainActor
    func fetchShipsSuccess() async {
        let networkService = TestMockNetworkService()
        networkService.shipsToReturn = TestDataFactory.makeShips(count: 5)
        let favoritesStorage = MockFavoritesStorage()
        let viewModel = ShipsListViewModel(
            networkService: networkService,
            favoritesStorage: favoritesStorage
        )
        
        await viewModel.fetchShips(offset: 0)
        
        #expect(viewModel.filteredShips.count == 5)
        #expect(networkService.fetchCallCount == 1)
        #expect(networkService.lastRequestedOffset == 0)
    }
    
    @Test("Handles network error")
    @MainActor
    func fetchShipsError() async {
        let networkService = TestMockNetworkService()
        networkService.errorToThrow = NSError(domain: "Test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        let favoritesStorage = MockFavoritesStorage()
        let viewModel = ShipsListViewModel(
            networkService: networkService,
            favoritesStorage: favoritesStorage
        )
        
        await viewModel.fetchShips(offset: 0)
        
        #expect(viewModel.filteredShips.isEmpty)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.errorMessage == "Network error")
    }
    
    @Test("Clears error message")
    @MainActor
    func clearError() async {
        let networkService = TestMockNetworkService()
        networkService.errorToThrow = NSError(domain: "Test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error"])
        let favoritesStorage = MockFavoritesStorage()
        let viewModel = ShipsListViewModel(
            networkService: networkService,
            favoritesStorage: favoritesStorage
        )
        
        await viewModel.fetchShips(offset: 0)
        #expect(viewModel.errorMessage != nil)
        
        viewModel.clearError()
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test("Updates hasMorePages based on response size")
    @MainActor
    func hasMorePagesLogic() async {
        let networkService = TestMockNetworkService()
        let favoritesStorage = MockFavoritesStorage()
        let viewModel = ShipsListViewModel(
            networkService: networkService,
            favoritesStorage: favoritesStorage
        )
        
        // Less than page size (10) means no more pages
        networkService.shipsToReturn = TestDataFactory.makeShips(count: 5)
        await viewModel.fetchShips(offset: 0)
        
        #expect(!viewModel.hasMorePages)
    }
    
    @Test("Has more pages when full page returned")
    @MainActor
    func hasMorePagesWhenFullPage() async {
        let networkService = TestMockNetworkService()
        let favoritesStorage = MockFavoritesStorage()
        let viewModel = ShipsListViewModel(
            networkService: networkService,
            favoritesStorage: favoritesStorage
        )
        
        // Exactly page size (10) means might have more
        networkService.shipsToReturn = TestDataFactory.makeShips(count: 10)
        await viewModel.fetchShips(offset: 0)
        
        #expect(viewModel.hasMorePages)
    }
    
    @Test("Load next page increments offset")
    @MainActor
    func loadNextPageIncrementsOffset() async {
        let networkService = TestMockNetworkService()
        networkService.shipsToReturn = TestDataFactory.makeShips(count: 10)
        let favoritesStorage = MockFavoritesStorage()
        let viewModel = ShipsListViewModel(
            networkService: networkService,
            favoritesStorage: favoritesStorage
        )
        
        await viewModel.fetchShips(offset: 0)
        #expect(viewModel.currentOffset == 0)
        
        await viewModel.loadNextPage()
        #expect(viewModel.currentOffset == 10)
        #expect(networkService.lastRequestedOffset == 10)
    }
    
    @Test("Does not load next page when no more pages")
    @MainActor
    func doesNotLoadWhenNoMorePages() async {
        let networkService = TestMockNetworkService()
        networkService.shipsToReturn = TestDataFactory.makeShips(count: 5) // Less than page size
        let favoritesStorage = MockFavoritesStorage()
        let viewModel = ShipsListViewModel(
            networkService: networkService,
            favoritesStorage: favoritesStorage
        )
        
        await viewModel.fetchShips(offset: 0)
        let callCountAfterFirstFetch = networkService.fetchCallCount
        
        await viewModel.loadNextPage()
        #expect(networkService.fetchCallCount == callCountAfterFirstFetch)
    }
    
    @Test("Toggle favorite delegates to storage")
    @MainActor
    func toggleFavoriteDelegates() async {
        let networkService = TestMockNetworkService()
        networkService.shipsToReturn = TestDataFactory.makeShips(count: 2)
        let favoritesStorage = MockFavoritesStorage()
        let viewModel = ShipsListViewModel(
            networkService: networkService,
            favoritesStorage: favoritesStorage
        )
        
        await viewModel.fetchShips(offset: 0)
        viewModel.toggleFavorite(for: "SHIP0")
        
        #expect(favoritesStorage.toggledShipIds.contains("SHIP0"))
    }
    
    @Test("Ships display with favorite status")
    @MainActor
    func shipsDisplayFavoriteStatus() async throws {
        let networkService = TestMockNetworkService()
        networkService.shipsToReturn = TestDataFactory.makeShips(count: 3)
        let favoritesStorage = MockFavoritesStorage()
        favoritesStorage.setFavorites(["SHIP1"])
        let viewModel = ShipsListViewModel(
            networkService: networkService,
            favoritesStorage: favoritesStorage
        )
        
        await viewModel.fetchShips(offset: 0)
        
        // Allow time for Combine bindings
        try await Task.sleep(nanoseconds: 100_000_000)
        
        let ship0 = viewModel.filteredShips.first { $0.id == "SHIP0" }
        let ship1 = viewModel.filteredShips.first { $0.id == "SHIP1" }
        
        #expect(ship0?.isFavorite == false)
        #expect(ship1?.isFavorite == true)
    }
    
    @Test("Resets ships when fetching from offset 0")
    @MainActor
    func resetsShipsOnOffsetZero() async {
        let networkService = TestMockNetworkService()
        let favoritesStorage = MockFavoritesStorage()
        let viewModel = ShipsListViewModel(
            networkService: networkService,
            favoritesStorage: favoritesStorage
        )
        
        // First fetch
        networkService.shipsToReturn = TestDataFactory.makeShips(count: 10)
        await viewModel.fetchShips(offset: 0)
        #expect(viewModel.filteredShips.count == 10)
        
        // Fetch from offset 0 again (refresh)
        networkService.shipsToReturn = TestDataFactory.makeShips(count: 5)
        await viewModel.fetchShips(offset: 0)
        #expect(viewModel.filteredShips.count == 5)
    }
    
    @Test("Appends ships when fetching next page")
    @MainActor
    func appendsShipsOnNextPage() async {
        let networkService = TestMockNetworkService()
        let favoritesStorage = MockFavoritesStorage()
        let viewModel = ShipsListViewModel(
            networkService: networkService,
            favoritesStorage: favoritesStorage
        )
        
        // First fetch
        networkService.shipsToReturn = TestDataFactory.makeShips(count: 10)
        await viewModel.fetchShips(offset: 0)
        #expect(viewModel.filteredShips.count == 10)
        
        // Fetch next page
        networkService.shipsToReturn = (10..<15).map { index in
            TestDataFactory.makeShip(id: "SHIP\(index)", name: "Ship \(index)")
        }
        await viewModel.loadNextPage()
        #expect(viewModel.filteredShips.count == 15)
    }
}
