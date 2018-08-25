//
//  CollectionCoinCell.swift
//  Bitcoin
//
//  Created by Ayman Zeine on 8/20/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import UIKit

class CollectionCoinCell: BaseCell {
    
    let theme = ThemeManager.currentTheme()
    
    let coinRank: UILabel = {
        let label = UILabel()
        label.text = "100"
        label.textAlignment = .center
        label.textColor = .cyan
        //label.backgroundColor = .yellow
        return label
    }()
    
    let coinName: UILabel = {
        let label = UILabel()
        label.text = "Coin Name"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 21)
        //label.backgroundColor = .yellow
        return label
    }()
    
    let coinValue: UILabel = {
        let label = UILabel()
        label.text = "$7,000.000"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        //label.backgroundColor = .yellow
        return label
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    let percentageView: UILabel = {
        let label = UILabel()
        label.text = "-10.23%"
        label.textColor = .white
        return label
    }()
    
    let healthView: UILabel = {
        let label = UILabel()
        label.text = "health"
        label.textColor = .white
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(coinRank)
        addSubview(coinName)
        addSubview(coinValue)
        addSubview(seperatorView)
        addSubview(percentageView)
        addSubview(healthView)
        
        addConstraintsWithFormat(format: "H:|-8-[v0(30)]", views: coinRank)
        
        addConstraintsWithFormat(format: "H:|-45-[v0(100)]", views: coinName)
        addConstraintsWithFormat(format: "H:|-45-[v0(110)]", views: coinValue)
        
        addConstraintsWithFormat(format: "V:|-8-[v0]-8-[v1]-8-|", views: coinName, coinValue)
        
        addConstraintsWithFormat(format: "H:[v0(75)]-30-[v1(70)]-8-|", views: percentageView, healthView)
        addConstraintsWithFormat(format: "V:|-20-[v0(40)]", views: healthView)
        addConstraintsWithFormat(format: "V:|-20-[v0(40)]", views: percentageView)
        
        addConstraintsWithFormat(format: "V:|-8-[v0]-8-[v1(1)]|", views: coinRank, seperatorView)
        
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: seperatorView)
        
        backgroundColor = theme.backgroundColor
    }
}
