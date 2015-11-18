//
//  NetworkClient.swift
//  OnTheMap
//
//  Created by Chi Zhang on 11/15/15.
//  Copyright © 2015 cz. All rights reserved.
//

import Foundation
import MapKit


// MARK: Client Class Dealing with All Networking Jobs

/*
There are three files for this class
1. NetworkClient.swift: Including a Singleton instance with some related variables, and also general network methods, including GET and POST
2. NetworkConvenience.swift: extension of NetworkClient, implementing more methods for specific tasks based on the general methods defined before
3. NetworkConstants.swift: extension of NetworkClient, store network parameters for HTTP requests and parse JSON responses.
*/

class NetworkClient: NSObject {
    
    // MARK: Properties
    
    /* Shared session */
    var session: NSURLSession
    
    /* Enum of two web services */
    enum Server {
        case Udacity
        case Parse
    }
    
    /* Parameters for Authentication */
    var sessionID : String?
    var userID : String?
    var objectId: String?
    
    /* Parameters for Current User Infomation */
    var firstName = ""
    var lastName = ""
    var latitude : CLLocationDegrees = CLLocationDegrees()
    var longitude : CLLocationDegrees =  CLLocationDegrees()
    var mediaURL = ""
    var mapString = ""
    
    
    
    // MARK: Initializer
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    
    // MARK: Shared Instance
    class func sharedInstance() -> NetworkClient {
        
        struct Singleton {
            static var sharedInstance = NetworkClient()
        }
        
        return Singleton.sharedInstance
    }
    
    
    // Mark: GET
    func taskForGETMethod(server: Server, method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        var baseURL: String
        
        switch server {
        case .Udacity:
            baseURL = Constants.UdacityBaseURL
        case .Parse:
            baseURL = Constants.ParseBaseURL
        }
        
        let urlString = baseURL + method + NetworkClient.escapedParameters(parameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        if server == Server.Parse {
            request.addValue(Constants.ParseAppId, forHTTPHeaderField: HTTPHeader.ParseApplicationId)
            request.addValue(Constants.ParseApiKey, forHTTPHeaderField: HTTPHeader.ParseRESTAPIKey)
        }
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            guard (error == nil) else {
                NSLog("There was an error with your request: \(error)")
                return
            }

            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    NSLog("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    NSLog("Your request returned an invalid response! Response: \(response)!")
                } else {
                    NSLog("Your request returned an invalid response!")
                }
                return
            }
            
            guard let data = data else {
                NSLog("No data was returned by the request!")
                return
            }
            
            /* Parse the data and use the data (happens in completion handler) */
            switch server {
            case .Udacity:
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                NetworkClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            case .Parse:
                NetworkClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
            
        }
        
        /* Start the request */
        task.resume()
        
        return task
    }
    
    
    // MARK: POST
    func taskForPOSTMethod(server: Server, method: String, parameters: [String : AnyObject], jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        var baseURL: String
        
        switch server {
        case .Udacity:
            baseURL = Constants.UdacityBaseURL
        case .Parse:
            baseURL = Constants.ParseBaseURL
        }
        
        let urlString = baseURL + method + NetworkClient.escapedParameters(parameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        } catch {
            NSLog("Error when generating HTTPBody with JSON object: \(jsonBody)")
        }
        
        switch server {
        case .Parse:
            request.addValue(Constants.ParseAppId, forHTTPHeaderField: HTTPHeader.ParseApplicationId)
            request.addValue(Constants.ParseApiKey, forHTTPHeaderField: HTTPHeader.ParseRESTAPIKey)
        case .Udacity:
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        /* Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            guard (error == nil) else {
                NSLog("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    NSLog("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    NSLog("Your request returned an invalid response! Response: \(response)!")
                } else {
                    NSLog("Your request returned an invalid response!")
                }
                return
            }
            
            guard let data = data else {
                NSLog("No data was returned by the request!")
                return
            }
            
            /* Parse the data and use the data (happens in completion handler) */
            switch server {
            case .Udacity:
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                NetworkClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            case .Parse:
                NetworkClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
            
        }
        
        /* Start the request */
        task.resume()
        
        return task
    }
    
    
    
    // MARK: Helper Functions
    
    /* Helper: Substitute the key for the value that is contained within the method name */
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            completionHandler(result: parsedResult, error: nil)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
}