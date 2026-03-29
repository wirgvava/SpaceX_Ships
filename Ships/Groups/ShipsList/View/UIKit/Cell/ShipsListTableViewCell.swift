//
//  ShipsListTableViewCell.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 28/03/2026.
//

import UIKit
import SwiftUI
import ShipsModels
import ShipsUI

final class ShipsListTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "ShipsListTableViewCell"
    
    // MARK: - UI Components
    private let shipImageView: AsyncUIImageView = {
        let imageView = AsyncUIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = Constants.imageCornerRadius
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.nameFontSize, weight: .semibold)
        label.numberOfLines = .zero
        label.textColor = .black
        label.backgroundColor = .white
        label.clipsToBounds = true
        label.layer.cornerRadius = Constants.labelCornerRadius
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.typeFontSize, weight: .regular)
        label.textColor = .black
        label.backgroundColor = .white
        label.clipsToBounds = true
        label.layer.cornerRadius = Constants.labelCornerRadius
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.statusFontSize, weight: .medium)
        label.textColor = .black
        label.clipsToBounds = true
        label.layer.cornerRadius = Constants.labelCornerRadius
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: Constants.favoriteButtonSize, weight: .regular)
        button.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// StackView should contain ship `name` and `type`
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = Constants.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    /// StackView should contain `textStackView` and ship `active status`
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    // MARK: - Properties
    var onFavoriteToggle: (() -> Void)?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shipImageView.cancel()
        onFavoriteToggle = nil
    }
    
    // MARK: - Setup
    private func setupUI() {
        selectionStyle = .none
        contentView.backgroundColor = .clear
        
        setupShipImageView()
        setupInfoStackView()
        setupFavoriteButton()
    }
    
    private func setupShipImageView() {
        contentView.addSubview(shipImageView)
        
        NSLayoutConstraint.activate([
            shipImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cellPadding),
            shipImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.cellPadding),
            shipImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.cellPadding),
            shipImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.cellPadding)
        ])
    }
    
    private func setupInfoStackView() {
        shipImageView.addSubview(infoStackView)
        
        /// Add views on `textStackView`
        textStackView.addArrangedSubview(nameLabel)
        textStackView.addArrangedSubview(typeLabel)
        
        /// Add views on `infoStackView`
        infoStackView.addArrangedSubview(textStackView)
        infoStackView.addArrangedSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            infoStackView.leadingAnchor.constraint(equalTo: shipImageView.leadingAnchor, constant: Constants.contentPadding),
            infoStackView.trailingAnchor.constraint(equalTo: shipImageView.trailingAnchor, constant: -Constants.contentPadding),
            infoStackView.bottomAnchor.constraint(equalTo: shipImageView.bottomAnchor, constant: -Constants.contentPadding)
        ])
    }
    
    private func setupFavoriteButton() {
        shipImageView.addSubview(favoriteButton)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            favoriteButton.trailingAnchor.constraint(equalTo: shipImageView.trailingAnchor, constant: -Constants.contentPadding),
            favoriteButton.topAnchor.constraint(equalTo: shipImageView.topAnchor, constant: Constants.contentPadding)
        ])
    }
    
    @objc private func favoriteButtonTapped() {
        onFavoriteToggle?()
    }
}

// MARK: - Configure
extension ShipsListTableViewCell {
    func configure(with item: ShipDisplayItem) {
        nameLabel.text = item.ship.name.withHorizontalPadding()
        typeLabel.text = item.ship.type.withHorizontalPadding()
        
        let statusLabelText = item.ship.isActive ? "Active" : "Inactive"
        statusLabel.text = statusLabelText.withHorizontalPadding()
        statusLabel.backgroundColor = item.ship.isActive ? .green : .red
        
        favoriteButton.setImage(UIImage(systemName: item.isFavorite ? "heart.fill" : "heart"), for: .normal)
        favoriteButton.tintColor = item.isFavorite ? .red : .white
        
        shipImageView.load(from: item.ship.image)
    }
}
// MARK: - Constants
private extension ShipsListTableViewCell {
    enum Constants {
        static let imageCornerRadius: CGFloat = 8
        static let labelCornerRadius: CGFloat = 6
        static let nameFontSize: CGFloat = 18
        static let typeFontSize: CGFloat = 16
        static let statusFontSize: CGFloat = 14
        static let favoriteButtonSize: CGFloat = 22
        static let stackViewSpacing: CGFloat = 4
        static let cellPadding: CGFloat = 10
        static let contentPadding: CGFloat = 16
    }
}
