//
//  AppDelegate.swift
//  #000
//
//  Created by Matt Condon on 4/29/16.
//  Copyright © 2016 mattc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        application.applicationSupportsShakeToEdit = true

        configureAppearance()

        window = UIWindow(frame: UIScreen.main.bounds)

        guard let window = window else { fatalError("what the fuck, apple?") }

        window.rootViewController = MainViewController()
        window.makeKeyAndVisible()


        return true
    }

    func configureAppearance() {
        UITextField.appearance().tintColor = UIColor.white
    }
}

