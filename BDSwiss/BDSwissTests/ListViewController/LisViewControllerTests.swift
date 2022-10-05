//
//  LisViewControllerTests.swift
//  BDSwissTests
//
//  Created by mohammadreza on 10/4/22.
//

import XCTest
@testable import BDSwiss

class LisViewControllerTests: XCTestCase {

    var sut: ListViewController!
    var service: MockListViewService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        service = MockListViewService()
        sut = ListViewController(service: service)
    }

    override func tearDownWithError() throws {
        service = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_serviceShouldBeCalled_when_viewDidLoad() {
        
        // When
        sut.simulateLoadingData()
        
        // Then
        XCTAssertEqual(service.isCalled, true)
    }
    
}

class MockListViewService: ListService {
    
    var isCalled = false
    func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        isCalled = true
    }
    
    
}
