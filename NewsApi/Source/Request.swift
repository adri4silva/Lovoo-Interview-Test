//
//  Request.swift
//  Lovoo Interview Test
//
//  Created by Adrián Silva on 12/10/2018.
//  Copyright © 2018 Adrián Silva. All rights reserved.
//

import Foundation

public enum RequestType: String {
    case get
}

public protocol Request {
    var method: RequestType { get }
    var path: String { get }
    var parameters: [String : String] { get }
}

public extension Request {
    func request(with baseURL: URL) -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("Error creating URL components")
        }

        components.queryItems = parameters.map {
            URLQueryItem(name: String($0), value: String($1))
        }

        guard let url = components.url else {
            fatalError("Could not get url")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
