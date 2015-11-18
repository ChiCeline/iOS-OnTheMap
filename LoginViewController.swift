//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Chi Zhang on 11/14/15.
//  Copyright © 2015 cz. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController, LoginDelegate {
    
    // customized view for user login
    private var loginView: LoginView { return self.view as! LoginView }
    
    override func loadView() {
        self.view = LoginView(frame: UIScreen.mainScreen().bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginView.delegate = self
    }
    
    
    // MARK: LoginDelegate functions
    
    func userLoginWithUsernamePassword(username: String, password: String) {

        NetworkClient.sharedInstance().loginWithUsernamePassword(username, password: password) {(success, error) in
            if success {
                self.completeLogin()
            } else {
                NSLog("Login with username / password failed with error: \(error)")
            }
        }
    }
    
    // This function for user login with facebook authorization is not finished yet.
    func userLoginWithAuthorization() {
//        self.completeLogin()
    }
    
    /* Helper function for login complete */
    private func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            let userTabBarController = UserTabBarController()
            self.presentViewController(userTabBarController, animated: false, completion: nil)
        })
    }

}
