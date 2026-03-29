//
//  ShipsListEmptyStateView.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 29/03/2026.
//

import SwiftUI

extension ShipsListView {
    struct EmptyStateView: View {
        var body: some View {
            VStack {
               Spacer()
                
                Text("No ships found")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
        }
    }
}
