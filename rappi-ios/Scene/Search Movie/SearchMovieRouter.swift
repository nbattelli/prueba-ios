//
//  SearchMovieRouter.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 07/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

final class SearchMovieRouter {
    weak var parentRouter: MovieListRouterInterface!
    
    func buildSearchMovieViewController(router: SearchMovieRouter) -> UIViewController {
        let vc = SearchMovieTableViewController(router: router)
        return vc
    }
    
    func movieCellWasTapped(_ cell: CellTransitionViewProtocol, model: BaseMovieProtocol) {
        self.parentRouter.movieCellWasTapped(cell, model: model)
    }
}
