//
//  ImageLoader.swift
//  FlickSearch
//
//  Created by Dileep Vasa on 11/19/24.
//

import SwiftUI

actor ImageLoader {
    private var cache: [URL: UIImage] = [:]

    func fetchImage(from url: URL) async throws -> UIImage {
        if let cachedImage = cache[url] {
            return cachedImage
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        guard let uiImage = UIImage(data: data) else {
            throw URLError(.badServerResponse)
        }

        cache[url] = uiImage
        return uiImage
    }
}
