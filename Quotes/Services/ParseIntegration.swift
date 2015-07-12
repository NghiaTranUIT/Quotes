//
//  ParseHeaderKey.swift
//  Quotes
//
//  Created by Tomasz Szulc on 11/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import Foundation

enum ParseHeaderKey: String {
    case ApplicationID = "PK3BJk8ohNVtIQ3mBvZSZLZHnzn2kF3yXgG8UAGS"
    case clientKey = "HuyEsUUwI4XIFUsn5Ak7a3wMaTEKL0hPPv7iUlii"
    case RESTAPIKey = "wD2kXuukKUd47C1ORBGP8IgFdH35IALzgkFjw4nj"
}

extension NSMutableURLRequest {
    class func parseRequest(path: String, method: String, params: Dictionary<String, AnyObject>? = nil) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: relativeURL(path))
        
        if let params = params {
            request.HTTPBody = httpBodyFromDictionary(params)
        }
        
        request.setValue(ParseHeaderKey.ApplicationID.rawValue, forHTTPHeaderField: "X-Parse-Application-Id")
        request.setValue(ParseHeaderKey.RESTAPIKey.rawValue, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.HTTPMethod = method

        return request
    }
    
    private class func relativeURL(path: String) -> NSURL {
        return NSURL(string: "https://api.parse.com/1/" + path)!
    }
    
    private class func httpBodyFromDictionary(dict: Dictionary<String, AnyObject>) -> NSData {
        var parametersArray = [String]()
        for (key, value) in dict {
            parametersArray.append("\(key)=\(value)")
        }
        
        let result = (parametersArray as NSArray).componentsJoinedByString("&")
        return result.dataUsingEncoding(NSUTF8StringEncoding)!
    }
}
