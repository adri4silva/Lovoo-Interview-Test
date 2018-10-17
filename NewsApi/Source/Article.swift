//
//  Article.swift
//  Lovoo Interview Test
//
//  Created by Adrián Silva on 12/10/2018.
//  Copyright © 2018 Adrián Silva. All rights reserved.
//

import Foundation

public struct Article {
    let author: String?
    let title: String?
    let articleDescription: String?
    let articleUrl: String?
    let imageUrl: String?
    let publishedDateString: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case author
        case title
        case articleDescription = "description"
        case articleUrl = "url"
        case imageUrl = "urlToImage"
        case publishedDateString = "publishedAt"
        case content
    }
}

extension Article: Codable {}
