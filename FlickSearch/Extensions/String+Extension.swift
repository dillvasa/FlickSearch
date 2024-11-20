//
//  String+Extension.swift
//  FlickSearch
//
//  Created by Dileep Vasa on 11/19/24.
//

import Foundation

extension String {
    func formattedISO8601Date() -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let date = dateFormatter.date(from: self) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .none
            displayFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            return displayFormatter.string(from: date)
        } else {
            return self
        }
    }
}

