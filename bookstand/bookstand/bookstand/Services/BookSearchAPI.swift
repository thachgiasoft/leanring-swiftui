//
//  BookSearchAPI.swift
//  bookstand
//
//  Created by Won on 2019/09/26.
//  Copyright © 2019 Won. All rights reserved.
//

import Foundation

struct BookSearchAPI {

    let baseURL = URL(string: "https://dapi.kakao.com/v3")!
    let apiKey = "KakaoAK 57ee879cb839006ba4c51db31d1b7d99"

    static let shared = BookSearchAPI()
    let decoder = JSONDecoder()

    var target: Target = .title

    enum Target: String {
        case title
        case isbn
        case publisher
        case person
    }

    enum APIError: Error {
        case invalidInfo
        case noResponse
        case jsonDecodingError(error: Error)
        case networkError(error: Error)
    }

    enum Endpoint {
        case search(Target)

        var path: String {
            switch self {
            case .search(let target):
                return "search/book?target=\(target.rawValue)"
            }
        }
    }

    func GET<T: Codable>(endpoint: Endpoint,
                         params: [String: String]?,
                         completionHandler: @escaping (Result<T, APIError>) -> Void) {

        let queryURL = baseURL.appendingPathComponent(endpoint.path)

        var components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [
           URLQueryItem(name: "Authorization", value: apiKey),
        ]

        if let params = params {
            for (_, value) in params.enumerated() {
                components.queryItems?.append(URLQueryItem(name: value.key, value: value.value))
            }
        }

        guard let url = components.url else {
            DispatchQueue.main.async { completionHandler(.failure(.invalidInfo)) }
            return
        }

        var request = URLRequest(url: url)

        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.noResponse))
                }
                return
            }

            guard error == nil else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.networkError(error: error!)))
                }
                return
            }

            do {
                let object = try self.decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(.success(object))
                }
            } catch let error {
                DispatchQueue.main.async {
                    #if DEBUG
                    print("JSON Decoding Error: \(error)")
                    #endif
                    completionHandler(.failure(.jsonDecodingError(error: error)))
                }
            }
        }
        task.resume()
    }
}
