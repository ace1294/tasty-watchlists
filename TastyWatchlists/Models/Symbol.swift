//
//  Symbol.swift
//  TastyWatchlists
//
//  Created by Jason Dimitriou on 7/18/17.
//  Copyright © 2017 Jason Dimitriou. All rights reserved.
//

import Foundation

struct Symbol {
    var serverId: String?
    let name: String?
    
    static fileprivate let serverIdKey = "id"
    static fileprivate let nameKey = "name"
    
    init (name n: String) {
        serverId = nil
        name = n
    }
    
    init (dictionary: Dictionary<String, Any>) {
        // Convert id to String, I like IDs as strings client side so we only
        // have to convert once instead of convert Int to string every push to server
        if let id = dictionary[Symbol.serverIdKey] as? Int {
            serverId = String(id)
        }
        else {
            serverId = nil
        }
        name = dictionary[Symbol.nameKey] as? String
    }
    
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict[Symbol.serverIdKey] = serverId
        dict[Symbol.nameKey] = name
        
        return dict
    }
    
    static func getSymbols(symbolDicts: [Dictionary<String, Any>]) -> [Symbol] {
        var symbols = [Symbol]()
        for symbolDict in symbolDicts {
            let symbol = Symbol(dictionary: symbolDict)
            symbols.append(symbol)
        }
        
        return symbols
    }
    
    static func toDictionaries(symbols: [Symbol]) -> [Dictionary<String, Any>] {
        var symbolDictionaries = [Dictionary<String, Any>]()
        for symbol in symbols {
            symbolDictionaries.append(symbol.toDictionary())
        }
        
        return symbolDictionaries
    }
}
