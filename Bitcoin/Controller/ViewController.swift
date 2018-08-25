//
//  ViewController.swift
//  Bitcoin
//
//  Created by Ayman Zeine on 8/16/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import UIKit
import Alamofire
import Charts
import SwiftyBeaver

class ViewController: UIViewController {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    
    @IBOutlet weak var graphView: LineChartView!
    
    let theme = ThemeManager.currentTheme()
    
    let log = SwiftyBeaver.self
    
    var dates:[String] = []
    var prices:[NSNumber] = []
    
    fileprivate func getBitcoinPrice() {
        Alamofire.request("https://api.coindesk.com/v1/bpi/currentprice.json").responseJSON { (response) in
            
            if let bitcoinJSON = response.result.value {
                let bitcoinObject:Dictionary = bitcoinJSON as! Dictionary<String, Any>
                
                let bpiObject:Dictionary = bitcoinObject[Constants.kBPI] as! Dictionary<String, Any>
                let usdObject:Dictionary = bpiObject[Constants.kUSD] as! Dictionary<String, Any>
                let rate = usdObject[Constants.kRate]
                
                let timeObject:Dictionary = bitcoinObject[Constants.kTime] as! Dictionary<String, Any>
                let updatedTime = timeObject[Constants.kUpdated]
                
                DispatchQueue.main.async {
                    self.priceLabel.text = "$\(rate!)"
                    self.timeStampLbl.text = "\(updatedTime!)"
                }
            }
        }
    }
    
    fileprivate func getBitcoinPriceHistory(){
        Alamofire.request("https://api.coindesk.com/v1/bpi/historical/close.json").responseJSON(completionHandler: { (response) in
            
            if let historyJSON = response.result.value {
                let historyObject:Dictionary = historyJSON as! Dictionary<String, Any>
                
                let bpiHistory:Dictionary = historyObject[Constants.kBPI] as! Dictionary<String, Any>
                
                for pair in bpiHistory {
                    self.dates.append(pair.key)
                    self.prices.append(pair.value as! NSNumber)
                }
                
                self.setChartValues(self.dates.count)
                //print(self.dates, self.prices)
                
            }
        })
    }
    
    func setChartValues(_ count : Int = 20) {
        let values = (0..<count).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i), y: Double(truncating: prices[i]))
        }
        
        graphView.dragEnabled = true
        graphView.setScaleEnabled(true)
        graphView.pinchZoomEnabled = false
        graphView.animate(xAxisDuration: 2.5)
        graphView.xAxis.labelTextColor = .white
        graphView.leftAxis.labelTextColor = .white
        graphView.leftAxis.granularityEnabled = true
        graphView.rightAxis.labelTextColor = .clear
        graphView.legend.textColor = .white
        
        //graphView.backgroundColor = UIColor.white
        
        let set1 = LineChartDataSet(values: values, label: "Bitcoin price history of 30 days.")
        
        set1.lineWidth = 1.75
        set1.circleRadius = 5.0
        set1.circleHoleRadius = 2.5
        set1.setColor(.white) //line color
        set1.setCircleColor(.black)
        set1.highlightColor = .gray
        set1.drawValuesEnabled = false
        
        let data = LineChartData(dataSets: [set1])
        
        self.graphView.data = data
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = theme.backgroundColor
        
        priceLabel.text = "..."
        priceLabel.textColor = theme.mainLabelColor
        
        timeStampLbl.text = "..."
        timeStampLbl.textColor = theme.commentColor
        
        
        //Alamofire request for current price, sets labels as well
        getBitcoinPrice()
        
        //Alamofire request for history of bpi price for graphing
        getBitcoinPriceHistory()
        
    }

}

