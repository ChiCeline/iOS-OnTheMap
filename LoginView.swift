//
//  LoginView.swift
//  OnTheMap
//
//  Created by Chi Zhang on 11/14/15.
//  Copyright © 2015 cz. All rights reserved.
//

import UIKit


// Delegate for log in view (use class delegate enable weak reference)

protocol LoginDelegate: class {
    
    func userLoginWithUsernamePassword(username: String, password: String)
    
    func userLoginWithAuthorization() // Authorization through Facebook not completed yet
}


// Log in view

class LoginView: UIView, UITextFieldDelegate {

    var usernameTextField = UITextField()
    var passwordTextField = UITextField()
    var loginButton = UIButton()
    var authorizationButton = UIButton()
    
    weak var delegate: LoginDelegate?
    
    // Text field attributes
    let loginTextFieldAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
    ]
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUpAppearance()
        self.setUpUsernameTextField()
        self.setUpPasswordTextField()
        self.setUpLoginButton()
        self.setUpAuthorizationButton()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func loginButtonTouchUp(sender: UIButton) {
        self.dismissAnyVisibleKeyboards()
        
        if let delegate = self.delegate {
            delegate.userLoginWithUsernamePassword(usernameTextField.text!, password: passwordTextField.text!)
        } else {
            NSLog("Login button cannot find delelgate")
        }
    }
    
    func authorizationButtonTouchUp(sender: UIButton) {
        self.dismissAnyVisibleKeyboards()
        
        if let delegate = self.delegate {
            delegate.userLoginWithAuthorization()
        } else {
            NSLog("Authorization button cannot find delelgate")
        }
    }
    
    
    // UI Setup Functions
    private func setUpAppearance() {
        self.backgroundColor = UIColor.grayColor()
    }
    
    private func setUpUsernameTextField() {
        usernameTextField.delegate = self
        usernameTextField.defaultTextAttributes = loginTextFieldAttributes
        usernameTextField.placeholder = "Username"
        usernameTextField.autocorrectionType = .No
        usernameTextField.autocapitalizationType = .None
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(usernameTextField)

        let usernameTFWidthConstraint = usernameTextField.widthAnchor.constraintEqualToAnchor(self.widthAnchor, constant: -80)
        let usernameTFHorizontalConstraint = usernameTextField.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor)
        let usernameTFVerticalConstraint = usernameTextField.bottomAnchor.constraintEqualToAnchor(self.centerYAnchor, constant: -40)
        NSLayoutConstraint.activateConstraints([usernameTFWidthConstraint, usernameTFHorizontalConstraint, usernameTFVerticalConstraint])
    }
    
    private func setUpPasswordTextField() {
        passwordTextField.delegate = self
        passwordTextField.defaultTextAttributes = loginTextFieldAttributes
        passwordTextField.placeholder = "Password"
        passwordTextField.autocorrectionType = .No
        passwordTextField.autocapitalizationType = .None
        passwordTextField.secureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(passwordTextField)

        let passwordTFWidthConstraint = passwordTextField.widthAnchor.constraintEqualToAnchor(self.widthAnchor, constant: -80)
        let passwordTFHorizontalConstraint = passwordTextField.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor)
        let passwordTFVerticalConstraint = passwordTextField.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor)
        NSLayoutConstraint.activateConstraints([passwordTFWidthConstraint, passwordTFHorizontalConstraint, passwordTFVerticalConstraint])
    }
    
    private func setUpLoginButton() {
        loginButton.backgroundColor = UIColor.blueColor()
        loginButton.setTitle("Login", forState: .Normal)
        loginButton.addTarget(self, action: "loginButtonTouchUp:", forControlEvents: .TouchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(loginButton)
        
        let loginButtonWidthConstraint = loginButton.widthAnchor.constraintEqualToAnchor(self.widthAnchor, constant: -120)
        let loginButtonHorizontalConstraint = loginButton.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor)
        let loginButtonVerticalConstraint = loginButton.topAnchor.constraintEqualToAnchor(self.centerYAnchor, constant: 40)
        NSLayoutConstraint.activateConstraints([loginButtonWidthConstraint, loginButtonHorizontalConstraint, loginButtonVerticalConstraint])
    }
    
    private func setUpAuthorizationButton() {
        authorizationButton.backgroundColor = UIColor.blueColor()
        authorizationButton.setTitle("Login with Facebook", forState: .Normal)
        authorizationButton.addTarget(self, action: "authorizationButtonTouchUp:", forControlEvents: .TouchUpInside)
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(authorizationButton)
        
        let authorizationButtonWidthConstraint = authorizationButton.widthAnchor.constraintEqualToAnchor(self.widthAnchor, constant: -80)
        let authorizationButtonHorizontalConstraint = authorizationButton.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor)
        let authorizationButtonVerticalConstraint = authorizationButton.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -80)
        NSLayoutConstraint.activateConstraints([authorizationButtonWidthConstraint, authorizationButtonHorizontalConstraint, authorizationButtonVerticalConstraint])
    }
    
    
    // Text field delegate methods
    func textFieldDidBeginEditing(textField: UITextField) {
        if let text = textField.placeholder{
            textField.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName: UIColor.clearColor()])
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let text = textField.placeholder{
            textField.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func dismissAnyVisibleKeyboards() {
        if usernameTextField.isFirstResponder() || passwordTextField.isFirstResponder() {
            self.endEditing(true)
        }
    }
    
}
