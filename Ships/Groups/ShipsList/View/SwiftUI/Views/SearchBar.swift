//
//  SearchBar.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 29/03/2026.
//

import SwiftUI
import ShipsUI

extension ShipsListView {
    struct SearchBar: UIViewRepresentable {
        @Binding var searchText: String
        
        func makeUIView(context: Context) -> ShipsSearchBar {
            let searchBar = ShipsSearchBar()
            searchBar.setupView(placeholder: "Search Ships")
            searchBar.onSearch = { text in
                searchText = text ?? .empty
            }
            return searchBar
        }
        
        func updateUIView(_ uiView: ShipsSearchBar, context: Context) {}
    }
}
