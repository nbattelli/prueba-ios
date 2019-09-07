//
//  MovieListPresenter.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 31/08/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

let moviesSection = 0
let loadingSection = 1

final class MovieListPresenter {
    let router: MovieListRouterInterface!
    weak var viewDelegate: MovieListViewInterface!
    let interactor: MovieListInteractorInterface!
    
    var currentCategory: MoviesCategory = MoviesCategory.defaultMoviesCategory
    
    var viewModel: [MoviesCategory: MovieListViewModelInterface] {
        return self.interactor.viewModel
    }
    
    init(_ router: MovieListRouterInterface, interactor: MovieListInteractor) {
        self.router = router
        self.interactor = interactor
        self.interactor.presenterDelegate = self
    }
    
    private func fetchMovie(category: MoviesCategory, page: Int) {
        self.viewDelegate.hideError()
        if self.viewModel[category]?.hasMovies() ?? false {
            self.viewDelegate.showLoading()
        }
        self.interactor.fetchMovie(category: self.currentCategory, page: page)
    }
}

extension MovieListPresenter: MovieListPresenterInterface {
    
    func viewDidLoad() {
        if self.viewModel[self.currentCategory] == nil {
            self.reloadCurrentCategory()
        }
    }
    
    func reloadCurrentCategory() {
        if self.viewModel[self.currentCategory] == nil {
            self.fetchMovie(category: self.currentCategory, page: 1)
        }
        
    }
    
    func categoryDidChange(_ category: MoviesCategory) {
        guard self.currentCategory != category else {return}
        self.currentCategory = category
        self.reloadCurrentCategory()
    }
    
    func movieFetchedSuccess(_ indexes: [Int], category: MoviesCategory) {
        self.viewDelegate.hideLoading()
        
        let newIndexPath = indexes.map { (row) in
            return IndexPath(row: row,
                             section: moviesSection)
        }
        
        guard newIndexPath.count > 0 else {
            self.viewDelegate.update(category: category)
            return
        }
        if self.viewModel[category]?.isFromCache ?? false {
            self.viewDelegate.update(category: category)
        } else if self.viewModel[category]?.hasMorePages ?? false {
            self.viewDelegate.updateMoviesSection(at:newIndexPath, category: category)
        } else {
            self.viewDelegate.updateMoviesSection(at: newIndexPath, removeSection: loadingSection, category: category)
        }
        
        if self.viewModel[category]?.isFromCache ?? false {
            self.viewDelegate.showError("Peliculas cachedas", buttonTitle: "Refrescar") { [weak self] in
                self?.fetchMovie(category: category,
                                 page: 1)
            }
        }
    }
    
    func movieFetchedFail(_ error: String, category: MoviesCategory) {
        self.viewDelegate.hideLoading()
        self.viewDelegate.showError(error, buttonTitle: "Reintentar") { [weak self] in
            self?.fetchMovie(category: category,
                             page: self?.viewModel[category]?.nextPage ?? 1)
        }
    }
    
    func numberOfSections(category: MoviesCategory) -> Int {
        guard let viewModel = self.viewModel[category] else { return 0 }
        if self.viewModel[category]?.isFiltering ?? false ||
            self.viewModel[category]?.isFromCache ?? false {
            return 1
        }
        return viewModel.hasMorePages ? 2 : 1
    }
    
    func numberOfCell(in section: Int, category: MoviesCategory) -> Int {
        if section == 0  {
            return self.viewModel[category]?.moviesToShow.count ?? 0
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }
    
    func cellConfigurator(at indexPath: IndexPath, category: MoviesCategory) -> CellConfigurator {
        if indexPath.section == 0,
            let movie = self.viewModel[category]?.moviesToShow[indexPath.row] {
            
            return TableCellConfigurator<MovieListTableViewCell, MovieViewModel>(item: movie)
        } else {
            self.fetchMovie(category: category, page: self.viewModel[category]?.nextPage ?? 1)
            return TableCellConfigurator<LoadingTableViewCell, String>(item: "Cargando")
        }
    }
    
    func cellWasTapped(_ cell: CellTransitionViewProtocol,
                       at indexPath: IndexPath,
                       category: MoviesCategory) {
        guard let model = self.viewModel[category]?.moviesToShow[indexPath.row] else {return}
        self.router.movieCellWasTapped(cell, model: model)
    }
    
    func filterMovies(_ query: String) {
        self.viewModel[currentCategory]?.filter(query: query)
        self.viewDelegate.update(category: self.currentCategory)
    }
}


