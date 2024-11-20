//
//  FlickrSearchViewModel.swift
//  FlickSearch
//
//  Created by Dileep Vasa on 11/19/24.
//
import SwiftUI

final class FlickrSearchViewModel: ObservableObject {
    @Published private(set) var images: [FlickrImage] = []
    @Published private(set) var state: ScreenState = .idle
    @Published var selectedImage: FlickrImage? = nil
    @Published var searchTerm: String = ""

    let imageStateManager = ImageStateManager()

    private let networkManager: NetworkManagerProtocol
    private let imageLoader = ImageLoader()
    private var debounceTask: DispatchWorkItem?

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    func handleSearchInput(_ searchTerm: String) {
        debounceTask?.cancel()

        let task = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            Task { @MainActor in
                self.searchTerm = searchTerm
                await self.fetchImages(for: searchTerm)
            }
        }
        debounceTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: task)
    }

    @MainActor
    func fetchImages(for searchTerm: String) async {
        guard !searchTerm.isEmpty else {
            state = .idle
            images = []
            return
        }
        
        state = .loading
        
        do {
            let fetchedImages = try await networkManager.fetchImages(searchTerm: searchTerm)
            images = fetchedImages
            state = fetchedImages.isEmpty ? .error("No results found.") : .loaded
        } catch {
            state = .error("Failed to fetch images: \(error.localizedDescription)")
        }
    }

    func loadImage(for url: URL) async -> UIImage? {
        await imageStateManager.setImageState(for: url, state: .loading)
        do {
            let image = try await imageLoader.fetchImage(from: url)
            await imageStateManager.setLoadedImage(for: url, image: image)
            await imageStateManager.setImageState(for: url, state: .loaded)
            return image
        } catch {
            await imageStateManager.setImageState(for: url, state: .error("Failed to load image"))
            return nil
        }
    }

    func parseImageDimensions(from description: String) -> String? {
        let regex = try? NSRegularExpression(pattern: #"width="(\d+)" height="(\d+)""#, options: [])
        if let match = regex?.firstMatch(in: description, options: [], range: NSRange(description.startIndex..., in: description)) {
            let widthRange = Range(match.range(at: 1), in: description)
            let heightRange = Range(match.range(at: 2), in: description)
            if let width = widthRange.flatMap({ Int(description[$0]) }),
               let height = heightRange.flatMap({ Int(description[$0]) }) {
                return "\(width) x \(height)"
            }
        }
        return nil
    }
    

    func imageState(for url: URL) async -> ScreenState {
        await imageStateManager.getImageState(for: url)
    }

    func clearSelectedImage() {
        selectedImage = nil
    }
}

