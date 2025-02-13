//
//  FactsListCoordinator.swift
//  CatFacts
//
//  Created by Yuri on 10/02/25.
//

import UIKit

class FactsListCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = FactsListViewModel(service: CatFactsService())
        let controller = FactsListViewController()
        controller.coordinator = self
        controller.viewModel = viewModel
        navigationController.pushViewController(controller, animated: true)
    }
}
