//
//  ProfileCell.swift
//  Bitcoin
//
//  Created by Ayman Zeine on 8/23/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import UIKit

class ProfileCell: FeedCell {
    
    override func fetchData() {
        APIService.sharedInstance.fetchProfile {
            print("in profile cell")
        }
    }
    
}
