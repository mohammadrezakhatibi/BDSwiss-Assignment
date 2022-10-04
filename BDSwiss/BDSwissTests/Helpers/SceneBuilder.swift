//
//  SceneBuilder.swift
//  BDSwissTests
//
//  Created by mohammadreza on 10/4/22.
//

import UIKit
@testable import BDSwiss

struct SceneBuilder {
    
    func build() -> UINavigationController {
        
        let nav = UINavigationController()
        let coordinator = MainCoordinator(navigationController: nav)
        coordinator.start()
        
        return nav
    }
}
