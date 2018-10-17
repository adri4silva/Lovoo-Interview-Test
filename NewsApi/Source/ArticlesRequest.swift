//
//  ArticlesRequest.swift
//  Lovoo Interview Test
//
//  Created by Adrián Silva on 12/10/2018.
//  Copyright © 2018 Adrián Silva. All rights reserved.
//

import Foundation

public class ArticlesRequest: Request {
    public var method: RequestType = .get

    public var path: String = "/v2/top-headlines"

    public var parameters = [String : String]()

    public init(country: String = "us",
                category: String = "",
                date: String = "",
                pageSize: String = "5",
                page: String = "1")
    {
        parameters["country"] = country
        parameters["category"] = category
        parameters["apiKey"] = "e02ce6a6363142d192ce7d9c30446211"
        parameters["pageSize"] = pageSize
        parameters["page"] = page
    }
}
