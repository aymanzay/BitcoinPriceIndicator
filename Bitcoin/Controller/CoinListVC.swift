//
//  CoinListVC.swift
//  Bitcoin
//
//  Created by Ayman Zeine on 8/16/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyBeaver

class CoinListVC: UIViewController {
    
    @IBOutlet var coinList: UITableView!
    
    let theme = ThemeManager.currentTheme()
    let log = SwiftyBeaver.self
    
    public struct tableObject {
        var sectionName: String!
        var sectionObjects: [CoinInfo]!
    }
    
    var tbleObjectArray = [tableObject]() //for sectioning
    
    var coinArray:[Coin] = [] //intermediate
    
    var coinInfoArray:[CoinInfo] = [] //final displayable array

    fileprivate func getCoinList() {
        Alamofire.request("https://api.coinmarketcap.com/v2/listings/").responseJSON { (response) in
            if let coinListJSON = response.result.value {
                let coinObject:Dictionary = coinListJSON as! Dictionary<String,Any>
                let dataObject:NSArray = coinObject[Constants.kData] as! NSArray
                
                var tempArray:[Dictionary<String,Any>] = []
                for entry in dataObject {
                    let coinEntry:Dictionary = entry as! Dictionary<String, Any>
                    tempArray.append(coinEntry)
                }
                
                for entry in tempArray {
                    if let coin:Coin = Coin(id: entry[Constants.kID] as! NSNumber, name: entry[Constants.kName] as! String, symbol: entry[Constants.kSymbol] as! String, website_slug: entry[Constants.kWeb] as! String) {
                        self.coinArray.append(coin)
                    } else {
                        self.log.error("coin not found")
                        return
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.getTickerInfo()
            }
        }
    }
    
    fileprivate func getTickerInfo() {
        Alamofire.request("https://api.coinmarketcap.com/v2/ticker/").responseJSON { (response) in
            if let coinTickerObj = response.result.value {
                let coinObject:Dictionary = coinTickerObj as! Dictionary<String,Any>
                let dataObject:Dictionary = coinObject[Constants.kData] as! Dictionary<String,Any>
                
                var tempArray:[Any] = []
                for coin in self.coinArray {
                    let tempString = "\(coin.id)"
                    if let newCoin = dataObject[tempString] {
                        tempArray.append(newCoin)
                    } else {
                        //self.log.verbose("coin id is not found in ticker")
                    }
                }
                
                //array of coins with information
                var tempDictArray:[Dictionary<String,Any>] = []
                for entry in tempArray {
                    let entryObject:Dictionary = entry as! Dictionary<String, Any>
                    tempDictArray.append(entryObject)
                }
                
                for entry in tempDictArray {
                    guard let quote:Dictionary<String, Any> = entry[Constants.kQuotes] as? Dictionary<String,Any> else { return }
                    guard let quoteEntry:Dictionary<String, Any> = quote[Constants.kUSD] as? Dictionary<String,Any> else { return }
                    
                    if let coinInfo:CoinInfo = CoinInfo(general: Coin(id: entry[Constants.kID] as! NSNumber, name: entry[Constants.kName] as! String, symbol: entry[Constants.kSymbol] as! String, website_slug: entry[Constants.kWeb] as! String),
                                                         quotes: Quotes(usd: USD(market_cap: quoteEntry[Constants.kmarCap] as! NSNumber, percentage_change_1h: quoteEntry[Constants.kpChange1h] as! NSNumber, percentage_change_24h: quoteEntry[Constants.kpChange24h] as! NSNumber, percentage_change_7d: quoteEntry[Constants.kpChange7d] as! NSNumber, price: quoteEntry[Constants.kPrice] as! NSNumber, volume_24h: quoteEntry[Constants.kVol] as! NSNumber)),
                                                        last_updated: entry[Constants.kLastUpdated] as! NSNumber, max_supply: entry[Constants.kMaxSupply] as? NSNumber, circulating_supply: entry[Constants.kCircSupply] as! NSNumber, total_supply: entry[Constants.kTotSupply] as! NSNumber, rank: entry[Constants.kRank] as! NSNumber) {
                    
                        self.coinInfoArray.append(coinInfo)
                    } else {
                        self.log.error("could not get coin info")
                    }
                }
                
                let temp = tableObject(sectionName: "Section 1", sectionObjects: self.coinInfoArray)
                self.tbleObjectArray = [temp]
                self.tbleObjectArray = self.sortListByRank()
                
                
                DispatchQueue.main.async {
                    self.coinList.reloadData()
                }
                
            }
        } //alamorequest
    } //func end
    
    @objc private func searchButtonClicked() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinList.delegate = self
        
        self.view.backgroundColor = theme.backgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.barStyle = theme.barStyle
//        self.navigationController?.navigationBar.barTintColor = theme.backgroundColor
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search"), landscapeImagePhone: #imageLiteral(resourceName: "search"), style: .done, target: self, action: #selector(searchButtonClicked))
        
        let titleLabel = UILabel()
        titleLabel.text = "Coins"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        
        setupMenuBar()
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    private func setupMenuBar() {
        self.view.addSubview(menuBar)
        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        self.view.addConstraintsWithFormat(format: "V:|[v0(150)]", views: menuBar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coinList.estimatedRowHeight = 200
        coinList.rowHeight = UITableViewAutomaticDimension
        getCoinList()
    }
    
}

extension CoinListVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tbleObjectArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first as! HeaderView
        
        let rankButton = headerView.rankButton! 
        rankButton.setTitle("rank", for: .normal)
        rankButton.setTitleColor(theme.orangeColor, for: .normal)
        rankButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        rankButton.addTarget(self, action: #selector(handleRankSort), for: .touchUpInside)
        
        return headerView
    }
    
    func sortListByRank() -> [tableObject] {
        
        let section = 0
        
        var rankArray = [Int]()
        for coin in tbleObjectArray[section].sectionObjects {
            let x = coin.rank as! Int
            rankArray.append(x)
        }
        
        rankArray.sort(by: <)
        
        var sortedCoinArray = [CoinInfo]()
        
        for rank in rankArray {
            for coin in tbleObjectArray[section].sectionObjects {
                let x = coin.rank as! Int
                if x == rank {
                    let tempCoin = CoinInfo(general: coin.general, quotes: coin.quotes, last_updated: coin.last_updated, max_supply: coin.max_supply, circulating_supply: coin.circulating_supply, total_supply: coin.total_supply, rank: coin.rank)
                    sortedCoinArray.append(tempCoin)
                }
            }
        }
        
        let sortedTable = [tableObject(sectionName: "Header", sectionObjects: sortedCoinArray)]
        
        return sortedTable
    }
    
    @objc private func handleRankSort() {
        
        let section = 0
        
        var indexPaths = [IndexPath]()
        for row in tbleObjectArray[section].sectionObjects.indices {
            let indexPath = IndexPath(row:row, section:section)
            indexPaths.append(indexPath)
        }
        
        let sortedTableObjectArray = sortListByRank()
        
        tbleObjectArray[section].sectionObjects.removeAll()
        coinList.deleteRows(at: indexPaths, with: .fade)
        
        DispatchQueue.main.async {
            self.tbleObjectArray = sortedTableObjectArray
            self.coinList.reloadData()
        }
        
        //getTickerInfo()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tbleObjectArray[section].sectionObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinCell") as! CustomCoinListCell
        
        let coin = tbleObjectArray[0].sectionObjects[indexPath.row]
        cell.nameLbl.text = coin.general.name
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 4
        
        
        let priceString: String = formatter.string(from: coin.quotes.usd.price)!
        cell.priceLbl.text = priceString
        
        formatter.numberStyle = .none
        formatter.maximumFractionDigits = 2

        let percent24 = (Float(truncating: (coin.quotes.usd.percentage_change_24h)))
        let changeString: String = "\(percent24)%"
        cell.percentChangeLabel.text = changeString
        
        
        if percent24 < 0 {
            cell.percentChangeLabel.textColor = theme.redColor
        } else {
            cell.percentChangeLabel.textColor = theme.mainLabelColor
        }
        
        formatter.numberStyle = .currency
        
        let volumeString: String = formatter.string(from: coin.quotes.usd.volume_24h)!
        cell.volumeLabel.text = volumeString
        
        formatter.numberStyle = .none
        let rankString: String = formatter.string(from: coin.rank)!
        cell.rankLabel.text = rankString
        
        
        return cell
    }
    
}
