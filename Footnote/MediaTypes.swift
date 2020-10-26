//
//  MediaTypes.swift
//  Footnote
//
//  Created by Chaithra Pabbathi on 9/30/20.
//  Copyright © 2020 Cameron Bardell. All rights reserved.
//
//  This file is used to fix Issue #17 (adding different media types)

import Foundation

enum MediaType: Int, CaseIterable {
    case book = 0
    case podcast
    case movie
    case tvShow

    var stringValue: String {
        switch self {
        case .book:
            return "Book"
        case .podcast:
            return "Podcast"
        case .movie:
            return "Movie"
        case .tvShow:
            return "TV Show"
        }
    }

    func rawCoreDataValue() -> Int16 {
        Int16(self.rawValue)
    }

    func getImage() -> String {
        switch self {
        case .book:
            return "book.circle.fill"
        case .podcast:
            return "mic.circle.fill"
        case .movie:
            return "film.fill"
        case .tvShow:
            return "tv.circle.fill"
        }
    }
}
