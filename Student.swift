//
//  Student.swift
//  OnTheMap
//
//  Created by Chi Zhang on 11/15/15.
//  Copyright © 2015 cz. All rights reserved.
//

import Foundation
import MapKit

struct Student {
    
    var firstName = ""
    var lastName = ""
    var latitude : CLLocationDegrees = CLLocationDegrees()
    var longitude : CLLocationDegrees =  CLLocationDegrees()
    var mediaURL = ""
    
    
    /* Initialize a student with dictionary */
    init(dictionary: [String : AnyObject]) {
        firstName = dictionary[NetworkClient.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[NetworkClient.JSONResponseKeys.LastName] as! String
        latitude = dictionary[NetworkClient.JSONResponseKeys.Latitude] as! CLLocationDegrees
        longitude = dictionary[NetworkClient.JSONResponseKeys.Longitude] as! CLLocationDegrees
        mediaURL = dictionary[NetworkClient.JSONResponseKeys.MediaUrl] as! String
    }
    
    
    /* Convert an array of dictionaries to an array of students objects */
    static func convertFromDictionaries(array: [[String : AnyObject]]) -> [Student] {
        var resultArray = [Student]()
        
        for dictionary in array {
            resultArray.append(Student(dictionary: dictionary))
        }
        
        return resultArray
    }
}