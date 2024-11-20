//
//  NetworkManagerProtocol.swift
//  FlickSearch
//
//  Created by Dileep Vasa on 11/19/24.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchImages(searchTerm: String) async throws -> [FlickrImage]
}
