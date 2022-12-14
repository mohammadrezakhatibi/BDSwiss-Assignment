//
//  MainCoordinator.swift
//  BDSwiss
//
//  Created by mohammadreza on 10/4/22.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController? { get set }

    func start()
}

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let api = RateAPIService()
        let cache = LocalCacheService()
        let callback = RateRepeatingServiceAdapter(api: api, cache: cache)
        let service = RateListServiceAdapter(api: api, cache: cache).callback(callback)
        let vc = ListViewController(service: service)
        vc.title = "Rates"
        navigationController?.pushViewController(vc, animated: false)
    }
}
