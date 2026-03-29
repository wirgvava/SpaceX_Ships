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
            AsyncImage(url: URL(string: image ?? .empty)) { phase in
                switch phase {
                case .success(let image):
                    StretchableImage(image: image)
                    
                case .empty, .failure:
                    Rectangle()
                        .fill(Color(UIColor.lightGray))
                        .frame(height: Constants.placeholderHeight)
                        .frame(maxWidth: .infinity)
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
        }
        
        enum Constants {
            static let placeholderPhotoHeight: CGFloat = 100
            static let placeholderHeight: CGFloat = 300
        }
    }
    
    private struct StretchableImage: View {
        let image: Image
        
        var body: some View {
            image
                .resizable()
                .scaledToFit()
                .overlay {
                    GeometryReader { geometry in
                        let minY = geometry.frame(in: .global).minY
                        let isStretching = minY > .zero
                        let height = geometry.size.height + (isStretching ? minY : .zero)
                        
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: height)
                            .clipped()
                            .offset(y: isStretching ? -minY : .zero)
                    }
                }
        }
    }
}

