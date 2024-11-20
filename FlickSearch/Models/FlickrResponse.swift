//
//  FlickrResponse.swift
//  FlickSearch
//
//  Created by Dileep Vasa on 11/19/24.
//

import Foundation

struct FlickrResponse: Codable {
    let items: [FlickrImage]

    private enum CodingKeys: String, CodingKey {
        case items
    }
}

struct FlickrImage: Codable, Identifiable {
    var id: String { link }
    let title: String
    let link: String
    let media: Media
    let dateTaken: String
    let description: String
    let published: String
    let author: String

    private enum CodingKeys: String, CodingKey {
        case title
        case link
        case media
        case dateTaken = "date_taken"
        case description
        case published
        case author
    }
}

struct Media: Codable {
    let m: String
}
