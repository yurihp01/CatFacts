//
//  FactsListViewModelTests.swift
//  CatFactsTests
//
//  Created by Kerem Gunduz on 30/03/2021.
//

import XCTest
import Combine
@testable import CatFacts

class FactsListViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    private var service: MockCatFactsService!
    private var viewModel: FactsListViewModelProtocol!
        
    override func setUp() {
        service = MockCatFactsService()
        viewModel = FactsListViewModel(service: service)
        super.setUp()
    }
    
    override func tearDown() {
        service = nil
        viewModel = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testFactsListSuccessAfterAPICall() {
        // GIVEN
        let expectation = XCTestExpectation(description: "Waiting for Facts List API succesfully")
        XCTAssertFalse(service.shouldReturnError)
        
        // WHEN
        service.getFacts()
        .sink { _ in }
        receiveValue: { facts in
            // THEN
            XCTAssertFalse(facts.isEmpty)
            expectation.fulfill()
        }.store(in: &cancellables)

        wait(for: [expectation], timeout: 2)
    }
    
    func testFactsListFailureAfterAPICall() {
        // GIVEN
        let expectation = XCTestExpectation(description: "Waiting for Facts List fails")
        service.shouldReturnError = true
        XCTAssertTrue(service.shouldReturnError)
        
        // WHEN
        service.getFacts()
            .sink { completion in
                // THEN
                switch completion {
                case .finished: break
                case .failure(let error):
                    XCTAssertNotNil(error)
                    expectation.fulfill()
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2)
    }
}
