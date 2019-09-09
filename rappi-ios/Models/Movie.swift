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
    let popularity: Double?
    let voteAvarage: Double?
    let voteCount: Double?
    let hasVideo: Bool?
    let posterPath: String?
    let backdropPath: String?
    let adult: Bool?
    let originalTitle: String?
    let releaseDate: String?
    
    init(id: Int, title: String, overview: String?) {
        self.id = id
        self.title = title
        self.overview = overview
        self.popularity = nil
        self.voteAvarage = nil
        self.voteCount = nil
        self.hasVideo = nil
        self.posterPath = nil
        self.backdropPath = nil
        self.adult = nil
        self.originalTitle = nil
        self.releaseDate = nil
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case popularity
        case voteAvarage = "vote_average"
        case voteCount = "vote_count"
        case hasVideo = "video"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case adult = "adult"
        case originalTitle = "original_title"
        case releaseDate = "release_date"
    }
}
