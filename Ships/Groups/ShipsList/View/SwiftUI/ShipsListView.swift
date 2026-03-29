//
//  ShipsListView.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 28/03/2026.
//

import SwiftUI
import ShipsUI
import ShipsModels

struct ShipsListView: View {
    
    @StateObject private var viewModel: ShipsListViewModel
    
    init(viewModel: ShipsListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: .zero) {
            SearchBar(searchText: $viewModel.searchText)
                .frame(height: Constants.searchBarHeight)
            
            ZStack {
                if viewModel.isLoading && viewModel.filteredShips.isEmpty {
                    LoadingView()
                } else if viewModel.filteredShips.isEmpty {
                    EmptyStateView()
                } else {
                    shipsList
                }
            }
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .refreshable {
            await viewModel.fetchShips(offset: .zero)
        }
        .task {
            if viewModel.filteredShips.isEmpty {
                await viewModel.fetchShips(offset: .zero)
            }
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.errorMessage ?? .empty)
        }
    }
    
    // MARK: - Ships List
    private var shipsList: some View {
        List {
            ForEach(viewModel.filteredShips) { item in
                ShipRowView(
                    item: item,
                    onFavoriteToggle: {
                        viewModel.toggleFavorite(for: item.ship)
                    }
                )
                .onTapGesture {
                    viewModel.selectShip(item)
                }
                .onAppear {
                    if item == viewModel.filteredShips.last {
                        Task {
                            await viewModel.loadNextPage()
                        }
                    }
                }
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(
                top: Constants.cellPadding,
                leading: .zero,
                bottom: Constants.cellPadding,
                trailing: .zero
            ))
        }
        .listStyle(.plain)
        .padding(.top, Constants.listTopPadding)
    }
}

// MARK: - Constants
private extension ShipsListView {
    enum Constants {
        static let horizontalPadding: CGFloat = 10
        static let searchBarHeight: CGFloat = 50
        static let cellPadding: CGFloat = 10
        static let listTopPadding: CGFloat = 10
    }
}

#Preview {
    ShipsListView(viewModel: .init(networkService: MockShipsNetworkService()))
}
