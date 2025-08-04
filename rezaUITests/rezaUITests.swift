//
//  rezaUITests.swift
//  rezaUITests
//
//  Created by reza pahlevi on 03/08/25.
//

import XCTest

import XCTest

final class rezaUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testSearchFieldExistsAndCanType() {
        let searchField = app.textFields["Search username..."]

        XCTAssertTrue(searchField.exists, "SearchTextField should exist")

        searchField.tap()
        searchField.typeText("reza")

        sleep(2)

        let resultCell = app.staticTexts["5y"]
        XCTAssertTrue(resultCell.exists, "User 'reza' should appear in search results")
    }
}

