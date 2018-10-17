//
//  ArticleUnwrapped.swift
//  Lovoo Interview Test
//
//  Created by Adrián Silva on 15/10/2018.
//  Copyright © 2018 Adrián Silva. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// Safe unwrap properties from API call
struct ArticleUnwrapped {

    let model: Article

    init(model: Article) {
        self.model = model
    }

    func articleDescription() -> String {
        guard let description = model.articleDescription else { return "" }
        return description
    }

    func author() -> String {
        guard let author = model.author else { return "" }
        return author
    }

    func title() -> String {
        guard let title = model.title else { return "" }
        return title
    }

    func imageUrl() -> URL {
        guard let imageUrlString = model.imageUrl, let imageUrl = URL(string: imageUrlString) else { return URL(fileURLWithPath: "") }
        return imageUrl
    }

    func content() -> String {
        guard let content = model.content else { return "" }
        return content
    }

    func date() -> String {
        guard let dateString = model.publishedDateString else { return "" }
        let isoFormatter = ISO8601DateFormatter()
        guard let isoDate = isoFormatter.date(from: dateString) else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: isoDate)
    }
}
