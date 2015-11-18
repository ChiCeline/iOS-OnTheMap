//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by Chi Zhang on 11/14/15.
//  Copyright © 2015 cz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let loginViewController = LoginViewController()
        
        window!.rootViewController = loginViewController
        window!.makeKeyAndVisible()
        
        return true
    }
    
}

