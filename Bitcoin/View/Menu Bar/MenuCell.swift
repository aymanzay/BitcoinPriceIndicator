//
//  MenuCell.swift
//  Bitcoin
//
//  Created by Ayman Zeine on 8/20/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MenuCell: BaseCell {
    
    let theme = ThemeManager.currentTheme()
    
    let pageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.text = "Page"
        return label
    }()
    
    let pageIcon: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "home")
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .gray
        iv.sizeThatFits(CGSize(width: 25, height: 25))
        return iv
    }()
    
    override var isHighlighted: Bool {
        didSet {
            //pageLabel.textColor = isHighlighted ? UIColor.white : UIColor.gray
            pageIcon.tintColor = isHighlighted ? UIColor.white : UIColor.gray
        }
    }
    
    override var isSelected: Bool {
        didSet {
            //pageLabel.textColor = isSelected ? UIColor.white : UIColor.gray
            pageIcon.tintColor = isSelected ? UIColor.white : UIColor.gray
        }
    }
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = theme.sectionHeaderColor
//        addSubview(pageLabel)
//        addConstraintsWithFormat(format: "H:[v0]", views: pageLabel)
//        addConstraintsWithFormat(format: "V:[v0(40)]", views: pageLabel)
//        addConstraint(NSLayoutConstraint(item: pageLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
//        addConstraint(NSLayoutConstraint(item: pageLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        addSubview(pageIcon)
        addConstraintsWithFormat(format: "H:[v0]", views: pageIcon)
        addConstraintsWithFormat(format: "V:[v0(30)]", views: pageIcon)
        addConstraint(NSLayoutConstraint(item: pageIcon, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: pageIcon, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))

    }
    
}
