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
    var model: Movies?
    
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
        self.model = nil
        self.interactor.fetchMovie(category: category, page: 1)
    }
    
    func movieFetchedSuccess(_ movies: Movies) {
        guard let model = self.model else {
            self.model = movies
            self.view.update()
            return
        }
        
        let newMoviews = movies.results
        self.model?.results.append(contentsOf: newMoviews)
        self.model?.currentPage = movies.currentPage
        
        let startIndex = model.results.count - newMoviews.count
        let endIndex = startIndex + newMoviews.count
        let indexes = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
        self.view.updateMoviesSection(at:indexes)
    }
    
    func movieFetchedFail(_ error: String) {
        
    }
    
    func numberOfSections() -> Int {
        guard let viewModel = self.model else {return 1}
        return viewModel.hasMorePages ? 2 : 1
    }
    
    func numberOfCell(in section: Int) -> Int {
        if section == 0  {
            return self.model?.results.count ?? 0
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }
    
    func cellConfigurator(at indexPath: IndexPath) -> CellConfigurator {
        
        if indexPath.section == 0,
            let movie = self.model?.results[indexPath.row] {

            let viewModel = MovieListCellViewModel.init(title: movie.title,
                                                        movieDescription: movie.overview,
                                                        imagePath: movie.posterPath)
            return TableCellConfigurator<MovieListTableViewCell, MovieListCellViewModel>(item: viewModel)
        } else {
            self.interactor.fetchMovie(category: .topRated, page: self.model?.nextPage ?? 0)
            return TableCellConfigurator<LoadingTableViewCell, String>(item: "Cargando")
        }
    }
    
    func cellWasTapped(at indexPath: IndexPath) {
        print("\(self.model!.results[indexPath.row])")
    }
}

