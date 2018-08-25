//
//  CustomCoinListCell.swift
//  
//
//  Created by Ayman Zeine on 8/16/18.
//

import UIKit

class CustomCoinListCell: UITableViewCell {
    
    let theme = ThemeManager.currentTheme()

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var percentChangeLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = theme.backgroundColor
        nameLbl.textColor = theme.mainLabelColor
        priceLbl.textColor = theme.commentColor
        
        percentChangeLabel.textColor = theme.mainColor
        volumeLabel.textColor = theme.mainColor
        
        rankLabel.textColor = theme.blueColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
