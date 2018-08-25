//
//  NewsCell.swift
//  Bitcoin
//
//  Created by Ayman Zeine on 8/23/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import UIKit

class NewsCell: FeedCell {
    
    //add vars+funcs forvari functionality
    var articles:[Article] = []
    
    var newsCellId = "newsCellId"
    
    var group = DispatchGroup()
    
    override func fetchData() {
        group.enter()
        APIService.sharedInstance.fetchNewsFeed { (response) in
            self.articles = response.articles
            self.collectionView.reloadData()
            self.group.leave()
        }
    }
    
    override func setupViews() {
        
        fetchData()
        
        group.notify(queue: .main) {
            self.addSubview(self.collectionView)
            self.collectionView.contentInset = UIEdgeInsetsMake(45, 0, 0, 0)
            self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(45, 0, 0, 0)
            
            self.addConstraintsWithFormat(format: "H:|[v0]|", views: self.collectionView)
            self.addConstraintsWithFormat(format: "V:|[v0]|", views: self.collectionView)
            
            self.collectionView.register(CollectionNewsCell.self, forCellWithReuseIdentifier: self.newsCellId)
        }

    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newsCellId, for: indexPath) as! CollectionNewsCell
        let newsArticle = articles[indexPath.item]
        
        cell.articleName.text = newsArticle.title!
        cell.articleAuthor.text = newsArticle.author
        cell.ariticleDescription.text = newsArticle.description
        
        if let url = URL(string: newsArticle.url!) {
            if let data = try? Data(contentsOf: url) {
                cell.articleImage.image = UIImage(data: data)
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 100)
    }
    
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//    }
    
}
