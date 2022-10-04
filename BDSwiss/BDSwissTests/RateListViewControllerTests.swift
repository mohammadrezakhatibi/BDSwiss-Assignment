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
    
    func test_ratesList_serviceShouldCall_when_viewViewDidLoad() {
        let api = MockRateAPIService()
        let cache = MockCacheService()
        let service = MockRateServiceAdapter(api: api, cache: cache)
        sut.service = service
        
        sut.simulateLoadingData()
        
        XCTAssertTrue(api.isCalled)
        XCTAssertTrue(service.isCalled)
    }
    
    func test_changeRateStatus_when_rateGoesUp() {
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
    
    func test_changeRateStatus_when_rateGoesDown() {
        // Given
        let response = [ItemViewModel(title: "EURUSD", subtitle: "1.0812678708738442")]
        let cachedItems = [ItemViewModel(title: "EURUSD", subtitle: "1.1812678708738442")]
        
        let api = MockRateAPIService()
        let cache = MockCacheService(items: cachedItems)
        let service = MockRateServiceAdapter(api: api, cache: cache)
        
        sut.service = service
        
        sut.simulateLoadingData()
                              
        let result = service.makeRatesFromAPIResult(with: response)
        
        XCTAssertEqual(result.first?.color, .red)
    
    }
    
    func test_returnSameItems_atFirstCall() {
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
        // Given
        let response = RatesResponse(rates: [Rate(symbol: "EURUSD", price: 1.1812678708738442),
                                            Rate(symbol: "GBPUSD", price: 0.8970326033658917)])
        
        let api = MockRateAPIService.success(response)
        let cache = MockCacheService()
        let service = MockRateServiceAdapter(api: api, cache: cache)
        
        sut.service = service
        
        sut.simulateLoadingData()
        
        XCTAssertEqual(sut.items.count, 2)
        XCTAssertEqual(sut.items.first?.title, "EURUSD".addRatePairSeparator())
        XCTAssertEqual(sut.items.first?.subtitle, 1.1812678708738442.limitDecimal(to: 4))
    
    }
    
    func test_whenAPIFailed_itemCountShouldBeZero() {
        
        // Given
        let api = MockRateAPIService.never(anError())
        let cache = MockCacheService()
        let service = MockRateServiceAdapter(api: api, cache: cache)
        
        sut.service = service
        
        sut.simulateLoadingData()
                        
        XCTAssertEqual(sut.items.count, 0)
    
    }
}

private extension UINavigationController {
    
    func ratesListVC() throws -> ListViewController {
        let vc = try XCTUnwrap(children.first as? ListViewController, "couldn't find expenses list")
        return vc
    }
}



class MockRateServiceAdapter: RateListServiceAdapter {
    
    var isCalled = false
    
    override func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        isCalled = true
        super.loadItems(completion: completion)
    }
}

class MockRateAPIService: RateAPIService {
    
    var isCalled = false
    override func loadRates(completion: @escaping (Result<RatesResponse, Error>) -> Void) {
        isCalled = true
        super.loadRates(completion: completion)
    }
}

class MockCacheService: LocalCacheService {
    var items: [ItemViewModel]?
    
    convenience init(items: [ItemViewModel]) {
        self.init()
        self.items = items
    }
    
    override func saveData(items: [ItemViewModel]) {
        super.saveData(items: self.items ?? items)
    }
    
    override func loadData() -> [ItemViewModel] {
        return items ?? []
    }
}


extension MockRateAPIService {
    
    static func never(_ error: Error) -> RateService {
        results(.failure(error))
    }
    static func success(_ friends: RatesResponse) -> RateService {
        results(.success(friends))
    }
    
    static func results(_ result: Result<RatesResponse, Error>) -> RateService {
        return resultBuilder { result }
    }
    
    static func resultBuilder(_ resultBuilder: @escaping () -> Result<RatesResponse, Error>) -> RateService {
        ItemServiceStub(resultBuilder: resultBuilder)
    }
    
    private class ItemServiceStub: RateService {
       
        private let nextResult: () -> Result<RatesResponse, Error>
        
        init(resultBuilder: @escaping () -> Result<RatesResponse, Error>) {
            nextResult = resultBuilder
        }
        func loadRates(completion: @escaping (Result<RatesResponse, Error>) -> Void) {
            completion(nextResult())
        }
    }
    
}

func anError() -> Error {
    NSError(localizedDescription: "any error message")
}

extension NSError {
     convenience init(localizedDescription: String) {
         self.init(domain: "Test", code: 0, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
     }
}
