//
//  StringExtensionsTests.swift
//  FlickSearchTests
//
//  Created by Dileep Vasa on 11/19/24.
//

import XCTest
@testable import FlickSearch

final class StringExtensionsTests: XCTestCase {
    
    func testFormattedISO8601Date_APIProvidedDate() {
        // Given
        let iso8601String = "2024-11-18T02:53:13Z"
        
        // When
        let formattedDate = iso8601String.formattedISO8601Date()
        
        // Then
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let expectedDate = ISO8601DateFormatter().date(from: iso8601String)
        let expectedFormattedDate = expectedDate.map { dateFormatter.string(from: $0) } ?? ""
        
        XCTAssertEqual(formattedDate, expectedFormattedDate, "The formatted date should match the expected date.")
    }
    
    func testFormattedISO8601Date_InvalidISO8601String() {
        // Given
        let invalidString = "Not a valid date"
        
        // When
        let formattedDate = invalidString.formattedISO8601Date()
        
        // Then
        XCTAssertEqual(formattedDate, invalidString, "For an invalid date string, the function should return the original string.")
    }
    
    func testFormattedISO8601Date_EmptyString() {
        // Given
        let emptyString = ""
        
        // When
        let formattedDate = emptyString.formattedISO8601Date()
        
        // Then
        XCTAssertEqual(formattedDate, emptyString, "For an empty string, the function should return the original string.")
    }
    
    func testFormattedISO8601Date_PartialDate() {
        // Given
        let partialDateString = "2024-01"
        
        // When
        let formattedDate = partialDateString.formattedISO8601Date()
        
        // Then
        XCTAssertEqual(formattedDate, partialDateString, "For a partial date string, the function should return the original string.")
    }
}

