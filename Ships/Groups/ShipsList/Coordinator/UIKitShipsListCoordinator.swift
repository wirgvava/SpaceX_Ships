//
//  UIKitShipsListCoordinator.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 28/03/2026.
//

import UIKit
import Combine
import ShipsCore

final class UIKitShipsListCoordinator: Coordinator {
    let naviationController: UINavigationController
    private var cancellables: Set<AnyCancellable> = []
    
    init(naviationController: UINavigationController = UINavigationController()) {
        self.naviationController = naviationController
    }
    
    func start() {
        let viewModel = ShipsListAssembly.resolve()
        let viewController = ShipsListViewController(viewModel: viewModel)
        
        viewModel.navigationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] destination in
                self?.navigate(to: destination)
            }
            .store(in: &cancellables)
        
        naviationController.setViewControllers([viewController], animated: false)
        naviationController.tabBarItem = UITabBarItem(
            title: "UIKit",
            image: UIImage(systemName: "square.3.stack.3d.top.fill"),
            tag: .zero
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
