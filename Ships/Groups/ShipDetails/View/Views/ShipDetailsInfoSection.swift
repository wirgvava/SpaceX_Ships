//
//  ShipDetailsInfoSection.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 29/03/2026.
//

import SwiftUI
import ShipsModels

extension ShipDetailsView {
    struct InfoSection: View {
        let ship: Ship
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(ship.name)
                    .font(Font.largeTitle.weight(.bold))
                    .foregroundStyle(.black)
                    .padding(.bottom)
                
                infoLine(key: "Type: ", value: ship.type)
                infoLine(key: "Port: ", value: ship.homePort)
                infoLine(key: "Year of built: ", value: ship.displayYear)
                infoLine(key: "Weight: ", value: ship.displayWeightKg)
            }
        }
        
        private func infoLine(key: String, value: String) -> some View {
            HStack {
                Text(key)
                    .font(Font.body.weight(.bold))
                Spacer()
                Text(value)
            }
            .foregroundStyle(.gray)
        }
    }
}
