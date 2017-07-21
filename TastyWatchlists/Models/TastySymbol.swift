//
//  TastySymbol.swift
//  TastyWatchlists
//
//  Created by Jason Dimitriou on 7/20/17.
//  Copyright © 2017 Jason Dimitriou. All rights reserved.
//

import Foundation

struct TastySymbol {
    let shortName: String
    let longName: String
    let type: String
    
    init(array: [String]) {
        shortName = array[0]
        longName = array[1]
        type = array[2]
    }
}
