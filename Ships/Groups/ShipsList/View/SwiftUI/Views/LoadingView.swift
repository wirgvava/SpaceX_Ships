//
//  LoadingView.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 29/03/2026.
//

import SwiftUI

extension ShipsListView {
    struct LoadingView: View {
        var body: some View {
            VStack {
                Spacer()
                ProgressView("Loading ships...")
                Spacer()
            }
        }
    }
}
