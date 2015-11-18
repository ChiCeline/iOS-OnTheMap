//
//  NewUserView.swift
//  OnTheMap
//
//  Created by Chi Zhang on 11/16/15.
//  Copyright © 2015 cz. All rights reserved.
//

import UIKit
import MapKit

// Protocol for add new user view
protocol AddNewUserDelegate: class {
    func uploadNewUserLocation(locationString: String?)
    func uploadNewUserLink(linkString: String?)
    func createNewUser()
    func cancelNewUser()
}


class NewUserView: UIView, UITextFieldDelegate {

    private lazy var topBar = UIToolbar()
    private lazy var infoLabel = UILabel()
    private lazy var addressTextField = UITextField()
    private lazy var linkTextField = UITextField()
    private lazy var addLocationButton = UIButton()
    private lazy var submitButton = UIButton()
    private lazy var mapView = MKMapView()
    
    weak var delegate: AddNewUserDelegate?
    
    var newUserLocation: CLLocation?
    
    // Enum of UI states of NewUserView
    enum UserEditState {
        case Location    // user is editing location
        case Link    // user is editing link
    }
    
    // variable of user editing state, set to trigger UI update
    var userEditState: UserEditState = UserEditState.Location {
        didSet {
            self.updateUI()
        }
    }
    
    // View initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // set up UIs
        self.setUpMapView()
        self.setUpTopBar()
        self.setUpInfoLabel()
        self.setUpAddressTextField()
        self.setUpLinkTextField()
        self.setUpAddLocationButton()
        self.setUpSubmitButton()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: Set Up UI Components
    
