//
//  FlickSearchUITests.swift
//  FlickSearchUITests
//
//  Created by Dileep Vasa on 11/19/24.
//

import XCTest

final class FlickSearchUITests: XCTestCase {

    private var app: XCUIApplication!
    private var robot: FlickSearchRobot!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        robot = FlickSearchRobot(app: app)
    }

    override func tearDownWithError() throws {
        app = nil
        robot = nil
    }

    func testSearchBarInput() throws {
        robot.enterSearchTerm("porcupine")
            .waitForImageGridToLoad()
            .verifyImageGridExists()
    }

    func testImageGridTapToDetailView() throws {
        robot.enterSearchTerm("porcupine")
            .waitForImageGridToLoad()
            .tapFirstImage()
            .verifyDetailViewIsDisplayed()
    }

    func testBackNavigationFromDetailView() throws {
        robot.enterSearchTerm("porcupine")
            .waitForImageGridToLoad()
            .tapFirstImage()
            .tapBackButton()
            .verifySearchBarExists()
    }

    func testLoadingIndicatorWhileFetchingImages() throws {
        robot.enterSearchTerm("porcupine")
            .verifyLoadingIndicatorAppears()
            .waitForLoadingToComplete()
            .verifyLoadingIndicatorDisappears()
    }
}
