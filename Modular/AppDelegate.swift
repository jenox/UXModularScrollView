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

        let vc = ViewController()
        let wrapper = UXSocketViewController(contentViewController: vc)

//        // works only for text, not for readableContentGuide (only blocks updates for readable, but initial is user pref)
//        let traits = UITraitCollection(preferredContentSizeCategory: .extraSmall)
//        wrapper.setOverrideTraitCollection(traits, forChild: vc)

        self.window!.rootViewController = wrapper

//        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//
//        })

        return true
    }
}
