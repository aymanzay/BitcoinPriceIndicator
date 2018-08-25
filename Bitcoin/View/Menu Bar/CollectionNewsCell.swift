//
//  CollectionNewsCell.swift
//  Bitcoin
//
//  Created by Ayman Zeine on 8/23/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import UIKit

class CollectionNewsCell: BaseCell {
    
    let articleName: UILabel = {
       let label = UILabel()
        label.text = "Aricle Name"
        label.backgroundColor = .orange
        return label
    }()
    
    let ariticleDescription: UILabel = {
        let label = UILabel()
        label.text = "description: sdfghjkljhgfdxsdfghjkl;kjhgfdsfghjkl;kjhgfdsdfghjkl"
        label.backgroundColor = .blue
        return label
    }()
    
    let articleAuthor: UILabel = {
       let label = UILabel()
        label.text = "Article Author"
        label.backgroundColor = .red
        return label
    }()
    
    let articleImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "news")
        iv.tintColor = .white
        return iv
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(articleName)
        addSubview(ariticleDescription)
        addSubview(articleAuthor)
        addSubview(articleImage)
        addSubview(seperatorView)
        
        
        addConstraintsWithFormat(format: "H:|-8-[v0(25)]", views: articleImage)
        addConstraintsWithFormat(format: "V:|-8-[v0(25)]", views: articleImage)
        
        addConstraintsWithFormat(format: "H:|-60-[v0]", views: articleName)
        addConstraintsWithFormat(format: "V:|-20-[v0]", views: articleName)
        
        addConstraintsWithFormat(format: "H:|-16-[v0(1)]-16-|", views: seperatorView)
        addConstraintsWithFormat(format: "V:[v0]|", views: seperatorView)
        
    }
    
    
    
}
