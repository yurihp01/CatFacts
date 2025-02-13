//
//  MockCatFactsService.swift
//  CatFactsTests
//
//  Created by Yuri on 12/02/25.
//

import Combine
@testable import CatFacts

class MockCatFactsService: CatFactsServiceProtocol {
    var shouldReturnError = false
    
    func getFacts() -> AnyPublisher<[CatFact], Error> {
        return shouldReturnError ? getError() : getMockedFacts()
    }
    
    func getMockedFacts() -> AnyPublisher<[CatFact], Error> {
        Just(CatFact.mockedFacts)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    private func getError() -> AnyPublisher<[CatFact], Error> {
        Fail(error: ServiceError.invalidData).eraseToAnyPublisher()
    }
}
