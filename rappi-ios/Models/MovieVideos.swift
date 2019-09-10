//
//  MovieVideos.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 09/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import Foundation

struct MovieVideos: Decodable {
    let id: Int
    let results: [MovieVideo]
}
