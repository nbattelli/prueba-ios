//
//  BaseMovieProtocol.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 04/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import Foundation

protocol BaseMovieProtocol {
    var id: Int { get }
    var title: String { get }
    var posterPath: String? { get }
    var overview: String? { get }
    var voteAvarage: Double? { get }
}
