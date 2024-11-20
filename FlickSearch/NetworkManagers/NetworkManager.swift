//
//  NetworkManager.swift
//  FlickSearch
//
//  Created by Dileep Vasa on 11/19/24.
//

import Foundation

final class NetworkManager: NetworkManagerProtocol {
    
    private func createURLComponents(with searchTerm: String) -> URLComponents? {
        var urlComponents = URLComponents(string: "https://api.flickr.com/services/feeds/photos_public.gne")
        urlComponents?.queryItems = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "tags", value: searchTerm)
        ]
        return urlComponents
    }
    
    func fetchImages(searchTerm: String) async throws -> [FlickrImage] {
        guard let url = createURLComponents(with: searchTerm)?.url else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let flickrResponse = try JSONDecoder().decode(FlickrResponse.self, from: data)
        return flickrResponse.items
    }
    
    func fetchData(from url: URL) async throws -> (Data, URLResponse) {
        return try await URLSession.shared.data(from: url)
    }
}
