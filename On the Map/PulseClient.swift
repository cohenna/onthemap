//
//  PulseClient.swift
//  On the Map
//
//  Created by Nick Cohen on 5/23/15.
//  Copyright (c) 2015 Nick Cohen. All rights reserved.
//

import Foundation

class PulseClient : NSObject {
    
    
    /* Shared session */
    var session: NSURLSession
    
    /* Configuration object */
    //var config = TMDBConfig()
    
    /* Authentication state */
    var sessionID : String? = nil
    var userID : Int? = nil
    var baseImageURLString = "https://api.parse.com/1/classes/"
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // MARK: - GET
    
    func taskForGETMethod(method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        var mutableParameters = parameters
        //mutableParameters[ParameterKeys.ApiKey] = Constants.ApiKey
        
        /* 2/3. Build the URL and configure the request */
        let urlString = baseImageURLString + method + PulseClient.escapedParameters(mutableParameters)
        let url = NSURL(string: urlString)!
        println("url=\(url)")
        let request = NSMutableURLRequest(URL: url)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")

        
        //request.HTTPBody = body
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            if let error = downloadError {
                let newError = PulseClient.errorForData(data, response: response, error: error)
                completionHandler(result: nil, error: downloadError)
            } else {
                PulseClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    
    // MARK: - POST
    
    func taskForPOSTMethod(method: String, parameters: [String : AnyObject], jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        var mutableParameters = parameters
        //mutableParameters[ParameterKeys.ApiKey] = Constants.ApiKey
        
        /* 2/3. Build the URL and configure the request */
        let urlString = baseImageURLString + method + PulseClient.escapedParameters(mutableParameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        var jsonifyError: NSError? = nil
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: nil, error: &jsonifyError)
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            if let error = downloadError {
                let newError = PulseClient.errorForData(data, response: response, error: error)
                completionHandler(result: nil, error: downloadError)
            } else {
                PulseClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: - Helpers
    
    /* Helper: Substitute the key for the value that is contained within the method name */
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    /* Helper: Given a response with error, see if a status_message is returned, otherwise return the previous error */
    class func errorForData(data: NSData?, response: NSURLResponse?, error: NSError) -> NSError {
        
        /*if let parsedResult = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String : AnyObject] {
        
        if let errorMessage = parsedResult[PulseClient.JSONResponseKeys.StatusMessage] as? String {
        
        let userInfo = [NSLocalizedDescriptionKey : errorMessage]
        
        return NSError(domain: "TMDB Error", code: 1, userInfo: userInfo)
        }
        }*/
        
        return error
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        var dataAsString = NSString(data: data, encoding: NSUTF8StringEncoding)
        println(dataAsString)
        
        var parsingError: NSError? = nil
        
        let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
        
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
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
        
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> PulseClient {
        
        struct Singleton {
            static var sharedInstance = PulseClient()
        }
        
        return Singleton.sharedInstance
    }
    
    func getStudentLocations(uniqueKey : String?, limit : Int?, offset : Int?, allowDuplicates: Bool, completionHandler: (result: [StudentLocation]?, error: NSError?) -> Void) {
        var parameters = [String:AnyObject]()
        //parameters[
        
        if let uniqueKey = uniqueKey {
            // look for one user
            var jsonText = "{\"uniqueKey\":\"\(uniqueKey)\"}"
            parameters["where"] = jsonText
        } else {
            // multiple users
            var x = 100
            if let limit = limit {
                x = limit
            }
            parameters["limit"] = x
            
            if let offset = offset {
                parameters["offset"] = offset
            }
        }
        
        taskForGETMethod("StudentLocation", parameters: parameters) { (res, err) in
            if let err = err {
                completionHandler(result: nil, error: err)
                return
            }
            if let results = res.valueForKey("results") as? [[String:AnyObject]] {
                var studentLocations : [StudentLocation] = [StudentLocation]()
                var duplicateCheck = [String:Bool]()
                for result in results {
                    var studentLocation = StudentLocation(fromJSON: result)
                    if let ok = duplicateCheck[studentLocation.uniqueKey!] {
                        if !allowDuplicates {
                            continue
                        }
                    }
                    studentLocations.append(studentLocation)
                    duplicateCheck[studentLocation.uniqueKey!] = true
                }
                completionHandler(result: studentLocations, error: nil)
            } else {
                completionHandler(result:nil, error: NSError(domain: "PulseClient", code: -1, userInfo: nil))
            }
            
            
            
        }
        
    }
    
    func postStudentLocation(studentLocaiton : StudentLocation) {
        
    }
    
    func putStudentLocation(studentlocation: StudentLocation) {
        
    }
    
}