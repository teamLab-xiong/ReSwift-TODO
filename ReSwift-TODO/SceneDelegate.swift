//
//  SceneDelegate.swift
//  ReSwift-TODO
//
//  Created by Xiong Ju 熊炬 on 2020/4/19.
//  Copyright © 2020 Xiong Ju 熊炬. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: ShowDetailCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let window = window, let splitViewController = window.rootViewController as? UISplitViewController else { return }
        
        let coordinator = ShowDetailCoordinator(split: splitViewController)
        coordinator.start()
        
        self.coordinator = coordinator
    }
}

