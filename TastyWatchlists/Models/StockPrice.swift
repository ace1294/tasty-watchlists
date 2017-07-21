//
//  StockPrice.swift
//  TastyWatchlists
//
//  Created by Jason Dimitriou on 7/21/17.
//  Copyright © 2017 Jason Dimitriou. All rights reserved.
//

import Foundation

struct StockPrice {
    let date: Date
    let price: Double
    
    init(dateString: String, price p: Double) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        date = dateFormatter.date(from: dateString)!
        price = p
    }
}
