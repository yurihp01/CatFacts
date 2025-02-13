//
//  Coordinator.swift
//  CatFacts
//
//  Created by Yuri on 10/02/25.
//

import UIKit

// MARK: - Protocol
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var parentCoordinator: Coordinator? { get set }
    
    func start()
    func stop()
    func add(_ coordinator: Coordinator)
    func remove(_ coordinator: Coordinator)
    func back()
    func childDidFinish(_ child: Coordinator?)
}

// MARK: - Protocol Default Impl
extension Coordinator {
    func add(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func remove(_ coordinator: Coordinator) {
        childCoordinators.removeAll(where: { $0 === coordinator })
    }
    
    func childDidFinish(_ child: Coordinator?) {
        guard let child = child else { return }
        remove(child)
    }
    
    func back() {}
    
    func stop() {}
}
