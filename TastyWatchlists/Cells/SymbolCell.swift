//
//  SymbolCell.swift
//  TastyWatchlists
//
//  Created by Jason Dimitriou on 7/20/17.
//  Copyright © 2017 Jason Dimitriou. All rights reserved.
//

import UIKit

class SymbolCell: UITableViewCell {
    
    static let nibName = "SymbolCell"
    static let reuseIdentifier = "SymbolCell"
    
    static let cellHeight = CGFloat(100)
    
    @IBOutlet weak var symbolNameLabel: UILabel!
    @IBOutlet weak var bidPriceLabel: UILabel!
    @IBOutlet weak var askPricelabel: UILabel!
    @IBOutlet weak var lastPriceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureForSymbol(_ symbol: Symbol) {
        if let name = symbol.name {
            symbolNameLabel.text = name
        }
        
        if let bidPrice = symbol.bidPrice {
            bidPriceLabel.text = bidPrice
        }
        
        if let askPrice = symbol.askPrice {
            askPricelabel.text = askPrice
        }
        
        if let lastPrice = symbol.lastPrice {
            lastPriceLabel.text = lastPrice
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
