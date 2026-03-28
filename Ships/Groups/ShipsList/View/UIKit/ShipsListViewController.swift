//
//  ShipsListViewController.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 28/03/2026.
//

import UIKit

final class ShipsListViewController: UIViewController {
    
    private let viewModel: ShipsListViewModel
    
    // MARK: - Init
    init(viewModel: ShipsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
    }
}
