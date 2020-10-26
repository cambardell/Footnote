//
//  FastlaneSnapshots.swift
//  FastlaneSnapshots
//
//  Created by Pushpinder Pal Singh on 08/10/20.
//  Copyright © 2020 Cameron Bardell. All rights reserved.
//

import XCTest

class FastlaneSnapshots: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
        super.tearDown()
    }

func testSnapshots() throws {

    let app = XCUIApplication()
    let footnoteNavigationBar = app.navigationBars["Footnote"]
    snapshot("1. Onboarding")
    app.buttons["Continue"].tap()

    snapshot("2. Home")

    footnoteNavigationBar.buttons["gear"].tap()
    snapshot("3. About")

    app.children(matching: .window)
        .element(boundBy: 0)
        .children(matching: .other)
        .element.children(matching: .other)
        .element(boundBy: 0)
        .swipeDown()
    app.children(matching: .window)
        .element(boundBy: 0)
        .children(matching: .other)
        .element.children(matching: .other)
        .element(boundBy: 0)
        .swipeDown()

    footnoteNavigationBar.buttons["plus"].tap()

    snapshot("4. Add Quotes")

    let element = XCUIApplication().children(matching: .window)
        .element(boundBy: 0)
        .children(matching: .other)
        .element.children(matching: .other)
        .element(boundBy: 1).children(matching: .other)
        .element.children(matching: .other)
        .element.children(matching: .other)
        .element
    element.swipeDown()

    }
}
