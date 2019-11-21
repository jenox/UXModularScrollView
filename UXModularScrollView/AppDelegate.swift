//
//  AppDelegate.swift
//  Modular
//
//  Created by Christian Schnorr on 28.09.18.
//  Copyright © 2018 Christian Schnorr. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow()

        let vc = ViewController()

        self.window!.rootViewController = vc

        self.window?.makeKeyAndVisible()

        return true
    }
}

//class StackView: UIStackView {
//    override func willRemoveSubview(_ subview: UIView) {
//        print("not calling super")
//    }
//}
