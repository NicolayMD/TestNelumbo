//
//  SceneDelegate.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 8/08/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let ws = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: ws)

        let listVM = ReportsListViewModel()
        let listVC = ReportsListViewController(viewModel: listVM)
        let nav = UINavigationController(rootViewController: listVC)

        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window
    }
}
