//
//  NetworkConfigurator.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 28/08/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String:String]
public typealias QueryParameters = [String:Any]

enum HttpMethod: String {
    case get
    case post
    case put
    case patch
    case delete
}

protocol NetworkConfiguration {
    var path: String {get}
    var httpMethod: HttpMethod { get }
    var additionalHeaders: HTTPHeaders? { get }
    var queryParameters: QueryParameters? { get }
}

extension NetworkConfiguration {
    var url: URL? {
        return URL(string: "")
    }
}

