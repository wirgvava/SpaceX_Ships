//
//  MainCoordinator.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 28/03/2026.
//

import UIKit
import ShipsCore

final class MainCoordinator: Coordinator {
   
    let naviationController: UINavigationController
    
    private let window: UIWindow
    private var tabBarController: MainTabBarController?
    
    // MARK: - Init
    init(window: UIWindow) {
        self.window = window
        self.naviationController = UINavigationController()
    }
    
    // MARK: - Start
    func start() {
        let uiKitCoordinator = UIKitShipsListCoordinator()
        let swiftUICoordinator = SwiftUIShipsListCoordinator()
        
        uiKitCoordinator.start()
        swiftUICoordinator.start()
        
        let viewControllers = [
            uiKitCoordinator.naviationController,
            swiftUICoordinator.naviationController
        ]
        
        tabBarController = MainTabBarController(viewControllers: viewControllers)
        window.rootViewController = tabBarController
    }
}
