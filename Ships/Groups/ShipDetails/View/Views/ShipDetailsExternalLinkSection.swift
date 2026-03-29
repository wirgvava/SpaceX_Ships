//
//  ShipDetailsExternalLinkSection.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 29/03/2026.
//

import SwiftUI

extension ShipDetailsView {
    struct ExternalLinkSection: View {
        var action: () -> Void
        
        var body: some View {
            HStack {
                Text("External Link")
                    .font(Font.title2.weight(.bold))
                Spacer()
            }
            
            Button(action: { action() }) {
                HStack {
                    Image(systemName: "link")
                    Text("View on MarineTraffic")
                    Spacer()
                    Image(systemName: "arrow.up.right")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
            }
        }
    }
}
