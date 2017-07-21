//
//  FacebookLoginManager.swift
//  TastyWatchlists
//
//  Created by Jason Dimitriou on 7/20/17.
//  Copyright © 2017 Jason Dimitriou. All rights reserved.
//

import Foundation

import FacebookLogin
import FacebookCore

struct TastyProfileRequest: GraphRequestProtocol {
    struct Response: GraphResponseProtocol {
        var facebookUserId: String?
        var name: String?
        
        init(rawResponse: Any?) {
            // Decode JSON from rawResponse into other properties here.
            if let dictResponse = rawResponse as? Dictionary<String, Any> {
                facebookUserId = dictResponse["id"] as? String
                name = dictResponse["first_name"] as? String
            }
        }
    }
    
    var graphPath = "/me"
    var parameters: [String : Any]? = ["fields": "id, first_name"]
    var accessToken = AccessToken.current
    var httpMethod: GraphRequestHTTPMethod = .GET
    var apiVersion: GraphAPIVersion = .defaultVersion
}

struct FacebookLoginManager {
    static func login(fromViewController: UIViewController, success:@escaping (User) -> Void, failure:@escaping () -> Void) {
        let loginManager = LoginManager()
        loginManager.logIn([.publicProfile], viewController: fromViewController) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled facebook login.")
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                
                let connection = GraphRequestConnection()
                connection.add(TastyProfileRequest()) { response, result in
                    switch result {
                    case .success(let response):
                        if let name = response.name, let id = response.facebookUserId {
                            let user = User(name: name, facebookId: id)
                            success(user)
                        }
                        else {
                            failure()
                        }
                        
                    case .failed(_):
                        failure()
                    }
                }
                connection.start()
            }
        }
    }
}
