//
//  ListServiceWithCallbackTests.swift
//  BDSwissTests
//
//  Created by mohammadreza on 10/5/22.
//

import XCTest
@testable import BDSwiss

class ListServiceWithCallbackTests: XCTestCase {

    var sut: ListViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = try SceneBuilder().build().ratesListVC()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_callback_shouldCall_afterPrimaryServiceLoadedSuccessfully() {
        
        // Given
        let api = MockRateAPIService.once()
        let cache = MockCacheService()
        let callback = MockListServiceCallback()
        let service = MockRateServiceAdapter(api: api, cache: cache).callback(callback)
        sut.service = service
        
        XCTAssertEqual(callback.isCalled, false)
        
        //When
        sut.simulateLoadingData()
        
        // Then
        XCTAssertEqual(callback.isCalled, true)
    
    }

}
