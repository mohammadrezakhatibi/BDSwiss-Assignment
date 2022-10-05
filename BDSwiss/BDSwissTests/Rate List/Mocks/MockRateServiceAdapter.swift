//
//  MockRateServiceAdapter.swift
//  BDSwissTests
//
//  Created by mohammadreza on 10/5/22.
//

@testable import BDSwiss

class MockRateServiceAdapter: RateListServiceAdapter {
    
    var isCalled = false
    
    override func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        isCalled = true
        super.loadItems(completion: completion)
    }
}
