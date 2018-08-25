//
//  FavoritesCell.swift
//  Bitcoin
//
//  Created by Ayman Zeine on 8/23/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import UIKit

class FavoritesCell: FeedCell {
    
    override func fetchData() {
        APIService.sharedInstance.fetchFavoritesFeed { (favorites) in
            self.coinInfoArray = favorites
            self.collectionView.reloadData()
            print("in favorites feed")
        }
    }
    
}
