//
//  FactsListViewControllerTest.swift
//  CatFactsTests
//
//  Created by Yuri on 12/02/25.
//

import XCTest
import Combine
@testable import CatFacts

class FactsListViewControllerTest: XCTestCase {
    var viewController: FactsListViewController!
    var mockedViewModel: MockFactsListViewModel!
    
    override func setUp() {
        super.setUp()
        viewController = FactsListViewController()
        mockedViewModel = MockFactsListViewModel()
        viewController.viewModel = mockedViewModel
    }
    
    override func tearDown() {
        super.tearDown()
        viewController = nil
        mockedViewModel = nil
    }
    
    func testSearchBarFilteringFacts() {
        // GIVEN
        mockedViewModel.getFacts()
        viewController.facts = mockedViewModel.facts
        XCTAssertEqual(mockedViewModel.facts.count, viewController.filteredFacts.count)
        XCTAssertTrue(mockedViewModel.getFactsCalled)
        
        // WHEN
        viewController.searchBar(viewController.searchBar, textDidChange: "live")
        
        // THEN
        XCTAssertNotEqual(viewController.facts.count, viewController.filteredFacts.count)
    }
    
    func testSearchBarClearingFilteredFacts() {
        // GIVEN
        mockedViewModel.getFacts()
        viewController.facts = mockedViewModel.facts
        XCTAssertEqual(mockedViewModel.facts.count, viewController.filteredFacts.count)
        XCTAssertTrue(mockedViewModel.getFactsCalled)
        
        // WHEN
        viewController.searchBar(viewController.searchBar, textDidChange: "live")
        XCTAssertNotEqual(viewController.facts.count, viewController.filteredFacts.count)
        
        // THEN
        viewController.searchBar(viewController.searchBar, textDidChange: "")
        XCTAssertEqual(viewController.facts.count, viewController.filteredFacts.count)
    }
    
    func testHasFactVerified() {
        // GIVEN
        mockedViewModel.getFacts()
        viewController.facts = mockedViewModel.facts
        XCTAssertTrue(mockedViewModel.getFactsCalled)
        
        // WHEN
        let hasVerified = viewController.facts.contains { $0.status.verified }
        
        // THEN
        XCTAssertTrue(hasVerified)
    }
    
    func testHasNotFactVerified() {
        // GIVEN
        mockedViewModel.getFacts()
        viewController.facts = mockedViewModel.facts
        XCTAssertTrue(mockedViewModel.getFactsCalled)
        
        // WHEN
        viewController.searchBar(viewController.searchBar, textDidChange: "oldest")
        let hasVerified = viewController.filteredFacts.contains { $0.status.verified }
        
        // THEN
        XCTAssertFalse(hasVerified)
    }
    
    func testHasFactUntilNinetyDays() {
        // GIVEN
        mockedViewModel.getFacts()
        viewController.facts = mockedViewModel.facts
        XCTAssertTrue(mockedViewModel.getFactsCalled)
        
        // WHEN
        let isLastNinetyDays = viewController.facts.contains { $0.isLastNinetyDays }
        
        // THEN
        XCTAssertTrue(isLastNinetyDays)
    }
    
    func testHasFactOlderNinetyDays() {
        // GIVEN
        mockedViewModel.getFacts()
        viewController.facts = mockedViewModel.facts
        XCTAssertTrue(mockedViewModel.getFactsCalled)
        
        // WHEN
        viewController.searchBar(viewController.searchBar, textDidChange: "group")
        let isLastNinetyDays = viewController.filteredFacts.contains { $0.isLastNinetyDays }
        
        // THEN
        XCTAssertFalse(isLastNinetyDays)
    }
}
