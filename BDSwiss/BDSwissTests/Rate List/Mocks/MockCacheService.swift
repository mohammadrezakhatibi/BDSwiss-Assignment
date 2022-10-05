//
//  MockCacheService.swift
//  BDSwissTests
//
//  Created by mohammadreza on 10/5/22.
//

@testable import BDSwiss

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
