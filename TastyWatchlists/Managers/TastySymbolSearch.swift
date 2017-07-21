//
//  TastySymbolSearch.swift
//  TastyWatchlists
//
//  Created by Jason Dimitriou on 7/20/17.
//  Copyright © 2017 Jason Dimitriou. All rights reserved.
//

import Foundation


struct TastySymbolSearch {
    
    static fileprivate let searchEndpoint = "https://trade.tastyworks.com/symbol_search/search/%@"
    
    static func searchSymbolsForString(_ searchString: String, success:@escaping ([TastySymbol]) -> Void, failure:@escaping () -> Void ) {
        // Search is case sensitive
        let endPoint = String(format: TastySymbolSearch.searchEndpoint, searchString.uppercased())
        
        NetworkManager.requestSearch(endpoint: endPoint, success: { resultArray in
            var symbolsResults = [TastySymbol]()
            for symbolArr in resultArray {
                let symbol = TastySymbol(array: symbolArr)
                symbolsResults.append(symbol)
            }
            success(symbolsResults)
        }, failure: failure)
    }

}
