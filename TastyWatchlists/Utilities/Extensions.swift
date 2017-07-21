//
//  Extensions.swift
//  TastyWatchlists
//
//  Created by Jason Dimitriou on 7/21/17.
//  Copyright © 2017 Jason Dimitriou. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func roundToTwoDecimals() -> Double {
        let divisor = pow(10.0, Double(2))
        return (self * divisor).rounded() / divisor
    }
}
