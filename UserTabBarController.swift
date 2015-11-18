//
//  UserTabBarController.swift
//  OnTheMap
//
//  Created by Chi Zhang on 11/14/15.
//  Copyright © 2015 cz. All rights reserved.
//

import UIKit

// Tab bar controller of main screen. Two views to show user info: map view and table view

class UserTabBarController: UITabBarController {
    
    // tab bar item attributes
    let tabBarItemAttributes = [NSStrokeColorAttributeName : UIColor.blackColor(),
        NSFontAttributeName : UIFont(name: "Helvetica", size: 20)!,
        NSStrokeWidthAttributeName : 7.0]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* 1st Tab: Map View */
        let userMapVC = UserMapViewController()
        let mapNavigationController = UINavigationController(rootViewController: userMapVC)
        mapNavigationController.tabBarItem = UITabBarItem(title: "Map", image: nil, tag: 1)
        mapNavigationController.tabBarItem.setTitleTextAttributes(tabBarItemAttributes, forState: .Normal)
        
        /* 2nd Tab: Table View */
        let userTableVC = UserTableViewController()
        let tableNavigationConstroller = UINavigationController(rootViewController: userTableVC)
        tableNavigationConstroller.tabBarItem = UITabBarItem(title: "Table", image: nil, tag: 2)
        tableNavigationConstroller.tabBarItem.setTitleTextAttributes(tabBarItemAttributes, forState: .Normal)

        self.viewControllers = [mapNavigationController, tableNavigationConstroller]
        
    }

}
