//
//  UIViewControllerExtensoins.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 28/03/2026.
//

import UIKit

extension UIViewController {
    func showError(message: String, action: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in action?() })
        present(alert, animated: true, completion: nil)
    }
}
