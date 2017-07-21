//
//  Watchlist.swift
//  TastyWatchlists
//
//  Created by Jason Dimitriou on 7/18/17.
//  Copyright © 2017 Jason Dimitriou. All rights reserved.
//

import Foundation

struct Watchlist {
    var serverId: String?
    let name: String?
    var symbols: [Symbol]?
    var lastSymbolQuoteUpdate: Date?
    
    static fileprivate let serverIdKey = "id"
    static fileprivate let nameKey = "name"
    static fileprivate let symbolsKey = "symbols"
    
    init (name n: String) {
        name = n
    }
    
    init (dictionary: Dictionary<String, Any>) {
        // Convert id to String, I like IDs as strings client side so we only
        // have to convert once instead of convert Int to string every push to server
        if let id = dictionary[Watchlist.serverIdKey] as? Int {
            serverId = String(id)
        }
        else {
            serverId = nil
        }
        name = dictionary[Watchlist.nameKey] as? String
        
        if let symbolDicts = dictionary[Watchlist.symbolsKey] as? [Dictionary<String, Any>] {
            symbols = Symbol.getSymbols(symbolDicts: symbolDicts)
        }
        else {
            symbols = nil
        }
    }
    
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict[Watchlist.serverIdKey] = serverId
        dict[Watchlist.nameKey] = name
        
        if let syms = symbols {
            dict[Watchlist.symbolsKey] = Symbol.toDictionaries(symbols: syms)
        }
        
        return dict
    }
    
    mutating func updateSymbolsWithQuotes(_ symbolsWithQuotes: [Symbol]) {
        symbols = symbolsWithQuotes
        lastSymbolQuoteUpdate = Date()
    }
    
    static func getWatchlists(watchlistDicts: [Dictionary<String, Any>]) -> [Watchlist] {
        var watchlists = [Watchlist]()
        for watchlistDict in watchlistDicts {
            let watchlist = Watchlist(dictionary: watchlistDict)
            watchlists.append(watchlist)
        }
        
        return watchlists
    }
    
    static func toDictionaries(watchlists: [Watchlist]) -> [Dictionary<String, Any>] {
        var watchlistDictionaries = [Dictionary<String, Any>]()
        for watchlist in watchlists {
            watchlistDictionaries.append(watchlist.toDictionary())
        }
        
        return watchlistDictionaries
    }
    
    
}
