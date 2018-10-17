//
//  AppDelegate.swift
//  Lovoo Interview Test
//
//  Created by Adrián Silva on 12/10/2018.
//  Copyright © 2018 Adrián Silva. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let coordinator = Coordinator(window: window!)

        let newsListViewModel = NewsListViewModel(coordinator: coordinator, client: NewsClient())
        let newsListViewController = NewsListViewController(viewModel: newsListViewModel)
        let navigationController = UINavigationController(rootViewController: newsListViewController)
        coordinator.transition(to: navigationController, type: .root)

        return true
    }

}

