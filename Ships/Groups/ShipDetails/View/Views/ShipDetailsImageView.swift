//
//  ShipDetailsImageView.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 29/03/2026.
//

import SwiftUI
import ShipsModels

extension ShipDetailsView {
    struct ShipImageView: View {
        let image: String?
        
        var body: some View {
            GeometryReader { geometry in
                AsyncImage(url: URL(string: image ?? .empty)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                        
                    case .empty, .failure:
                        Rectangle()
                            .fill(Color(UIColor.lightGray))
                            .overlay {
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: Constants.placeholderPhotoHeight)
                                    .foregroundColor(Color(UIColor.gray))
                            }
                        
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: geometry.size.width)
                .clipped()
            }
            .frame(height: Constants.imageHeight)
        }
        
        enum Constants {
            static let placeholderPhotoHeight: CGFloat = 100
            static let imageHeight: CGFloat = 300
        }
    }
}
