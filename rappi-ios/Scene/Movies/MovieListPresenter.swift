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
    weak var view: MovieListViewInterface!
    var interactor: MovieListInteractorInterface!
    
    var currentCategory: MoviesCategory = MoviesCategory.defaultMoviesCategory
    
    var models: [MoviesCategory: Movies] = [:] {
        didSet {
            self.filteredModels = models
        }
    }
    var filteredModels: [MoviesCategory: Movies] = [:]
    var isFiltering: [MoviesCategory: Bool] = [:]
    
    init(_ interactor: MovieListInteractorInterface? = MovieListInteractor()) {
        self.interactor = interactor
        self.interactor.presenter = self
    }
}

extension MovieListPresenter: MovieListPresenterInterface {
    func viewDidLoad() {
        self.categoryDidChange(MoviesCategory.defaultMoviesCategory)
    }
    
    func categoryDidChange(_ category: MoviesCategory) {
        self.currentCategory = category
        if models[category] == nil {
            self.interactor.fetchMovie(category: category, page: 1)
        }
    }
    
    func movieFetchedSuccess(_ movies: Movies, category: MoviesCategory) {
        guard var model = self.models[category] else {
            self.models[category] = movies
            self.view.update()
            return
        }
        
        let newMoviews = movies.results
        model.results.append(contentsOf: newMoviews)
        model.currentPage = movies.currentPage
        self.models[category] = model
        
        let startIndex = model.results.count - newMoviews.count
        let endIndex = startIndex + newMoviews.count
        let indexes = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
        
        if model.hasMorePages {
            self.view.updateMoviesSection(at:indexes, category: category)
        } else {
            self.view.updateMoviesSection(at: indexes, removeSection: loadingSection, category: category)
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
                                                        imagePath: movie.posterPath)
            return TableCellConfigurator<MovieListTableViewCell, MovieListCellViewModel>(item: viewModel)
        } else {
            self.interactor.fetchMovie(category: category, page: self.filteredModels[category]?.nextPage ?? 0)
            return TableCellConfigurator<LoadingTableViewCell, String>(item: "Cargando")
        }
    }
    
    func cellWasTapped(at indexPath: IndexPath, category: MoviesCategory) {
        print("\(self.filteredModels[category]!.results[indexPath.row])")
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
        
        
        
        self.view.update()
    }
}

