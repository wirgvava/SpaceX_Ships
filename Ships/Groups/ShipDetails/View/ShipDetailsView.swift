//
//  ShipDetailsView.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 29/03/2026.
//

import SwiftUI
import ShipsModels

struct ShipDetailsView: View {
    
    @StateObject private var viewModel: ShipDetailsViewModel
    
    init(item: ShipDisplayItem) {
        _viewModel = .init(wrappedValue: ShipDetailsAssembly.resolve(item: item))
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            ShipImageView(image: viewModel.item.ship.image)
            
            VStack {
                InfoSection(ship: viewModel.item.ship)
                
                divider
                
                MissionsSection(missions: viewModel.item.ship.missions)
                
                divider
                
                ExternalLinkSection {
                    viewModel.openLink()
                }
            }
            .padding(.horizontal)
        }
        .ignoresSafeArea()
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                toolBarButton
            }
        })
    }
    
    private var toolBarButton: some View {
        Button(action: { viewModel.toggleFavorite() }) {
            Image(systemName: viewModel.item.isFavorite ? "heart.fill" : "heart")
                .foregroundColor(viewModel.item.isFavorite ? .red : .gray)
        }
    }
    
    private var divider: some View {
        Divider()
            .padding(.vertical)
    }
}


#Preview {
    ShipDetailsView(
        item: .init(
            ship: Ship(
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
            ),
            isFavorite: false
        )
    )
}
