//
//  StockQuoteManager.swift
//  TastyWatchlists
//
//  Created by Jason Dimitriou on 7/20/17.
//  Copyright © 2017 Jason Dimitriou. All rights reserved.
//

import Foundation
import CSV

struct StockQuoteManager {
    
    static fileprivate let searchEndpoint = "http://finance.yahoo.com/d/quotes.csv?s=%@&f=nabl1"
    static fileprivate let thirtyDayHistoryEndpoint = "https://www.bloomberg.com/markets/api/bulk-time-series/price/%@%%3AUS?timeFrame=1_MONTH"
    
    static func getStockQuotesForSymboles(_ symbols: [Symbol], success:@escaping ([Symbol]) -> Void, failure:@escaping () -> Void ) {
        var symbolNames = ""
        for symbol in symbols {
            if let name = symbol.name {
                if symbol == symbols.last {
                    symbolNames += name
                }
                else {
                    symbolNames += name + "+"
                }
            }
        }
        
        let endPoint = String(format: StockQuoteManager.searchEndpoint, symbolNames)
        NetworkManager.requestQuotes(endpoint: endPoint, success: { response in
            let csv = try! CSVReader(string: response)
            
            var newSymbols = [Symbol]()
            for symbol in symbols {
                let row = csv.next()
                if let id = symbol.serverId, let name = symbol.name, let bidPrice = row?[1], let askPrice = row?[2], let lastPrice = row?[3] {
                    let newSym = Symbol(serverId: id, name: name, bidPrice: bidPrice, askPrice: askPrice, lastPrice: lastPrice)
                    newSymbols.append(newSym)
                }
            }
            success(newSymbols)
        }) { 
            //
        }
    }
    
    static func getThirdDayHistoryForSymbol(_ symbol: Symbol, success:@escaping ([StockPrice]) -> Void, failure:@escaping () -> Void ) {

        guard let name = symbol.name else {
            failure()
            return
        }
        let endPoint = String(format: StockQuoteManager.thirtyDayHistoryEndpoint, name)
        
        NetworkManager.request(endpoint: endPoint, method: .get, params: nil, success: { responseDict in
            if let priceDataDicts = responseDict["price"] as? [Dictionary<String, Any>] {
                var prices = [StockPrice]()
                for priceDict in priceDataDicts {
                    prices.append(StockPrice(dateString: priceDict["date"] as! String, price: priceDict["value"] as! Double))
                }
                success(prices)
            }
            
        }) { 
            failure()
        }
    }


}
