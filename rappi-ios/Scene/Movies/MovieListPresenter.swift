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
    
    var models: [MoviesCategory: Movies] = [:]
    var currentCategory: MoviesCategory = defaultMoviesCategory
    private var currentModel: Movies? {
        return self.models[currentCategory]
    }
    
    
    init(_ interactor: MovieListInteractorInterface? = MovieListInteractor()) {
        self.interactor = interactor
        self.interactor.presenter = self
    }
}

extension MovieListPresenter: MovieListPresenterInterface {
    func viewDidLoad() {
        self.categoryDidChange(defaultMoviesCategory)
    }
    
    func categoryDidChange(_ category: MoviesCategory) {
        self.currentCategory = category
        if self.currentModel == nil {
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
        self.view.updateMoviesSection(at:indexes)
    }
    
    func movieFetchedFail(_ error: String, category: MoviesCategory) {
        
    }
    
    func numberOfSections() -> Int {
        guard let viewModel = self.currentModel else {return 0}
        return viewModel.hasMorePages ? 2 : 1
    }
    
    func numberOfCell(in section: Int) -> Int {
        if section == 0  {
            return self.currentModel?.results.count ?? 0
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }
    
    func cellConfigurator(at indexPath: IndexPath) -> CellConfigurator {
        
        if indexPath.section == 0,
            let movie = self.currentModel?.results[indexPath.row] {

            let viewModel = MovieListCellViewModel.init(title: movie.title,
                                                        movieDescription: movie.overview,
                                                        imagePath: movie.posterPath)
            return TableCellConfigurator<MovieListTableViewCell, MovieListCellViewModel>(item: viewModel)
        } else {
            self.interactor.fetchMovie(category: self.currentCategory, page: self.currentModel?.nextPage ?? 0)
            return TableCellConfigurator<LoadingTableViewCell, String>(item: "Cargando")
        }
    }
    
    func cellWasTapped(at indexPath: IndexPath) {
        print("\(self.currentModel!.results[indexPath.row])")
    }
}

