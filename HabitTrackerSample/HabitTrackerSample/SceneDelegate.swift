//
//  SceneDelegate.swift
//  HabitTrackerSample
//
//  Created by Islom Babaev on 29/07/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }

}

