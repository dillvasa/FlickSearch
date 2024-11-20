//
//  ThumbnailView.swift
//  FlickSearch
//
//  Created by Dileep Vasa on 11/19/24.
//

import SwiftUI

struct ThumbnailView: View {
    let imageURL: URL
    @State private var uiImage: UIImage? = nil
    @ObservedObject var viewModel: FlickrSearchViewModel
    let namespace: Namespace.ID

    var body: some View {
        ZStack {
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .matchedGeometryEffect(id: imageURL, in: namespace)
            } else {
                Color.gray
                    .task {
                        await loadImage()
                    }
            }
        }
        .frame(width: 100, height: 100)
    }

    private func loadImage() async {
        uiImage = await viewModel.loadImage(for: imageURL)
    }
}


#Preview {
    let sampleURL = URL(string: "https://live.staticflickr.com/65535/54146489112_a9c92903c8_m.jpg")!
    let sampleViewModel = FlickrSearchViewModel()
    let namespace = Namespace().wrappedValue

    return VStack {
        ThumbnailView(imageURL: sampleURL, viewModel: sampleViewModel, namespace: namespace)
    }
}
