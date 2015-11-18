//
//  NetworkConstants.swift
//  OnTheMap
//
//  Created by Chi Zhang on 11/15/15.
//  Copyright © 2015 cz. All rights reserved.
//

import Foundation


// Stores parameters / constants used for network jobs

extension NetworkClient {
    
    // api server constants
    struct Constants {
        // Udacity
        static let UdacityBaseURL: String = "https://www.udacity.com/api/"
        
        // Parse
        static let ParseBaseURL: String = "https://api.parse.com/1/classes/StudentLocation"
        static let ParseAppId: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ParseApiKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    // http headers for requests
    struct HTTPHeader {
        
        static let ParseApplicationId: String = "X-Parse-Application-Id"
        static let ParseRESTAPIKey: String = "X-Parse-REST-API-Key"
        static let XSRFToken: String = "X-XSRF-TOKEN"
    
    }
    
    // API methods of servers
    struct Methods {
        
        // Udacity
        static let CreateSession = "session"
        static let GetUserData = "users/{user_id}"
        
        // Parse
        static let GetStudentLocations = ""
        static let PostStudentLocation = ""
        
    }
    
    // keys for adding json body
    struct JSONBodyKeys {
        
        // Udacity
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        
        // Parse
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    // keys for parsing json response
    struct JSONResponseKeys {

        static let Error = "error"
        static let Status = "status"

        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MediaUrl = "mediaURL"
        
    }
    
}
