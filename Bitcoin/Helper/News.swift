//
//  News.swift
//  Bitcoin
//
//  Created by Ayman Zeine on 8/23/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import Foundation

struct ArticleList {
    var articles:[Article]
    var totalResults:NSNumber
}

struct Article {
    var source:Source?
    var author:String?
    var title:String?
    var description:String?
    var url:String?
    var imageUrl:String?
    var publishedAt:Date?
}

struct Source {
    var id:String?
    var name:String
}
