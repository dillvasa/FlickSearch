//
//  DetailView.swift
//  FlickSearch
//
//  Created by Dileep Vasa on 11/19/24.
//

import SwiftUI

import SwiftUI

struct DetailView: View {
    let image: FlickrImage
    @State private var uiImage: UIImage? = nil
    @ObservedObject var viewModel: FlickrSearchViewModel

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                if let uiImage = uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                } else {
                    Color.gray
                        .task {
                            await loadImage()
                        }
                }
            }
            .frame(maxHeight: 300)

            Text(image.title)
                .font(.headline)
                .padding(.top, 8)

            HTMLTextView(htmlContent: image.description)
                .padding(.horizontal)

            Text("\(NSLocalizedString(Constants.Text.authorLabel, comment: "")): \(image.author)")
                .font(.footnote)

            Text("\(NSLocalizedString(Constants.Text.publishedOnLabel, comment: "")): \(image.published.formattedISO8601Date())")
                .font(.footnote)
                .foregroundColor(.gray)

            if let dimensions = viewModel.parseImageDimensions(from: image.description) {
                Text("\(NSLocalizedString(Constants.Text.dimensionsLabel, comment: "")): \(dimensions)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .navigationTitle(LocalizedStringKey(Constants.Text.flickrSearchTitle))
        .navigationBarTitleDisplayMode(.inline)
    }

    private func loadImage() async {
        if let url = URL(string: image.media.m) {
            uiImage = await viewModel.loadImage(for: url)
        }
    }
}

#Preview {
    let sampleImage = FlickrImage(
        title: "Sample Image",
        link: "https://www.example.com",
        media: Media(m: "https://via.placeholder.com/300"),
        dateTaken: "2024-01-01T00:00:00Z",
        description: "<p>This is a sample description.</p>",
        published: "2024-01-01T00:00:00Z",
        author: "Sample Author"
    )
    let sampleViewModel = FlickrSearchViewModel()

    return DetailView(image: sampleImage, viewModel: sampleViewModel)
}


