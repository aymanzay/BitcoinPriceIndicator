//
//  FeedCell.swift
//  Bitcoin
//
//  Created by Ayman Zeine on 8/23/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import UIKit

class FeedCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let theme = ThemeManager.currentTheme()
    
    var coinInfoArray:[CoinInfo] = [] //final displayable array
    
    lazy var collectionView:UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = theme.backgroundColor
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "Cell"
    
    func fetchData() {
        APIService.sharedInstance.fetchCoins { (coinInfoArray: [CoinInfo]) in
            
            self.coinInfoArray = coinInfoArray
            self.collectionView.reloadData()
            
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        fetchData()
        
        addSubview(collectionView)
        collectionView.contentInset = UIEdgeInsetsMake(45, 0, 0, 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(45, 0, 0, 0)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        collectionView.register(CollectionCoinCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coinInfoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CollectionCoinCell
        
        let arrayRef = coinInfoArray[indexPath.row]
        cell.coinRank.text = "\(arrayRef.rank)"
        
        cell.coinName.text = arrayRef.general.symbol
        cell.coinName.textColor = theme.mainLabelColor
        
        cell.coinValue.text = "$\(Double(truncating: arrayRef.quotes.usd.price))"
        cell.coinValue.textColor = theme.commentColor
        
        cell.percentageView.text = "\(Double(truncating: arrayRef.quotes.usd.percentage_change_24h))%"
        if Double(truncating: arrayRef.quotes.usd.percentage_change_24h) > 0.0 {
            cell.percentageView.textColor = .green
        } else {
            cell.percentageView.textColor = .red
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        //transition to 
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
