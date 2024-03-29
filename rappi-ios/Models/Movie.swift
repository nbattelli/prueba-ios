//
//  Movie.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 29/08/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import Foundation

struct Movie: Codable, BaseMovieProtocol {
    let id: Int
    let title: String
    let overview: String?
    let voteAvarage: Double?
    let posterPath: String?
    let releaseDate: String?
    
    init(id: Int, title: String, overview: String?) {
        self.id = id
        self.title = title
        self.overview = overview
        self.voteAvarage = nil
        self.posterPath = nil
        self.releaseDate = nil
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case voteAvarage = "vote_average"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
}
