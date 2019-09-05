//
//  MovieConfiguration.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 29/08/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import Foundation

enum MovieConfigurator {
    case topRated(page:Int)
    case popular(page:Int)
    case upComing(page:Int)
    case detail(id:String)
}

extension MovieConfigurator: NetworkConfiguration {
    var path: String {
        switch self {
        case .topRated:
            return "movie/top_rated"
        case .popular:
            return "movie/popular"
        case .upComing:
            return "movie/upcoming"
        case .detail(let id):
            return "movie/\(id)"
        }
    }
    
    var httpMethod: HttpMethod {
        switch self {
        case .topRated, .popular, .upComing, .detail:
            return .get
        }
    }
    
    var additionalHeaders: HTTPHeaders? {
        return nil
    }
    
    var queryParameters: QueryParameters? {
        switch self {
        case .topRated(let page):
            return ["page": page]
        case .popular(let page):
            return ["page": page]
        case .upComing(let page):
            return ["page": page]
        case .detail:
            return nil
        }
    }
}
