//
//  APIService.swift
//  bookstand
//
//  Created by won on 2020/03/10.
//  Copyright © 2020 Won. All rights reserved.
//

import Foundation
import Combine

enum APIServiceError: Error {
    case responseError
    case parseError(Error)
}

protocol APIRequestType {
    associatedtype Response: Decodable
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}

protocol APIServiceType {
    func response<Request>(from request: Request) -> AnyPublisher<Request.Response, APIServiceError> where Request: APIRequestType
}

final class APIService: APIServiceType {
    private let baseURL: URL
    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func response<Request>(from request: Request) -> AnyPublisher<Request.Response, APIServiceError> where Request : APIRequestType {

        let pathURL = URL(string: request.path, relativeTo: baseURL)!
        var urlComponents = URLComponents(url: pathURL, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = request.queryItems
        var request = URLRequest(url: urlComponents.url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { data, urlResponse in data }
            .mapError { error -> Error in
                return APIServiceError.responseError
        }
        .decode(type: Request.Response.self, decoder: decoder)
        .mapError(APIServiceError.parseError)
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()

    }
}


struct SearchBookRequest: APIRequestType {

    var path: String {
        return "search/book"
    }

    var queryItems: [URLQueryItem]? {
        return [
        .init(name: "target", value: "")
        ]
    }

    typealias Response = Book

}

public enum Endpoint {
    case get(path: String)
    case post(path: String)
    case put(path: String)
    case delete(path: String)

    internal enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    internal var path: String {
        switch self {
        case let .get(path),
             let .post(path),
             let .put(path),
             let .delete(path):
            return path
        }
    }

    internal var method: HTTPMethod {
        switch self {
        case .get:
            return .get
        case .post:
            return .post
        case .put:
            return .put
        case .delete:
            return .delete
        }
    }
}
