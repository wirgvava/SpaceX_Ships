//
//  ShipRowView.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 29/03/2026.
//

import SwiftUI
import ShipsModels

extension ShipsListView {
    struct ShipRowView: View {
        let item: ShipDisplayItem
        let onFavoriteToggle: () -> Void
        
        var body: some View {
            ZStack(alignment: .topTrailing) {
                // Background Image
                AsyncImage(url: URL(string: item.ship.image ?? .empty)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                        
                    case .empty, .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFill()
                            .padding(Constants.imagePadding)
                            .foregroundColor(Color(UIColor.gray))
                            .background(Color(UIColor.lightGray))
                        
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: Constants.rowHeight)
                .clipped()
                .cornerRadius(Constants.cornerRadius)
                
                // Favorite Button
                Button(action: onFavoriteToggle) {
                    Image(systemName: item.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: Constants.favoriteButtonSize))
                        .foregroundColor(item.isFavorite ? .red : .white)
                        .padding(Constants.contentPadding)
                }
                
                // Info Overlay
                VStack {
                    Spacer()
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: Constants.labelSpacing) {
                            Text(item.ship.name)
                                .font(.system(size: Constants.nameFontSize, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(.horizontal, Constants.labelPadding)
                                .background(.white)
                                .cornerRadius(Constants.labelCornerRadius)
                            
                            Text(item.ship.type)
                                .font(.system(size: Constants.typeFontSize))
                                .foregroundColor(.black)
                                .padding(.horizontal, Constants.labelPadding)
                                .background(.white)
                                .cornerRadius(Constants.labelCornerRadius)
                        }
                        
                        Spacer()
                        
                        Text(item.ship.isActive ? "Active" : "Inactive")
                            .font(.system(size: Constants.statusFontSize, weight: .medium))
                            .foregroundColor(.black)
                            .padding(.horizontal, Constants.labelPadding)
                            .background(item.ship.isActive ? Color.green : Color.red)
                            .cornerRadius(Constants.labelCornerRadius)
                    }
                    .padding(Constants.contentPadding)
                }
            }
            .frame(height: Constants.rowHeight)
        }
        
        enum Constants {
            static let rowHeight: CGFloat = 130
            static let imagePadding: CGFloat = 32
            static let cornerRadius: CGFloat = 8
            static let contentPadding: CGFloat = 16
            static let labelSpacing: CGFloat = 4
            static let labelPadding: CGFloat = 8
            static let labelCornerRadius: CGFloat = 6
            static let nameFontSize: CGFloat = 18
            static let typeFontSize: CGFloat = 16
            static let statusFontSize: CGFloat = 14
            static let favoriteButtonSize: CGFloat = 22
        }
    }
}
