//
//  Articles.swift
//  Lovoo Interview Test
//
//  Created by Adrián Silva on 12/10/2018.
//  Copyright © 2018 Adrián Silva. All rights reserved.
//

import Foundation

public struct Articles {
    public let status: String
    public let articles: [Article]?
    public let totalResults: Int
}

extension Articles: Codable {}