    private func setUpTopBar() {
        topBar.backgroundColor = UIColor.grayColor()
        
        topBar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(topBar)
        
        let topBarWidthConstraint = topBar.widthAnchor.constraintEqualToAnchor(self.widthAnchor)
        let topBarHeightConstraint = topBar.heightAnchor.constraintEqualToConstant(50)
        let topBarVerticalConstraint = topBar.topAnchor.constraintEqualToAnchor(self.topAnchor)
        NSLayoutConstraint.activateConstraints([topBarWidthConstraint, topBarHeightConstraint, topBarVerticalConstraint])
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Done, target: self, action: "cancelButtonTouchUp:")
        let flexibleSpaceLeft = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let flexibleSpaceMid = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        topBar.items = [flexibleSpaceLeft, flexibleSpaceMid, cancelButton]
    }
    
    /* action when cancel button touch up */
    func cancelButtonTouchUp(sender: AnyObject) {
        self.delegate?.cancelNewUser()
    }
    
    
    private func setUpInfoLabel() {
        infoLabel.backgroundColor = UIColor.grayColor()
        infoLabel.text = "Where do you STUDY? \n Please enter you location!"
        
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(infoLabel)
        
        let infoLabelWidthConstraint = infoLabel.widthAnchor.constraintEqualToAnchor(self.widthAnchor)
        let infoLabelHeightConstraint = infoLabel.heightAnchor.constraintEqualToConstant((self.frame.height - 50) / 3)
        let infoLabelVerticalConstraint = infoLabel.topAnchor.constraintEqualToAnchor(topBar.bottomAnchor)
        NSLayoutConstraint.activateConstraints([infoLabelWidthConstraint, infoLabelHeightConstraint, infoLabelVerticalConstraint])

    }
    
    private func setUpAddressTextField() {
        addressTextField.delegate = self
        
        addressTextField.backgroundColor = UIColor.greenColor()
        
        addressTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addressTextField)
        
        let addressTextFieldWidthConstraint = addressTextField.widthAnchor.constraintEqualToAnchor(self.widthAnchor)
        let addressTextFieldHeightConstraint = addressTextField.heightAnchor.constraintEqualToConstant((self.frame.height - 50) / 3)
        let addressTextFieldVerticalConstraint = addressTextField.topAnchor.constraintEqualToAnchor(infoLabel.bottomAnchor)
        NSLayoutConstraint.activateConstraints([addressTextFieldWidthConstraint, addressTextFieldHeightConstraint, addressTextFieldVerticalConstraint])
        
    }
    
    private func setUpLinkTextField() {
        linkTextField.delegate = self
        
        linkTextField.backgroundColor = UIColor.greenColor()
        
        linkTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(linkTextField)
        
        let linkTextFieldWidthConstraint = linkTextField.widthAnchor.constraintEqualToAnchor(self.widthAnchor)
        let linkTextFieldHeightConstraint = linkTextField.heightAnchor.constraintEqualToConstant((self.frame.height - 50) / 3)
        let linkTextFieldVerticalConstraint = linkTextField.topAnchor.constraintEqualToAnchor(topBar.bottomAnchor)
        NSLayoutConstraint.activateConstraints([linkTextFieldWidthConstraint, linkTextFieldHeightConstraint, linkTextFieldVerticalConstraint])
        
    }
    
    private func setUpAddLocationButton() {
        addLocationButton = UIButton(type: UIButtonType.System)
        
        addLocationButton.setTitle("Search Location", forState: .Normal)
        addLocationButton.backgroundColor = UIColor.blueColor()
        
        addLocationButton.bounds = CGRect(x: 0, y: 0, width: 240, height: 60)
        addLocationButton.center = CGPoint(x: self.frame.width / 2, y: self.frame.height - 100)
        
        addLocationButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        addLocationButton.setTitleColor(.whiteColor(), forState: .Normal)
        
        addLocationButton.addTarget(self, action: "addLocationButtonTouchUp:", forControlEvents: .TouchUpInside)
        
        self.addSubview(addLocationButton)
        
    }
    
    func addLocationButtonTouchUp(sender: AnyObject) {
        print("add location button touch up")
        self.delegate?.uploadNewUserLocation(self.addressTextField.text)
    }
    
    private func setUpSubmitButton() {
        submitButton = UIButton(type: UIButtonType.System)
        
        submitButton.setTitle("Submit", forState: .Normal)
        submitButton.backgroundColor = UIColor.blueColor()
        
        submitButton.bounds = CGRect(x: 0, y: 0, width: 200, height: 60)
        submitButton.center = CGPoint(x: self.frame.width / 2, y: self.frame.height - 100)
        
        submitButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        submitButton.setTitleColor(.whiteColor(), forState: .Normal)
        
        submitButton.addTarget(self, action: "submitButtonTouchUp:", forControlEvents: .TouchUpInside)
        
        self.addSubview(submitButton)
    }
    
    func submitButtonTouchUp(sender: AnyObject) {
        self.delegate?.uploadNewUserLink(linkTextField.text)
        self.delegate?.createNewUser()
    }
    
    private func setUpMapView() {
        mapView.frame = CGRect(x: 0, y: 50 + (self.frame.height - 50) / 3, width: self.frame.width, height: (self.frame.height - 50) * 2 / 3 )
        
        self.addSubview(mapView)
    }
    
    
    /* Upgrade View Function */
    
    private func updateUI() {
        
        switch userEditState {
        case .Location:
            infoLabel.hidden = false
            addressTextField.hidden = false
            linkTextField.hidden = true
            addLocationButton.hidden = true    // always hidden unless is editting location TF not empty (see delegate func below)
            submitButton.hidden = true    // always hidden unless is editting link and TF not empty (see delegate func below)
            mapView.hidden = true
        case .Link:
            infoLabel.hidden = true
            addressTextField.hidden = true
            linkTextField.hidden = false
            addLocationButton.hidden = true
            submitButton.hidden = true
            mapView.hidden = false
            
            // add user location to map view under this state
            self.addNewUserAnnotation()
        }
    }
    
    /* Helper function: Add User Annotation to Map */
    private func addNewUserAnnotation() {
        mapView.removeAnnotations(mapView.annotations)
        
        if let location = newUserLocation {
            let coordinate = location.coordinate
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            let span: MKCoordinateSpan = MKCoordinateSpanMake(0.3 , 0.3)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
            
            mapView.addAnnotation(annotation)
            mapView.centerCoordinate = coordinate
            mapView.region = region
        }
    }
    
    
    // Textfield delegate function: When editting text field and text field not empty, enable corresponding buttons
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let oldStr = textField.text! as NSString
        let newStr = oldStr.stringByReplacingCharactersInRange(range, withString: string) as NSString
        
        if textField == addressTextField {
            if newStr.length == 0 {
                addLocationButton.hidden = true
            } else {
                addLocationButton.hidden = false
            }
        } else {
            if newStr.length == 0 {
                submitButton.hidden = true
            } else {
                submitButton.hidden = false
            }
        }
        
        return true
    }

}
