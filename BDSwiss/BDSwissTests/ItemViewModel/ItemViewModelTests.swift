//
//  ItemViewModelTests.swift
//  BDSwissTests
//
//  Created by mohammadreza on 10/4/22.
//

import XCTest

@testable import BDSwiss

class ItemViewModelTests: XCTestCase {
    
    var sut: ItemViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ItemViewModel(title: "EURUSD".addRatePairSeparator(), subtitle: 0.987945849.limitDecimal(to: 4), color: .gray)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_separator_forTitle() {
        XCTAssertEqual(sut.title, "EUR/USD")
    }
    
    func test_decimalLimitation_forSubtitle() {
        XCTAssertEqual(sut.subtitle, "0.9879")
    }
    
}
