//
//  LocalCacheServiceTest.swift
//  BDSwissTests
//
//  Created by Mohammadreza on 10/4/22.
//

import XCTest
@testable import BDSwiss

class LocalCacheServiceTest: XCTestCase {

    var sut: LocalCacheService!
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = LocalCacheService()
        
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_loadDatas_shouldEqualWith_savingDatas() {
        
        // Given
        let items = [ItemViewModel(title: "EURUSD", subtitle: "0.906437584162075"),
                     ItemViewModel(title: "EURGBP", subtitle: "1.206437584162075")]
        sut.saveData(items: items)
        
        // When
        let retrievingDatas: [ItemViewModel] = sut.loadData()
        
        // Then
        XCTAssertEqual(retrievingDatas, items)
        XCTAssertEqual(retrievingDatas.first?.title, items.first?.title)
        XCTAssertEqual(retrievingDatas.first?.subtitle, items.first?.subtitle)
        
    }

}
