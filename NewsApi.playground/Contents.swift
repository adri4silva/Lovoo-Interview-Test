import Foundation
import LovooCore
import RxSwift

let url = URL(string: "https://newsapi.org/")!

let parameters: [String: String] = ["country": "us", "apiKey": "e02ce6a6363142d192ce7d9c30446211"]
let path = "v2/top-headlines"

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
    request.httpMethod = "get"
    return request
}

var requested = request(with: url)

public func send<T: Codable>(request apiRequest: Request) -> Observable<T> {
    return Observable<T>.create { observer in
        let request = apiRequest.request(with: url)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let model = try JSONDecoder().decode(T.self, from: data ?? Data())
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

let articleRequest = ArticlesRequest(category: "health", date: "")

let sent = send(request: articleRequest) as Observable<Articles>

let clientRequest = NewsClient().send(request: articleRequest) as Observable<Articles>

clientRequest.subscribe { event in
    let articles = event.element
    print(articles!)
}

(NSLocale.isoCountryCodes)
Locale.isoRegionCodes

NSLocale.isoCountryCodes == Locale.isoRegionCodes

Locale.isoRegionCodes.map { Locale.current.localizedString(forRegionCode: $0) }


