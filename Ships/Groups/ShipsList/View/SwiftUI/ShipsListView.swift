//
//  ShipsListView.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 28/03/2026.
//

import SwiftUI

struct ShipsListView: View {
    
    @StateObject private var viewModel: ShipsListViewModel
    
    init(viewModel: ShipsListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Color.red.ignoresSafeArea()
            .task {
                await viewModel.fetchShips(offset: 0)
            }
    }
}
