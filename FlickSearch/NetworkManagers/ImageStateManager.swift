//
//  ImageStateManager.swift
//  FlickSearch
//
//  Created by Dileep Vasa on 11/19/24.
//

import SwiftUI

actor ImageStateManager {
    private var imageStates: [URL: ScreenState] = [:]
    private var loadedImages: [URL: UIImage] = [:]
    
    func setImageState(for url: URL, state: ScreenState) {
        imageStates[url] = state
    }
    
    func getImageState(for url: URL) -> ScreenState {
        return imageStates[url] ?? .idle
    }
    
    func setLoadedImage(for url: URL, image: UIImage) {
        loadedImages[url] = image
    }
    
    func getLoadedImage(for url: URL) -> UIImage? {
        return loadedImages[url]
    }

    func clearCache(for url: URL? = nil) {
        if let url {
            imageStates.removeValue(forKey: url)
            loadedImages.removeValue(forKey: url)
        } else {
            imageStates.removeAll()
            loadedImages.removeAll()
        }
    }
}
