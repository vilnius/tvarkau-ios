//
//  AppDelegate.swift
//  tvarkau
//
//  Created by Eimantas Vaiciunas on 08/10/2016.
//  Copyright © 2016 Code For Vilnius. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    override static func initialize() {
        guard let path = Bundle.main.path(forResource: "Defaults", ofType: "plist") else { return }

        let dict = NSDictionary(contentsOfFile: path) as! [String: AnyObject]

        let defaults = UserDefaults.standard

        defaults.register(defaults: dict)
    }

}
