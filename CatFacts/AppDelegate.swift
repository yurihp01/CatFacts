//
//  AppDelegate.swift
//  CatFacts
//
//  Created by Kerem Gunduz on 30/03/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator = AppCoordinator()
        self.window?.rootViewController = appCoordinator.navigationController
        self.window?.makeKeyAndVisible()
        appCoordinator.start()
        return true
    }
}
