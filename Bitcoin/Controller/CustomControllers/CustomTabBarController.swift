//
//  CustomTabBarController.swift
//  Bitcoin
//
//  Created by Ayman Zeine on 8/18/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    let theme = ThemeManager.currentTheme()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barTintColor = theme.sectionHeaderColor

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
