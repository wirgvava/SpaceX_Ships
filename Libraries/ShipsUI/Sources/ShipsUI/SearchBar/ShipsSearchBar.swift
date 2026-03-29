//
//  ShipsSearchBar.swift
//  ShipsUI
//
//  Created by Konstantine Tsirgvava on 29/03/2026.
//

import UIKit

public final class ShipsSearchBar: UIView {
    
    private let textField = UITextField()
    private let searchImageView = UIImageView()
    
    public var onSearch: ((String?) -> Void)?
    
    // MARK: - Setup
    public func setupView(placeholder: String) {
        configureView()
        configureSearchImage()
        configureTextField(placeholder: placeholder)
    }
    
    // Self
    private func configureView(){
        backgroundColor = .clear
        layer.borderWidth = Constants.borderWidth
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = Constants.cornerRadius
    }
    
    // Search image
    private func configureSearchImage(){
        searchImageView.image = UIImage(systemName: "magnifyingglass")
        searchImageView.tintColor = .black
        searchImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(searchImageView)
        
        NSLayoutConstraint.activate([
            searchImageView.widthAnchor.constraint(equalToConstant: Constants.searchImageWidth),
            searchImageView.heightAnchor.constraint(equalToConstant: Constants.searchImageHeight),
            searchImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.searchImageLeadingConstants),
            searchImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // TextField
    private func configureTextField(placeholder: String){
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: Constants.fontSize),
            .foregroundColor: UIColor.black.withAlphaComponent(Constants.placeHolderTextAlpha)
        ]

        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
        textField.font = UIFont.systemFont(ofSize: Constants.fontSize)
        textField.textColor = UIColor.black
        textField.returnKeyType = .search
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: searchImageView.trailingAnchor, constant: Constants.textFieldLeadingConstants),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.textFieldTrailingConstants)
        ])
    }
    
    @objc private func textFieldDidChange() {
        onSearch?(textField.text)
    }
}

extension ShipsSearchBar: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

private extension ShipsSearchBar {
    enum Constants {
        static let fontSize: CGFloat = 16
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 8
        static let placeHolderTextAlpha: CGFloat = 0.3
        static let textFieldLeadingConstants: CGFloat = 20
        static let textFieldTrailingConstants: CGFloat = -20
        static let searchImageWidth: CGFloat = 30
        static let searchImageHeight: CGFloat = 30.79
        static let searchImageLeadingConstants: CGFloat = 20
    }
}
