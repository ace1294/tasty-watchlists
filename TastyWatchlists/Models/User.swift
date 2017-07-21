//
//  User.swift
//  TastyWatchlists
//
//  Created by Jason Dimitriou on 7/18/17.
//  Copyright © 2017 Jason Dimitriou. All rights reserved.
//

import Foundation

struct User {
    let serverId: String?
    let name: String?
    let facebookUserId: String?
    let watchlists: [Watchlist]?
    
    static fileprivate let serverIdKey = "id"
    static fileprivate let nameKey = "name"
    static fileprivate let facebookUserIdKey = "facebook_user_id"
    static fileprivate let  watchlistsKey = "watch_lists"
    
    init (serverId id: String, name n: String, facebookId: String) {
        serverId = id
        name = n
        facebookUserId = facebookId
        watchlists = nil
    }
    
    init (name n: String, facebookId: String) {
        serverId = nil
        name = n
        facebookUserId = facebookId
        watchlists = nil
    }
    
    init (dictionary: Dictionary<String, Any>) {
        // Convert id to String, I like IDs as strings client side so we only 
        // have to convert once instead of convert Int to string every push to server
        if let id = dictionary[User.serverIdKey] as? Int {
            serverId = String(id)
        }
        else {
            serverId = nil
        }
        name = dictionary[User.nameKey] as? String
        facebookUserId = dictionary[User.facebookUserIdKey] as? String
        
        if let watchlistDicts = dictionary[User.watchlistsKey] as? [Dictionary<String, Any>] {
            watchlists = Watchlist.getWatchlists(watchlistDicts: watchlistDicts)
        }
        else {
            watchlists = nil
        }
    }
    
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict[User.serverIdKey] = serverId
        dict[User.nameKey] = name
        dict[User.facebookUserIdKey] = facebookUserId
        
        if let lists = watchlists {
            dict[User.watchlistsKey] = Watchlist.toDictionaries(watchlists: lists)
        }
        
        return dict
    }
    
    
}

class UserPersistence {
    static var storedUserId: String? {
        get {
            if let userId = UserDefaults.standard.object(forKey: UserDefaultKeys.storedCurrentUserId) as? String {
                return userId
            }
            else {
                return nil
            }
        }
        set(newUserID) {
            UserDefaults.standard.setValue(newUserID, forKey: UserDefaultKeys.storedCurrentUserId)
        }
    }
}
