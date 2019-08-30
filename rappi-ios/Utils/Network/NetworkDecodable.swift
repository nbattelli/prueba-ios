//
//  NetworkDecodable.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 29/08/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import Foundation

typealias JSON = [AnyHashable: Any]

protocol NetworkDecodable {
    init?(dictionary: JSON?)
}
