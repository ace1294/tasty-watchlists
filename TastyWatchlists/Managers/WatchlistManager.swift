//
//  WatchlistManager.swift
//  TastyWatchlists
//
//  Created by Jason Dimitriou on 7/18/17.
//  Copyright © 2017 Jason Dimitriou. All rights reserved.
//

import Foundation

struct WatchlistManager {
    
    static fileprivate let createListEndPoint = "user/%@/watchlist"
    static fileprivate let deleteListEndPoint = "user/%@/watchlist/%@"
    static fileprivate let createSymbolEndPoint = "user/%@/watchlist/%@/symbol"
    static fileprivate let deleteSymbolEndPoint = "user/%@/watchlist/%@/symbol/%@"
    
    static func createWatchlist(_ watchlist: Watchlist, forUser: User, success:@escaping (User) -> Void, failure:@escaping () -> Void ) {
        
        guard let userServerId = forUser.serverId else {
            failure()
            return
        }
        
        let endPoint = String(format: WatchlistManager.createListEndPoint, userServerId)
        
        NetworkManager.request(endpoint: endPoint, method: .post, params: watchlist.toDictionary(), success: { response in
            let userWithWatchlist = User(dictionary: response)
            success(userWithWatchlist)
        }, failure: failure)
    }
    
    static func deleteWatchlist(_ watchlist: Watchlist, forUser: User, success:@escaping (User) -> Void, failure:@escaping () -> Void ) {
        
        guard let userServerId = forUser.serverId else {
            failure()
            return
        }
        
        guard let watchlistServerUserId = watchlist.serverId else {
            failure()
            return
        }
        
        let endPoint = String(format: WatchlistManager.deleteListEndPoint, userServerId, watchlistServerUserId)
        
        NetworkManager.request(endpoint: endPoint, method: .delete, params: nil, success: { response in
            let userWithoutList = User(dictionary: response)
            success(userWithoutList)
        }, failure: failure)
    }
    
    static func addSymbolToWatchlist(_ symbol: Symbol, watchlist: Watchlist, forUser: User, success:@escaping (User, Watchlist) -> Void, failure:@escaping () -> Void ) {
        
        guard let userServerId = forUser.serverId else {
            failure()
            return
        }
        
        guard let watchlistServerUserId = watchlist.serverId else {
            failure()
            return
        }
        
        let endPoint = String(format: WatchlistManager.createSymbolEndPoint, userServerId, watchlistServerUserId)
        
        NetworkManager.request(endpoint: endPoint, method: .post, params: symbol.toDictionary(), success: { response in
            let userWithSymbol = User(dictionary: response)
            if let lists = userWithSymbol.watchlists {
                for list in lists {
                    if watchlist.serverId == list.serverId {
                        success(userWithSymbol, list)
                        return
                    }
                }
            }
            
            
        }, failure: failure)
    }
    
    static func deleteSymbolFromWatchlist(_ symbol: Symbol, watchlist: Watchlist, forUser: User, success:@escaping (User, Watchlist) -> Void, failure:@escaping () -> Void ) {
        
        guard let userServerId = forUser.serverId else {
            failure()
            return
        }
        
        guard let watchlistServerUserId = watchlist.serverId else {
            failure()
            return
        }
        
        guard let symbolServerUserId = symbol.serverId else {
            failure()
            return
        }
        
        let endPoint = String(format: WatchlistManager.deleteSymbolEndPoint, userServerId, watchlistServerUserId, symbolServerUserId)
        
        NetworkManager.request(endpoint: endPoint, method: .delete, params: nil, success: { response in
            let userWithoutSymbol = User(dictionary: response)
            if let lists = userWithoutSymbol.watchlists {
                for list in lists {
                    if watchlist.serverId == list.serverId {
                        success(userWithoutSymbol, list)
                        return
                    }
                }
            }
        }, failure: failure)
    }
}
