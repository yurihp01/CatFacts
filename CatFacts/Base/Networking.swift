//
//  Networking.swift
//  CatFacts
//
//  Created by Yuri on 10/02/25.
//

import Combine
import UIKit

// MARK: - Enum HTTP
public enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

// MARK: - Networking Class
public class Networking {
    private let httpStatusCodeInterval = (200...299)
    
    public func performRequest<T: Decodable>(factsUrl: FactsApiURL, method: HTTPMethod, headers: [String: String]? = nil, body: Data? = nil) -> AnyPublisher<T, Error> {
        guard let url = URL(string: factsUrl.url) else {
            return Fail(error: ServiceError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url, timeoutInterval: 3)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        if let body = body {
            request.httpBody = body
        }
        
        return getPublisher(with: request)
    }
}

// MARK: - Private Ext Networking
private extension Networking {
    func getPublisher<T: Decodable>(with request: URLRequest) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { [weak self] output in
                try self?.validateData(output)
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder.iso8601)
            .eraseToAnyPublisher()
    }

    func validateData(_ output: URLSession.DataTaskPublisher.Output) throws {
        if output.data.isEmpty {
            throw ServiceError.invalidData
        }
        
        if output.response as? HTTPURLResponse == nil {
            throw ServiceError.invalidResponse
        }
        
        if let response = output.response as? HTTPURLResponse,
           !httpStatusCodeInterval.contains(response.statusCode) {
            throw ServiceError.invalidStatusCode(statusCode: response.statusCode)
        }
    }
}
