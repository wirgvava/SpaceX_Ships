//
//  Coordinator.swift
//  ShipsCore
//
//  Created by Konstantine Tsirgvava on 28/03/2026.
//

import UIKit

public protocol Coordinator: AnyObject {
    var naviationController: UINavigationController { get }
    func start()
}
