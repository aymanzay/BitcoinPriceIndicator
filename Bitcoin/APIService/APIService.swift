//
//  APIService.swift
//  Bitcoin
//
//  Created by Ayman Zeine on 8/22/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import UIKit
import Alamofire
class APIService: NSObject {
    
    static let sharedInstance = APIService()
    
    private var results:[CoinInfo] = [CoinInfo]()
    
    let group = DispatchGroup()
    
    func fetchProfile(completion: @escaping () -> ()) {
        
    }
    
    func fetchNewsFeed(completion: @escaping (ArticleList) -> ()) {
        
        var articles:[Article] = []
        var newsArray:ArticleList = ArticleList(articles: articles, totalResults: 0)
        
        Alamofire.request("https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=1c7d3c6818f749758d79927311573eb5").responseJSON { (response) in
            if let newsListJSON = response.result.value {
                let newsObject:Dictionary = newsListJSON as! Dictionary<String, Any>
                let articlesArray:NSArray = newsObject[Constants.kArticles] as! NSArray
                
                let totalResults:NSNumber = newsObject[Constants.kTotalResults] as! NSNumber
                
                var tempArray:[Dictionary<String,Any>] = []
                for entry in articlesArray {
                    let newsEntry:Dictionary = entry as! Dictionary<String, Any>
                    tempArray.append(newsEntry)
                }
                
                for entry in tempArray {
                    
                    guard let source:Dictionary<String, Any> = entry[Constants.kSource] as? Dictionary<String,Any> else { return }
                    
                    if let article:Article = Article(source: Source(id: source[Constants.kID] as? String, name: (source[Constants.kName] as? String)!), author: entry[Constants.kAuthor] as? String, title: entry[Constants.kTitle] as? String, description: entry[Constants.kDesc] as? String, url: entry[Constants.kURL] as? String, imageUrl: entry[Constants.kUrlToImage] as? String, publishedAt: entry[Constants.kPushlishedAt] as? Date) as! Article {
                        articles.append(article)
                    } else {
                        print("ERROR")
                        return
                    }
                }
                print(articles)
                let articleList = ArticleList(articles: articles, totalResults: totalResults)
                newsArray = articleList
            }
            DispatchQueue.main.async {
                completion(newsArray)
            }
        } //alamo request
    }
    
    func fetchFavoritesFeed(completion: @escaping ([CoinInfo]) -> ()) {
        
    }
    
    func fetchCoins(completion: @escaping ([CoinInfo]) -> ()) {
        
        var coinArray:[Coin] = [Coin]()
    
        group.enter()
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
                        coinArray.append(coin)
                    } else {
                        //self.log.error("coin not found")
                        return
                    }
                }
                
                self.getTickerInfo(coinArray: coinArray)
                self.group.leave()
            }
        }
        
        group.notify(queue: .main) {
            DispatchQueue.main.async {
                completion(self.results)
            }
        }
        
    }
    
    func getTickerInfo(coinArray: [Coin]) -> [CoinInfo] {
        
        var coinInfoArray:[CoinInfo] = [CoinInfo]()
        group.enter()
        Alamofire.request("https://api.coinmarketcap.com/v2/ticker/").responseJSON { (response) in
            if let coinTickerObj = response.result.value {
                let coinObject:Dictionary = coinTickerObj as! Dictionary<String,Any>
                let dataObject:Dictionary = coinObject[Constants.kData] as! Dictionary<String,Any>
                
                var tempArray:[Any] = []
                for coin in coinArray {
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
                        
                        coinInfoArray.append(coinInfo)
                    } else {
                        //self.log.error("could not get coin info")
                    }
                }
                coinInfoArray = self.sortListByRank(coinInfoArray: coinInfoArray)
                self.results = coinInfoArray
                self.group.leave()
            }
        } //alamorequest
        return coinInfoArray
    }
    
    func sortListByRank(coinInfoArray: [CoinInfo]) -> [CoinInfo] {
        
        var rankArray = [Int]()
        for coin in coinInfoArray {
            let x = coin.rank as! Int
            rankArray.append(x)
        }
        
        rankArray.sort(by: <)
        
        var sortedCoinArray = [CoinInfo]()
        
        for rank in rankArray {
            for coin in coinInfoArray {
                let x = coin.rank as! Int
                if x == rank {
                    let tempCoin = CoinInfo(general: coin.general, quotes: coin.quotes, last_updated: coin.last_updated, max_supply: coin.max_supply, circulating_supply: coin.circulating_supply, total_supply: coin.total_supply, rank: coin.rank)
                    sortedCoinArray.append(tempCoin)
                }
            }
        }
        
        return sortedCoinArray
    }
    
}
