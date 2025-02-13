//
//  FactsListViewModel.swift
//  CatFacts
//
//  Created by Yuri on 10/02/25.
//

import Combine
import Foundation

// MARK: - FactsList Protocol
protocol FactsListViewModelProtocol: AnyObject {
    var factsPublisher: Published<[CatFact]>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    func getFacts()
}

// MARK: - FactsListViewModel
class FactsListViewModel {
    @Published private var facts = [CatFact]()
    @Published private var error: Error?
    private var cancellables = Set<AnyCancellable>()
    private let service: CatFactsServiceProtocol
    
    init(service: CatFactsServiceProtocol) {
        self.service = service
    }
    
    deinit {
        cancellables.removeAll()
    }
}

// MARK: - Facts List Protocol Impl
extension FactsListViewModel: FactsListViewModelProtocol {
    var factsPublisher: Published<[CatFact]>.Publisher { $facts }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    func getFacts() {
        service.getFacts()
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self?.error = error
                }
            } receiveValue: { [weak self] facts in
                self?.facts = facts
            }.store(in: &cancellables)
    }
}
