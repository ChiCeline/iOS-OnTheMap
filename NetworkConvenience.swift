//
//  NetworkConvenience.swift
//  OnTheMap
//
//  Created by Chi Zhang on 11/15/15.
//  Copyright © 2015 cz. All rights reserved.
//

import Foundation
import UIKit
import MapKit

// Convience methds for more specific tasks needed in the project

extension NetworkClient {
    
    // Login Udacity with username and password
    func loginWithUsernamePassword(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        let method = Methods.CreateSession
        let parameters = ["":""]
        let jsonBody = [JSONBodyKeys.Udacity : [
            JSONBodyKeys.Username : username,
            JSONBodyKeys.Password : password]]
        
        let _ = taskForPOSTMethod(Server.Udacity, method: method, parameters: parameters, jsonBody: jsonBody) { (JSONResult, error) in
            
            if let error = error {
                NSLog("Login with error: \(error)")
                completionHandler(success: false, errorString: "Login with error: \(error)")
            } else {
                // if request succeed, save session id and user id
                if let sessionID = JSONResult["session"]!!.objectForKey("id"), userID = JSONResult["account"]!!.objectForKey("key") {
                    self.sessionID = sessionID as? String
                    self.userID = userID as? String
                    completionHandler(success: true, errorString: nil)
                } else {
                    completionHandler(success: false, errorString: "Login with error \(error).")
                }
            }
        }
    }
    
    // Get user locations with limit 50 (pass fetched data with completionHandler)
    func getAllStudents(completionHandler: (success: Bool, students: [Student]?, errorString: String?) -> Void) {
        
        let _ = taskForGETMethod(Server.Parse, method: Methods.GetStudentLocations, parameters: ["limit" : 50]) { (JSONResult, error) in
            
            if let error = error {
                print(error)
                completionHandler(success: false, students: nil, errorString: "Get student locations failed (error when returning JSON).")
            } else {
                if let results = JSONResult["results"] {
                    let students = Student.convertFromDictionaries(results as! [[String: AnyObject]])
                    completionHandler(success: true, students: students, errorString: nil)
                } else {
                    completionHandler(success: false, students: nil, errorString: "Get student locations failed (cannot extract \"results\" from returned JSON).")
                }
            }
        }
    }
    
    
    // Get current login user public infomation
    func getUserPublicData(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        guard let userID = NetworkClient.sharedInstance().userID else {
            NSLog("userID not set correctly!")
            completionHandler(success: false, errorString: "No valid user ID from login step.")
            return
        }
        
        let method = NetworkClient.subtituteKeyInMethod(Methods.GetUserData, key: "user_id", value: userID)
        
        let _ = taskForGETMethod(Server.Udacity, method: method!, parameters: [:]) { (JSONResult, error) in
            
            if let error = error {
                print(error)
                completionHandler(success: false, errorString: "Fail at get user info with error: \(error)")
            } else {
                if let user = JSONResult["user"] {
                    // if succeed, save user name info
                    self.firstName = (user as! [String: AnyObject])["first_name"]! as! String
                    self.lastName = (user as! [String: AnyObject])["first_name"]! as! String
                    completionHandler(success: true, errorString: nil)
                } else {
                    completionHandler(success: false, errorString: "No valid user data returned when get user public info.")
                }
            }
        }
    }
    
    
    // Post Student Location
    func postStudentLocation(dictionary: [String : AnyObject], completionHander: (success: Bool, errorString: String?) -> Void) {
        let jsonBody = dictionary
        let _ = taskForPOSTMethod(Server.Parse, method: Methods.PostStudentLocation, parameters: [:], jsonBody: jsonBody) { (JSONResult, error) in
            if let error = error {
                NSLog("Post Student Location Failed with error: \(error)")
                completionHander(success: false, errorString: "Post Student Location Failed with error: \(error)")
            } else {
                if let objectId = JSONResult["objectId"] {
                    // if post is success, save object id
                    self.objectId = objectId as? String
                    completionHander(success: true, errorString: nil)
                } else {
                    NSLog("Post failed. No valid response : \(JSONResult)")
                    completionHander(success: false, errorString: "Post failed. No valid response : \(JSONResult)")
                }
            }
        }
    }
    
    
    // Log out of a session
    func logOutOfUdacitySession(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        if let cookies = sharedCookieStorage.cookies {
            for cookie in cookies {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: HTTPHeader.XSRFToken)
        }
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            if let error = error {
                NSLog("Log out error: \(error)")
                completionHandler(success: false, errorString: "\(error)")
            } else {
//                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
//                NSLog("Log out successfully: \(NSString(data: newData, encoding: NSUTF8StringEncoding))")
                completionHandler(success: true, errorString: nil)
            }
        }
        
        task.resume()
    
    }
    
    
    // Create annotation from user data and add to map
    func createAnnotations(students: [Student], mapView: MKMapView) {
        
        for student in students {
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = CLLocationCoordinate2DMake(student.latitude, student.longitude)
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = student.mediaURL
            
            mapView.addAnnotation(annotation)
            
        }
    }
    
    
    // open url
    func openURL(urlString: String) {
        let url = NSURL(string: urlString)!
        UIApplication.sharedApplication().openURL(url)
    }
    
}
