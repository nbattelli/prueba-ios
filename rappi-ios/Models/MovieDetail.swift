//
//  MovieDetail.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 08/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

struct MovieDetail: Decodable, BaseMovieProtocol {
    let id: Int
    let title: String
    let overview: String?
    let voteAvarage: Double?
    let posterPath: String?
    let releaseDate: String?
    let genres: [Genre]?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case voteAvarage = "vote_average"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case genres
    }
}

struct Genre: Decodable {
    let id: Int
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
