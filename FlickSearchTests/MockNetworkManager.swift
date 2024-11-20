//
//  MockNetworkManager.swift
//  FlickSearchTests
//
//  Created by Dileep Vasa on 11/19/24.
//

import XCTest
@testable import FlickSearch

class MockNetworkManager: NetworkManagerProtocol {
    var result: Result<[FlickrImage], Error>?
    var imageResult: Result<UIImage, Error>?

    func fetchImages(searchTerm: String) async throws -> [FlickrImage] {
        switch result {
        case .success(let images):
            return images
        case .failure(let error):
            throw error
        case .none:
            throw URLError(.badServerResponse)
        }
    }
}
