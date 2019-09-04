//
//  MovieListRouter.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 31/08/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

final class MovieListRouter: NSObject {
    var mainRouter: AppRouter!
    var navigationController: UINavigationController!
    
    var cellTransitionView: CellTransitionViewProtocol?
    var detailTransitionView: DetailTransitionViewProtocol?
}

extension MovieListRouter: MovieListRouterInterface {
    func buildMovieViewController() -> UIViewController {
        let interactor = MovieListInteractor()
        let presenter = MovieListPresenter(self, interactor: interactor)
        
        let vc = MovieListViewController(presenter)
        self.navigationController = UINavigationController(rootViewController: vc)
        self.navigationController.transitioningDelegate = self
        self.navigationController.delegate = self
        return self.navigationController
    }
    
    func movieCellWasTapped(_ cell: CellTransitionViewProtocol, model: Movie) {
        let vc = MovieDetailViewController()
        
        self.cellTransitionView = cell
        self.detailTransitionView = vc
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MovieListRouter: UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let cell = self.cellTransitionView,
            let detail = self.detailTransitionView else
        {return nil}
        switch operation {
        case .push:
            return CellTransition(isPresenting: true,
                                  cellTransitionView: cell,
                                  detailTransitionView: detail)
        case .pop:
            return CellTransition(isPresenting: false,
                                  cellTransitionView: cell,
                                  detailTransitionView: detail)
        case .none:
            return nil
        }
    }
}
