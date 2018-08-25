//
//  Coins.swift
//  Bitcoin
//
//  Created by Ayman Zeine on 8/16/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import Foundation

struct CoinInfo {
    var general:Coin
    var quotes:Quotes
    var last_updated:NSNumber
    var max_supply: NSNumber?
    var circulating_supply: NSNumber
    var total_supply: NSNumber
    var rank: NSNumber
}

struct Coin {
    var id: NSNumber
    var name: String
    var symbol: String
    var website_slug: String
}

struct Quotes {
    var usd: USD
}

struct USD {
    var market_cap: NSNumber
    var percentage_change_1h: NSNumber
    var percentage_change_24h: NSNumber
    var percentage_change_7d: NSNumber
    var price: NSNumber
    var volume_24h: NSNumber
}


