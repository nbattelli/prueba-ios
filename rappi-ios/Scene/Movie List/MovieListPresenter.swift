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
    
    var models: [MoviesCategory: Movies] = [:] {
        didSet {
            self.filteredModels = models
        }
    }
    
    var filteredModels: [MoviesCategory: Movies] = [:]
    var isFiltering: [MoviesCategory: Bool] = [:]
    
    init(_ router: MovieListRouterInterface, interactor: MovieListInteractorInterface) {
        self.router = router
        self.interactor = interactor
        self.interactor.presenterDelegate = self
    }
    
    private func fetchMovie(category: MoviesCategory, page: Int) {
        if self.models[category]?.results.count ?? 0 == 0 {
            self.viewDelegate.showLoading()
        }
        self.interactor.fetchMovie(category: self.currentCategory, page: page)
    }
}

extension MovieListPresenter: MovieListPresenterInterface {
    
    func viewDidLoad() {
        if models[self.currentCategory] == nil {
            self.reloadCurrentCategory()
        }
    }
    
    func reloadCurrentCategory() {
        self.fetchMovie(category: self.currentCategory, page: 1)
    }
    
    func categoryDidChange(_ category: MoviesCategory) {
        guard self.currentCategory != category else {return}
        self.currentCategory = category
        if models[category] == nil {
            self.fetchMovie(category: category, page: 1)
        }
    }
    
    func movieFetchedSuccess(_ movies: Movies, category: MoviesCategory) {
        self.viewDelegate.hideLoading()
        
        let newMoviews = movies.results
        if self.models[category] == nil || movies.currentPage == 1 {
            self.models[category] = movies
        } else {
            self.models[category]?.results.append(contentsOf: newMoviews)
        }
        
        MovieRepository.saveMoviesToDisk(category: category,
                                         movies: self.models[category]?.results)
        
        self.models[category]?.currentPage = movies.currentPage
        
        let startIndex = self.models[category]!.results.count - newMoviews.count
        if startIndex > 0 {
            let endIndex = startIndex + newMoviews.count
            let indexes = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
            
            if self.models[category]?.hasMorePages ?? false {
                self.viewDelegate.updateMoviesSection(at:indexes, category: category)
            } else {
                self.viewDelegate.updateMoviesSection(at: indexes, removeSection: loadingSection, category: category)
            }
        } else {
            self.viewDelegate.update(category: category)
        }
    }
    
    func movieFetchedFail(_ error: String, category: MoviesCategory) {
        
    }
    
    func numberOfSections(category: MoviesCategory) -> Int {
        guard let viewModel = self.filteredModels[category] else { return 0 }
        if self.isFiltering[category] ?? false {
            return 1
        }
        return viewModel.hasMorePages ? 2 : 1
    }
    
    func numberOfCell(in section: Int, category: MoviesCategory) -> Int {
        if section == 0  {
            return self.filteredModels[category]?.results.count ?? 0
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }
    
    func cellConfigurator(at indexPath: IndexPath, category: MoviesCategory) -> CellConfigurator {
        if indexPath.section == 0,
            let movie = self.filteredModels[category]?.results[indexPath.row] {
            
            let viewModel = MovieListCellViewModel.init(title: movie.title,
                                                        movieDescription: movie.overview,
                                                        posterPath: movie.posterPath)
            return TableCellConfigurator<MovieListTableViewCell, MovieListCellViewModel>(item: viewModel)
        } else {
            self.fetchMovie(category: category, page: self.filteredModels[category]?.nextPage ?? 1)
            return TableCellConfigurator<LoadingTableViewCell, String>(item: "Cargando")
        }
    }
    
    func cellWasTapped(_ cell: CellTransitionViewProtocol,
                       at indexPath: IndexPath,
                       category: MoviesCategory) {
        guard let model = self.filteredModels[category]?.results[indexPath.row] else {return}
        self.router.movieCellWasTapped(cell, model: model)
    }
    
    func filterMovies(_ filter: String) {
        self.isFiltering[currentCategory] = filter.count > 0
        
        let originalMovies = self.models[self.currentCategory]?.results
        if self.isFiltering[currentCategory] ?? false {
            guard let movies = originalMovies else { return }
            let filter = filter.lowercased()
            self.filteredModels[self.currentCategory]?.results = movies.filter({ (movie) -> Bool in
                let filterInTitle = movie.title.lowercased().contains(filter)
                let filterInOverview = movie.overview?.lowercased().contains(filter) ?? false
                return filterInTitle || filterInOverview
            })
        } else {
            self.filteredModels[self.currentCategory]?.results = originalMovies ?? []
        }
        
        
        
        self.viewDelegate.update(category: self.currentCategory)
    }
}


