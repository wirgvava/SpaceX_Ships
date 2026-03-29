//
//  ShipDetailsMissions.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 29/03/2026.
//

import SwiftUI
import ShipsModels

extension ShipDetailsView {
    struct MissionsSection: View {
        let missions: [Mission]
        
        var body: some View {
            Section(header: header) {
                ForEach(missions) { mission in
                    self.mission(name: mission.name, flight: mission.flight)
                }
            }
        }
        
        private var header: some View {
            HStack {
                Text("Missions")
                    .font(Font.title2.weight(.bold))
                    .padding(.bottom)
                Spacer()
            }
        }
        
        private func mission(name: String, flight: Int) -> some View {
            HStack {
                Text("NAME: ").fontWeight(.bold) + Text(name)
                Spacer()
                Text("FLIGHT: ").fontWeight(.bold) + Text(String(flight))
            }
            .foregroundStyle(.gray)
        }
    }
}

