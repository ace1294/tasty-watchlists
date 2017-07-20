//
//  NetworkManager.swift
//  TastyWatchlists
//
//  Created by Jason Dimitriou on 7/17/17.
//  Copyright © 2017 Jason Dimitriou. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}

class NetworkManager {
    
//    static fileprivate let serverUrl = "http://198.199.81.13:8080/"
    static fileprivate let serverUrl = "http://localhost:8080/"
    
    static func request(endpoint: String, method: HTTPMethod, params: Dictionary<String, Any>?, success:@escaping (Dictionary<String, Any>) -> Void, failure:@escaping () -> Void) {
        
        let fullRequestString = serverUrl + endpoint
        guard let url = URL(string: fullRequestString) else {
            failure()
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let parameters = params {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                print ("Error \(String(describing: error))")
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    success(json)
                }
                else {
                    failure()
                }
                
                
            } catch let error {
                failure()
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
}

