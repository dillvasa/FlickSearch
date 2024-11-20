//
//  ScreenState.swift
//  FlickSearch
//
//  Created by Dileep Vasa on 11/19/24.
//

import Foundation

enum ScreenState: Equatable {
    case idle
    case loading
    case loaded
    case error(String)

    static func ==(lhs: ScreenState, rhs: ScreenState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.loaded, .loaded):
            return true
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}
