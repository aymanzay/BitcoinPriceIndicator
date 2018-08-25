//
//  FullCoinVC.swift
//  Bitcoin
//
//  Created by Ayman Zeine on 8/20/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyBeaver

class FullCoinVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let log = SwiftyBeaver.self
    
    let theme = ThemeManager.currentTheme()
    
    var coinInfoArray:[CoinInfo] = [] //final displayable array
    var coinArray:[Coin] = [] //intermediate coin retrieval

    //cell ids for menu bar to display different content
    let cellId = "cellId"
    let favoriteCellId = "faveCell"
    let newsCellId = "newsCell"
    let profileCellId = "profileCellId"
    
    let titles = ["Home", "Favorites", "News", "Profile"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.textColor = .white
        titleLabel.text = "  Coins"
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        
        setupCollectionView()
        setupNavBarButtons()
        setupMenuBar()
    }
    
    func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        collectionView?.backgroundColor = theme.backgroundColor

        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(FavoritesCell.self, forCellWithReuseIdentifier: favoriteCellId)
        collectionView?.register(NewsCell.self, forCellWithReuseIdentifier: newsCellId)
        collectionView?.register(ProfileCell.self, forCellWithReuseIdentifier: profileCellId)
        
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        
        collectionView?.isPagingEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCoinList()
    }
    
    lazy var menuBar: MenuBar = {
       let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    private func setupNavBarButtons() {
    
        let searchBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(handleSearchButtonPressed))
        let moreBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "verticalMore"), style: .plain, target: self, action: #selector(handleMore))
        
        navigationItem.rightBarButtonItems = [moreBarButton, searchBarButton]
    }
    
    @objc private func handleSearchButtonPressed() {
        print(123)
    }
    
    fileprivate func navTitleSetting(_ menuIndex: Int) {
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "   \(titles[Int(menuIndex)])"
        }
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = NSIndexPath(row: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath as IndexPath, at: [], animated: true)
        
        navTitleSetting(menuIndex)
    }
    
    let settingsLauncher = SettingsLauncer()
    
    @objc private func handleMore() {
        settingsLauncher.showSettings()
    }
    
    private func setupMenuBar() {
        navigationController?.hidesBarsOnSwipe = true
        
        let bgView = UIView()
        bgView.backgroundColor = theme.sectionHeaderColor
        view.addSubview(bgView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: bgView)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: bgView)
        
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: menuBar)
        
        menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = targetContentOffset.pointee.x / view.frame.width
        
        let indexPath = NSIndexPath(row: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition: [])
        
        navTitleSetting(Int(index))
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        var identifier = cellId
        
        if indexPath.item == 1 {
            identifier = favoriteCellId
        } else if indexPath.item == 2 {
            identifier = newsCellId
        } else if indexPath.item == 3{
            identifier = profileCellId
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}
