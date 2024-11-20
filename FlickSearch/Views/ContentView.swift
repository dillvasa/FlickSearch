//
//  ContentView.swift
//  FlickSearch
//
//  Created by Dileep Vasa on 11/19/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FlickrSearchViewModel()
    @Namespace private var imageNamespace
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField(LocalizedStringKey(Constants.Text.searchPlaceholder), text: $viewModel.searchTerm)
                    .padding()
                    .onChange(of: viewModel.searchTerm) { oldValue, newValue in
                        viewModel.handleSearchInput(newValue)
                    }
                
                switch viewModel.state {
                case .idle:
                    Text(LocalizedStringKey(Constants.Text.enterSearchTerm))
                        .foregroundColor(.gray)
                case .loading:
                    ProgressView(LocalizedStringKey(Constants.Text.loadingMessage))
                case .loaded:
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                            ForEach(viewModel.images) { image in
                                Button(action: {
                                    viewModel.selectedImage = image
                                }) {
                                    ThumbnailView(imageURL: URL(string: image.media.m)!, viewModel: viewModel, namespace: imageNamespace)
                                        .frame(width: 100, height: 100)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .accessibilityIdentifier(Constants.accessibilityIdentifierImageGrid)
                    }
                case .error(let message):
                    Text("\(NSLocalizedString(Constants.Text.errorMessagePrefix, comment: ""))\(message)")
                        .foregroundColor(.red)
                }
            }
            .padding()
            .navigationTitle(LocalizedStringKey(Constants.Text.flickrSearchTitle))
            .navigationDestination(isPresented: Binding<Bool>(
                get: { viewModel.selectedImage != nil },
                set: { isActive in
                    if !isActive { viewModel.clearSelectedImage() }
                }
            )) {
                if let selectedImage = viewModel.selectedImage {
                    DetailView(image: selectedImage, viewModel: viewModel)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}



