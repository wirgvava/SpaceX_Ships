//
//  SwiftUIShipsListCoordinator.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 28/03/2026.
//

import UIKit
import SwiftUI
import ShipsCore

final class SwiftUIShipsListCoordinator: Coordinator {
    let naviationController: UINavigationController
    
    init(naviationController: UINavigationController = UINavigationController()) {
        self.naviationController = naviationController
    }
    
    func start() {
        let viewModel = ShipsListAssembly.resolve()
        let shipsListView = ShipsListView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: shipsListView)
        
        naviationController.setViewControllers([hostingController], animated: false)
        naviationController.tabBarItem =  UITabBarItem(
            title: "SwiftUI",
            image: UIImage(systemName: "swift"),
            tag: 1
        )
    }
}
