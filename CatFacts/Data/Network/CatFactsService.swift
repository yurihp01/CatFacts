//
//  CatFactsService.swift
//  CatFacts
//
//  Created by Yuri on 12/02/25.
//

import Foundation
import Combine

// MARK: - Service Protocol
protocol CatFactsServiceProtocol {
    func getFacts() -> AnyPublisher<[CatFact], Error>
}

// MARK: - Service Class
final class CatFactsService: Networking, CatFactsServiceProtocol {
    func getFacts() -> AnyPublisher<[CatFact], Error> {
        return performRequest(factsUrl: .catFacts, method: .GET)
            .subscribe(on: DispatchQueue.global())
            .eraseToAnyPublisher()
    }
}
