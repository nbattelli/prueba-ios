//
//  MovieViewModel.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 07/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

struct MovieViewModel: BaseMovieProtocol, Codable {
    let id: Int
    let title: String
    let overview: String?
    let posterPath: String?
}
