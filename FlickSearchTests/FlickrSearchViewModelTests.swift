//
//  FlickrSearchViewModelTests.swift
//  FlickrSearchViewModelTests
//
//  Created by Dileep Vasa on 11/19/24.
//

import XCTest
import Combine
@testable import FlickSearch

class FlickrSearchViewModelTests: XCTestCase {
    var viewModel: FlickrSearchViewModel!
    var mockNetworkManager: MockNetworkManager!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        viewModel = FlickrSearchViewModel(networkManager: mockNetworkManager)
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        super.tearDown()
    }

    func testFetchImagesSuccess() async {
        // Arrange
        mockNetworkManager.result = .success(loadSampleResponse())

        // Act
        await viewModel.fetchImages(for: "porcupine")

        // Assert
        XCTAssertEqual(viewModel.images.count, 20)
        XCTAssertEqual(viewModel.images.first?.title, "North American Porcupine")
        XCTAssertEqual(viewModel.state, .loaded)
    }

    func testHandleSearchInputDebounce() {
        // Arrange
        let expectation = XCTestExpectation(description: "Debounce expectation")
        viewModel.handleSearchInput("porcupine")

        // Act
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            XCTAssertEqual(self.viewModel.searchTerm, "porcupine")
            expectation.fulfill()
        }

        // Assert
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadImageSuccess() async {
        // Arrange
        let imageURL = URL(string: "https://live.staticflickr.com/65535/54146489112_a9c92903c8_m.jpg")!
        mockNetworkManager.imageResult = .success(UIImage())

        // Act
        let image = await viewModel.loadImage(for: imageURL)

        // Assert
        XCTAssertNotNil(image)
    }

    func testParseImageDimensions() {
        // Arrange
        let description = "<p><a href=\"https://www.flickr.com/people/schenfeld/\">David Schenfeld</a> posted a photo:</p> <p><a href=\"https://www.flickr.com/photos/schenfeld/54146489112/\" title=\"North American Porcupine\"><img src=\"https://live.staticflickr.com/65535/54146489112_a9c92903c8_m.jpg\" width=\"240\" height=\"160\" alt=\"North American Porcupine\" /></a></p> <p>Cadillac Mountain, Acadia National Park, Maine</p>"

        // Act
        let dimensions = viewModel.parseImageDimensions(from: description)

        // Assert
        XCTAssertEqual(dimensions, "240 x 160")
    }

    private func loadSampleResponse() -> [FlickrImage] {
        let data = try! Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "FlickrSearchMock", withExtension: "json")!)
        let response = try! JSONDecoder().decode(FlickrResponse.self, from: data)
        return response.items
    }
}
