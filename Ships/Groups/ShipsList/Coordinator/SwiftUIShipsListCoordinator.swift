//
//  SwiftUIShipsListCoordinator.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 28/03/2026.
//

import UIKit
import SwiftUI
import ShipsCore
import Combine

final class SwiftUIShipsListCoordinator: Coordinator {
    let naviationController: UINavigationController
    private var cancellables = Set<AnyCancellable>()
    
    init(naviationController: UINavigationController = UINavigationController()) {
        self.naviationController = naviationController
    }
    
    func start() {
        let viewModel = ShipsListAssembly.resolve()
        let shipsListView = ShipsListView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: shipsListView)
        
        viewModel.navigationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] destination in
                self?.navigate(to: destination)
            }
            .store(in: &cancellables)
        
        naviationController.setViewControllers([hostingController], animated: false)
        naviationController.tabBarItem =  UITabBarItem(
            title: "SwiftUI",
            image: UIImage(systemName: "swift"),
            tag: 1
        )
    }
    
    private func navigate(to destination: ShipsListDestination) {
        switch destination {
        case .shipDetails(let item):
            let coordinator = ShipDetailsCoordinator(
                naviationController: naviationController,
                item: item
            )
            coordinator.start()
        }
    }
}
