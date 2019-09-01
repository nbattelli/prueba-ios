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
        if model == nil {
            self.model = movies
        } else {
            self.model?.results.append(contentsOf: movies.results)
            self.model?.currentPage = movies.currentPage
        }
        self.view.update()
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

            let urlString = "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "default")"

            let viewModel = MovieListCellViewModel.init(title: movie.title,
                                                        movieDescription: movie.overview,
                                                        imageURL: URL(string: urlString)!)
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

