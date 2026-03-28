//
//  UIKitShipsListCoordinator.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 28/03/2026.
//

import UIKit
import ShipsCore

final class UIKitShipsListCoordinator: Coordinator {
    let naviationController: UINavigationController
    
    init(naviationController: UINavigationController = UINavigationController()) {
        self.naviationController = naviationController
    }
    
    func start() {
        let viewModel = ShipsListAssembly.resolve()
        let viewController = ShipsListViewController(viewModel: viewModel)
        
        naviationController.setViewControllers([viewController], animated: false)
        naviationController.tabBarItem = UITabBarItem(
            title: "UIKit",
            image: UIImage(systemName: "square.3.stack.3d.top.fill"),
            tag: .zero
        )
    }
}
