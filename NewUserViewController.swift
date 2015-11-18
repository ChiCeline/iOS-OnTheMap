//
//  NewUserViewController.swift
//  OnTheMap
//
//  Created by Chi Zhang on 11/15/15.
//  Copyright © 2015 cz. All rights reserved.
//

import UIKit
import MapKit

class NewUserViewController: UIViewController, AddNewUserDelegate {
    
    // custom view for add new user
    private var newUserView: NewUserView { return self.view as! NewUserView }
    
    // load custom view
    override func loadView() {
        view = NewUserView(frame: UIScreen.mainScreen().bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // assign delegate
        newUserView.delegate = self
        
        // Get known info of current user
        self.checkCurrentUserInfo()
        
    }
    
    private func checkCurrentUserInfo() {
        // try to get info for current login user from web
        NetworkClient.sharedInstance().getUserPublicData { (success, errorString) -> Void in
            
            // if failed, dismiss add new user window since cannot get full user info. back to users window
            if !success {
                dispatch_async(dispatch_get_main_queue()) {
                    NSLog("Fail to create new user locaion due to error: \(errorString)")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // set initial state of view
        self.newUserView.userEditState = .Location
    }
    
    
    // MARK: Implementations of Delegate Functions
    
    /* upload user location to web */
    func uploadNewUserLocation(locationString: String?) {
        // if location string not empty, try to convert it to coordinates and update user address info
        if let address = locationString {
            let geocoder = CLGeocoder()
            
            // get coordinates from user address string input
            geocoder.geocodeAddressString(address) { (placemarks, error) in
                
                guard (error == nil) else {
                    NSLog("Convert address: \"\(address)\" to coordinates encountered error: \(error)")
                    return
                }
                
                guard let placemarks = placemarks else {
                    NSLog("No address matched up with user input")
                    return
                }
                
                let placemark = placemarks[0]
                
                dispatch_async(dispatch_get_main_queue(), {
                    // if address can be found, update user address info
                    self.newUserView.newUserLocation = placemark.location
                    NetworkClient.sharedInstance().mapString = address
                    NetworkClient.sharedInstance().latitude = (placemark.location?.coordinate.latitude)!
                    NetworkClient.sharedInstance().longitude = (placemark.location?.coordinate.longitude)!
                    
                    // set UI for user to enter link
                    self.newUserView.userEditState = .Link
                })
            }
        } else {
            NSLog("Empty string address added.")
        }
    }
    
    /* upload user link */
    func uploadNewUserLink(linkString: String?) {
        if let mediaURL = linkString {
            NetworkClient.sharedInstance().mediaURL = mediaURL
        } else {
            NSLog("Empty user linked entered")
        }
    }
    
    /* create new user */
    func createNewUser() {
        
        let networkClient = NetworkClient.sharedInstance()
        
        // user info for post request
        let userInfo : [String : NSObject] = [
            "uniqueKey" : networkClient.userID!,
            "firstName" : networkClient.firstName,
            "lastName" : networkClient.lastName,
            "mapString" : networkClient.mapString,
            "latitude" : networkClient.latitude,
            "longitude" : networkClient.longitude,
            "mediaURL" : networkClient.mediaURL
        ]
        
        // use client method to post new user info to server
        networkClient.postStudentLocation(userInfo) { (success, errorString) in
            if success {
                // if success, dismiss current add new user window and back to users window
                dispatch_sync(dispatch_get_main_queue(), {
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            } else {
                // if not success, log error and reset new user view UI to let user add again
                NSLog("Create new user failed. \(errorString)")
                dispatch_sync(dispatch_get_main_queue(), {
                    self.newUserView.userEditState = .Location
                })
            }
        }
        
    }
    
    /* cancel adding new user */
    func cancelNewUser() {
        // dismiss current view
        dismissViewControllerAnimated(true, completion: nil)
    }

}
