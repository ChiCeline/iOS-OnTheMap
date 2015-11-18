//
//  UserMapViewController.swift
//  OnTheMap
//
//  Created by Chi Zhang on 11/14/15.
//  Copyright © 2015 cz. All rights reserved.
//

import UIKit
import MapKit

class UserMapViewController: UIViewController, MKMapViewDelegate {
    
    var mapView: MKMapView!
    
    var students: [Student] = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up UIs
        setUpNavigationBar()
        setUpMapView()
        
        // Assign delegate for mapView
        self.mapView.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadUserData()
    }
    
    
    // MARK: Helper functions to set up UI
    
    private func setUpNavigationBar() {
        
        let navigationBar = navigationController!.navigationBar
        navigationBar.tintColor = UIColor.blueColor()
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logoutButtonTouchUp:")
        let addPinButton = UIBarButtonItem(title: "Add Pin", style: UIBarButtonItemStyle.Plain, target: self, action: "addPinButtonTouchUp:")
        let refreshButton = UIBarButtonItem(title: "Refresh", style: UIBarButtonItemStyle.Plain, target: self, action: "refreshButtonTouchUp:")
        
        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.rightBarButtonItems = [addPinButton, refreshButton]
        
    }
    
    private func setUpMapView() {
        self.mapView = MKMapView()
        self.mapView.mapType = MKMapType.Standard
        
        let navBarHeight = navigationController!.navigationBar.frame.height
        let tabBarHeight = tabBarController!.tabBar.frame.height
        self.mapView.frame = CGRectMake(0, navBarHeight, view.frame.width, (view.frame.height - navBarHeight - tabBarHeight))
        
        self.view.addSubview(self.mapView)
    }
    
    
    // MARK: Actions of Buttons Touch Up
    
    /* add pin button touch up */
    func addPinButtonTouchUp(sender: AnyObject) {
        let newUserVC = NewUserViewController()
        self.presentViewController(newUserVC, animated: true, completion: nil)
    }
    
    /* refresh button touch up */
    func refreshButtonTouchUp(sender: AnyObject) {
        self.reloadUserData()
    }
    
    /* logout button touch up */
    func logoutButtonTouchUp(sender: AnyObject) {
        NetworkClient.sharedInstance().logOutOfUdacitySession { success, error in
            if success {
                dispatch_async(dispatch_get_main_queue()){
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            } else {
                NSLog(error!)
            }
        }
    }
    
    
    /* Helper function to reload data */
    private func reloadUserData() {
        
        NetworkClient.sharedInstance().getAllStudents{ success, students, error in
            if success {
                self.students = students!
                dispatch_async(dispatch_get_main_queue()) {
                    NetworkClient.sharedInstance().createAnnotations(self.students, mapView: self.mapView)
                }
            } else {
                NSLog(error!)
            }
        }
    }
    
    
    // MARK: Implement Map View Delegate Functions
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "studentPin"
        
        if annotation is MKPointAnnotation {

            let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            
            if let pinView = dequeuedView {
            
                pinView.annotation = annotation
                return pinView

            } else {
                
                let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                pinView.canShowCallout = true
                pinView.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
                
                return pinView
            }
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation {
            NetworkClient.sharedInstance().openURL(annotation.subtitle!!)
        } // else do nothing
    }
    
}
