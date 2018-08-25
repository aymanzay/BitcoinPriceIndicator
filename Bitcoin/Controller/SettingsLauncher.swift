//
//  SettingsLauncher.swift
//  Bitcoin
//
//  Created by Ayman Zeine on 8/22/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import UIKit
import SwiftyBeaver

class Setting: NSObject {
    let name: String
    let imageName: String
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}

class SettingsLauncer: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let log = SwiftyBeaver.self
    
    let blackview = UIView()
    
    let cellId:String = "cellId"
    
    let cellHeight:CGFloat = 50
    
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    let settings:[Setting] = {
       return [Setting(name: "Settings", imageName: "settings"),
        Setting(name: "Help", imageName: "help"),
        Setting(name: "Feedback", imageName: "comments"),
        Setting(name: "Cancel", imageName: "cancel")]
    }()
    
    @objc func handleDismiss() {
        if let window = UIApplication.shared.keyWindow {
            UIView.animate(withDuration: 0.5, animations: {
                self.blackview.alpha = 0
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                
            })
        }
    }
    
    func showSettings() {
        
        if let window = UIApplication.shared.keyWindow {
            
            blackview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            blackview.backgroundColor = .black
            
            window.addSubview(blackview)
            window.addSubview(collectionView)
            
            let height:CGFloat = CGFloat(settings.count) * cellHeight
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            blackview.frame = window.frame
            blackview.alpha = 0
            
            let offset:CGFloat = 10
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackview.alpha = 0.5
                
                self.collectionView.frame = CGRect(x: 0, y: y-offset, width: self.collectionView.frame.width, height: self.collectionView.frame.height+offset)
            }, completion: nil)
        }
        
    }
    
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.isScrollEnabled = false
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingCell
        
        let setting = settings[indexPath.row]
        cell.setting = setting
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
