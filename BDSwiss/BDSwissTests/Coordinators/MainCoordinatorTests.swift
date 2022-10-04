//
//  MainCoordinatorTests.swift
//  BDSwissTests
//
//  Created by mohammadreza on 10/4/22.
//

import XCTest
@testable import BDSwiss

class MainCoordinatorTests: XCTestCase {

    var sut: Coordinator!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let nav = UINavigationController()
        sut = MainCoordinator(navigationController: nav)
        sut.start()
        
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_navigation_title() {
        XCTAssertEqual("Rates", sut.navigationController?.title)
    }

}
