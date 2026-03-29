//
//  ShipDetailsCoordinator.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 29/03/2026.
//

import UIKit
import SwiftUI
import ShipsCore
import ShipsModels

final class ShipDetailsCoordinator: Coordinator {
    let naviationController: UINavigationController
    private let item: ShipDisplayItem
    
    init(naviationController: UINavigationController, item: ShipDisplayItem) {
        self.naviationController = naviationController
        self.item = item
    }
    
    func start() {
        let detailsView = ShipDetailsAssembly.makeView(item: item)
        let hostingController = UIHostingController(rootView: detailsView)
        hostingController.hidesBottomBarWhenPushed = true
        naviationController.pushViewController(hostingController, animated: true)
    }
}
