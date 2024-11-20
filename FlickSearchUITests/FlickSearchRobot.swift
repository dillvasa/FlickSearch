//
//  FlickSearchRobot.swift
//  FlickSearchUITests
//
//  Created by Dileep Vasa on 11/19/24.
//

import XCTest

class FlickSearchRobot {
    private let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }

    func enterSearchTerm(_ term: String) -> Self {
        let searchField = app.textFields["Search for images..."]
        XCTAssertTrue(searchField.exists, "Search bar should exist")
        searchField.tap()
        searchField.typeText(term)
        return self
    }

    func waitForImageGridToLoad(timeout: TimeInterval = 10) -> Self {
        let imageGrid = app.scrollViews.otherElements["ImageGrid"]
        let existsPredicate = NSPredicate(format: "exists == true")
        let expectation = XCTNSPredicateExpectation(predicate: existsPredicate, object: imageGrid)
        XCTWaiter().wait(for: [expectation], timeout: timeout)
        return self
    }

    @discardableResult
    func verifyImageGridExists() -> Self {
        let imageGrid = app.scrollViews.otherElements["ImageGrid"]
        XCTAssertTrue(imageGrid.exists, "Image grid should be displayed after typing in the search bar")
        return self
    }

    func tapFirstImage() -> Self {
        let imageGrid = app.scrollViews.otherElements["ImageGrid"]
        let firstImage = imageGrid.children(matching: .button).element(boundBy: 0)
        XCTAssertTrue(firstImage.exists, "There should be at least one image button to tap")
        firstImage.tap()
        return self
    }

    @discardableResult
    func verifyDetailViewIsDisplayed() -> Self {
        let detailTitle = app.staticTexts["North American Porcupine"]
        XCTAssertTrue(detailTitle.exists, "Detail view should display the expected title or element after tapping on an image")
        return self
    }

    func tapBackButton() -> Self {
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backButton.exists, "Back button should exist in detail view")
        backButton.tap()
        return self
    }

    @discardableResult
    func verifySearchBarExists() -> Self {
        let searchBar = app.textFields["Search for images..."]
        XCTAssertTrue(searchBar.exists, "Should return to search view after tapping the back button")
        return self
    }

    @discardableResult
    func verifyLoadingIndicatorAppears() -> Self {
        let progressView = app.activityIndicators["Loading..."]
        XCTAssertTrue(progressView.exists, "Loading indicator should appear while fetching images")
        return self
    }

    func waitForLoadingToComplete(timeout: TimeInterval = 10) -> Self {
        let progressView = app.activityIndicators["Loading..."]
        let disappearsPredicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: disappearsPredicate, object: progressView)
        XCTWaiter().wait(for: [expectation], timeout: timeout)
        return self
    }

    @discardableResult
    func verifyLoadingIndicatorDisappears() -> Self {
        let progressView = app.activityIndicators["Loading..."]
        XCTAssertFalse(progressView.exists, "Loading indicator should disappear after images are fetched")
        return self
    }
}
