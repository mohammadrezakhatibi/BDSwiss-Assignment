//
//  MockRateAPIService.swift
//  BDSwissTests
//
//  Created by mohammadreza on 10/5/22.
//

@testable import BDSwiss

class MockRateAPIService: RateAPIService {
    
    var isCalled = false
    override func loadRates(completion: @escaping (Result<RatesResponse, Error>) -> Void) {
        isCalled = true
        super.loadRates(completion: completion)
    }
}

extension MockRateAPIService {
    
    static func never(_ error: Error) -> RateService {
        results(.failure(error))
    }
    static func success(_ response: RatesResponse) -> RateService {
        results(.success(response))
    }
    
    static func once() -> RateService {
        let response = RatesResponse(rates: [Rate(symbol: "EURUSD", price: 1.1812678708738442),
                                            Rate(symbol: "GBPUSD", price: 0.8970326033658917)])
        return results(.success(response))
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
