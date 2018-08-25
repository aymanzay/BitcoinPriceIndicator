//
//  HeaderView.swift
//  Bitcoin
//
//  Created by Ayman Zeine on 8/18/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import UIKit

class HeaderView: UITableViewCell {
    
    @IBOutlet weak var rankButton: UIButton!
    @IBOutlet weak var coinValueButton: UIButton!
    @IBOutlet weak var percentChangeButton: UIButton!
    @IBOutlet weak var volumeButton: UIButton!
    
    let theme = ThemeManager.currentTheme()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = theme.sectionHeaderColor
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
