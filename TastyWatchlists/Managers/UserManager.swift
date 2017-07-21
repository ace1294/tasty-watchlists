//
//  UserManager.swift
//  TastyWatchlists
//
//  Created by Jason Dimitriou on 7/19/17.
//  Copyright © 2017 Jason Dimitriou. All rights reserved.
//

import Foundation

struct UserManager {
    
    static fileprivate let createEndPoint = "user/"
    static fileprivate let getEndPoint = "user/%@"
    static fileprivate let userWithFacebookIdEndPoint = "user/facebookUserId/%@"
    
    static func createUser(_ newUser: User, success:@escaping (User) -> Void, failure:@escaping () -> Void ) {
        let endPoint = UserManager.createEndPoint
        
        NetworkManager.requestServer(endpoint: endPoint, method: .post, params: newUser.toDictionary(), success: { response in
            let newUser = User(dictionary: response)
            success(newUser)
        }, failure: failure)
    }
    
    /**
     For first login and logging in through facebook
    */
    static func getUserWithFacebookId(_ facebookUserId: String, success:@escaping (User) -> Void, failure:@escaping () -> Void ) {
        let endPoint = String(format: UserManager.userWithFacebookIdEndPoint, facebookUserId)
        
        NetworkManager.requestServer(endpoint: endPoint, method: .get, params: nil, success: { response in
            let user = User(dictionary: response)
            success(user)
        }, failure: failure)
    }
    
    /**
     Using the UserPersistence.storedUserID so the user doesn't have to login every launch
    */
    static func getUserWithServerId(_ serverUserID: String, success:@escaping (User) -> Void, failure:@escaping () -> Void ) {
        let endPoint = String(format: UserManager.getEndPoint, serverUserID)
        
        NetworkManager.requestServer(endpoint: endPoint, method: .get, params: nil, success: { response in
            let user = User(dictionary: response)
            success(user)
        }, failure: failure)
    }

}
