//
//  RateListViewControllerTests.swift
//  BDSwissTests
//
//  Created by mohammadreza on 10/4/22.
//

import XCTest
@testable import BDSwiss

class RateListViewControllerTests: XCTestCase {

    var sut: ListViewController!
    var service: RateListServiceAdapter!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = try SceneBuilder().build().ratesListVC()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_ratesList_title() {
        XCTAssertEqual("Rates", sut.title)
    }
    
    func test_ratesList_serviceShouldCall_when_viewDidLoad() {
        let api = MockRateAPIService()
        let cache = MockCacheService()
        let service = MockRateServiceAdapter(api: api, cache: cache)
        sut.service = service
        
        sut.simulateLoadingData()
        
        XCTAssertTrue(api.isCalled)
        XCTAssertTrue(service.isCalled)
    }
    
    func test_changeRateColorToGreen_when_rateGoesUp() {
        // Given
        let response = [ItemViewModel(title: "EURUSD", subtitle: "1.2812678708738442")]
        let cachedItems = [ItemViewModel(title: "EURUSD", subtitle: "0.9812678708738442")]
        
        let api = MockRateAPIService()
        let cache = MockCacheService(items: cachedItems)
        let service = MockRateServiceAdapter(api: api, cache: cache)
        
        sut.service = service
        
        sut.simulateLoadingData()
                              
        let result = service.makeRatesFromAPIResult(with: response)
        
        XCTAssertEqual(result.first?.color, .green)
    
    }
    
    func test_changeRateColorToRed_when_rateGoesDown() {
        // Given
        let response = [ItemViewModel(title: "EURUSD", subtitle: "0.9812678708738442")]
        let cachedItems = [ItemViewModel(title: "EURUSD", subtitle: "1.2812678708738442")]
        
        let api = MockRateAPIService()
        let cache = MockCacheService(items: cachedItems)
        let service = MockRateServiceAdapter(api: api, cache: cache)
        
        sut.service = service
        
        sut.simulateLoadingData()
                              
        let result = service.makeRatesFromAPIResult(with: response)
        
        XCTAssertEqual(result.first?.color, .red)
    
    }
    
    func test_changeRateColorToGreen_when_rateIsNotValid() {
        // Given
        let response = [ItemViewModel(title: "EURUSD", subtitle: "test")]
        let cachedItems = [ItemViewModel(title: "EURUSD", subtitle: "test")]
        
        let api = MockRateAPIService()
        let cache = MockCacheService(items: cachedItems)
        let service = MockRateServiceAdapter(api: api, cache: cache)
        
        sut.service = service
        
        sut.simulateLoadingData()
                              
        let result = service.makeRatesFromAPIResult(with: response)
        
        XCTAssertEqual(result.first?.color, .green)
        XCTAssertEqual(result.first?.color, .green)
    
    }
    
    func test_returnAPIResultItems_atFirstTheCall() {
        // Given
        let rate = [ItemViewModel(title: "EURUSD", subtitle: "0.906437584162075")]
        
        let api = MockRateAPIService()
        let cache = MockCacheService()
        let service = MockRateServiceAdapter(api: api, cache: cache)
        
        let result = service.makeRatesFromAPIResult(with: rate)
        sut.service = service
                                          
        
        XCTAssertEqual(result.first?.subtitle, rate.first?.subtitle)
    
    }
    
    func test_successful_apiCall() {
        
        let api = MockRateAPIService.once()
        let cache = MockCacheService()
        let service = MockRateServiceAdapter(api: api, cache: cache)
        
        sut.service = service
        
        sut.simulateLoadingData()
        
        XCTAssertEqual(sut.items.count, 2)
        XCTAssertEqual(sut.items.first?.title, "EURUSD".addRatePairSeparator())
        XCTAssertEqual(sut.items.first?.subtitle, 1.1812678708738442.limitDecimal(to: 4))
    
    }
    
    func test_whenAPIFailed_itemsCountShouldBeZero() {
        
        // Given
        let api = MockRateAPIService.never(anError())
        let cache = MockCacheService()
        let service = MockRateServiceAdapter(api: api, cache: cache)
        
        sut.service = service
        
        sut.simulateLoadingData()
                        
        XCTAssertEqual(sut.items.count, 0)
    
    }
    
}

extension UINavigationController {
    
    func ratesListVC() throws -> ListViewController {
        let vc = try XCTUnwrap(children.first as? ListViewController, "couldn't find expenses list")
        return vc
    }
}


class MockListServiceCallback: ListService {
    
    var isCalled = false
    func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        isCalled = true
    }
}
