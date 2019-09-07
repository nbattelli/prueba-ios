//
//  Movies.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 29/08/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import Foundation

struct Movies: Decodable, Paginable {
    
    var results: [Movie]
    var currentPage: Int
    var totalPages: Int
    var cached: Bool?
    
    init(movies: [Movie], cached: Bool? = false) {
        self.results = movies
        self.currentPage = 1
        self.totalPages = 1
        self.cached = cached ?? false
    }
    
    private enum CodingKeys: String, CodingKey {
        case results
        case currentPage = "page"
        case totalPages = "total_pages"
    }
    
    func test() {
        for movie in results {
            print("\(movie.id) + \(movie.title)")
        }
    }
}
