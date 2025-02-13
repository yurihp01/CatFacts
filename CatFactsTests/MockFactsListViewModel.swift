//
//  MockFactsListViewModel.swift
//  CatFactsTests
//
//  Created by Yuri on 12/02/25.
//

import Foundation
@testable import CatFacts

class MockFactsListViewModel: FactsListViewModelProtocol {
    var factsPublisher: Published<[CatFact]>.Publisher { $facts }
    var errorPublisher: Published<(Error)?>.Publisher { $error }
    var getFactsCalled = false {
        didSet {
            facts = getFactsCalled ? CatFact.mockedFacts : []
        }
    }
    
    @Published var facts = [CatFact]()
    @Published var error: Error?
    
    func getFacts() {
        getFactsCalled = true
    }
}
