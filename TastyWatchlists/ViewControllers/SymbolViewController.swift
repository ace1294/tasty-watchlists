//
//  SymbolViewController.swift
//  TastyWatchlists
//
//  Created by Jason Dimitriou on 7/20/17.
//  Copyright © 2017 Jason Dimitriou. All rights reserved.
//

import UIKit
import Charts

class SymbolViewController: UIViewController {
    
    var symbol: Symbol!
    
    @IBOutlet weak var barView: BarChartView!
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    @IBOutlet weak var symbolNameLabel: UILabel!
    @IBOutlet weak var bidPriceLabel: UILabel!
    @IBOutlet weak var askPricelabel: UILabel!
    @IBOutlet weak var lastPriceLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard symbol != nil else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        axisFormatDelegate = self
        
        StockQuoteManager.getThirdDayHistoryForSymbol(symbol, success: { symbolWithHistory in
            self.updateChartWithStockPrices(symbolWithHistory)
        }) { 
            //
        }
        
        let priceTimer = Timer(timeInterval: 5.0, target: self, selector: #selector(getSymbolPrices(_:)), userInfo: nil, repeats: true)
        priceTimer.fire()
    }

    fileprivate func updateChartWithStockPrices(_ stockPrices: [StockPrice]) {
        var dataEntries = [BarChartDataEntry]()
        
        for price in stockPrices {
            let timeIntervalForDate: TimeInterval = price.date.timeIntervalSince1970
            let dataEntry = BarChartDataEntry(x: Double(timeIntervalForDate), y: price.price)
            dataEntries.append(dataEntry)
        }
        
        DispatchQueue.main.async {
            let chartDataSet = BarChartDataSet(values: dataEntries, label: "Stock Price")
            let chartData = BarChartData(dataSet: chartDataSet)
            self.barView.data = chartData
            
            let xAxis = self.barView.xAxis
            xAxis.valueFormatter = self.axisFormatDelegate
        }
    }
    
    fileprivate func updatePriceValues() {
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
    
    func getSymbolPrices(_ timer: Timer) {
        if (!timer.isValid) {
            return
        }
        
        StockQuoteManager.getStockQuotesForSymboles([symbol], success: { symbolsWithQuotes in
            self.symbol = symbolsWithQuotes.first
            self.updatePriceValues()
        }) {
            //
        }
    }

}

extension SymbolViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd"
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
