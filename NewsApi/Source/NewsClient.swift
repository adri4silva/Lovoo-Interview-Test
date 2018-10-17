//
//  NewsClient.swift
//  Lovoo Interview Test
//
//  Created by Adrián Silva on 12/10/2018.
//  Copyright © 2018 Adrián Silva. All rights reserved.
//

import Foundation
import RxSwift

public final class NewsClient {
    private let apiUrl: URL = URL(string: "https://newsapi.org")!

    public func send(request apiRequest: Request) -> Observable<Articles> {
        return Observable<Articles>.create { observer in
            let request = apiRequest.request(with: self.apiUrl)

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else { return }
                do {
                    let model = try JSONDecoder().decode(Articles.self, from: data)
                    observer.onNext(model)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }

            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
    
}
