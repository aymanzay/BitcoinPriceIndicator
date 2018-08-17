//
//  ViewController.swift
//  Bitcoin
//
//  Created by Ayman Zeine on 8/16/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    
    let theme = ThemeManager.currentTheme()
    
    fileprivate func getBitcoinPrice() -> (DataRequest) {
        return Alamofire.request("https://api.coindesk.com/v1/bpi/currentprice.json").responseJSON { (response) in
            
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = theme.backgroundColor
        
        priceLabel.text = "..."
        priceLabel.textColor = theme.mainLabelColor
        
        timeStampLbl.text = "..."
        timeStampLbl.textColor = theme.commentColor
        
        getBitcoinPrice()
        
    }

}

