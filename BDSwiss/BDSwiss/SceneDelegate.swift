//
//  SceneDelegate.swift
//  BDSwiss
//
//  Created by mohammadreza on 10/4/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: Coordinator?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let navigationVC = UINavigationController()
        
        coordinator = MainCoordinator(navigationController: navigationVC)
        coordinator?.start()
        
        window = .init(windowScene: scene)
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
    }

}

