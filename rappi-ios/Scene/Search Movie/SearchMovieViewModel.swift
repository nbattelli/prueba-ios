//
//  SearchMovieViewModel.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 07/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

final class SearchMovieViewModel {
    
    var update: (()->Void)?
    var showLoading: (()->Void)?
    var stopLoading: (()->Void)?
    
    private var connector = NetworkConnector<MovieConfigurator, Movies>()
    private var movies: Movies?
    
    var query: String = ""
    private var noResult: Bool = false
    private var internetError: Bool = false
    private var initialSearch: Bool = true
    
    func searchMovies() {
        self.noResult = false
        self.internetError = false
        self.initialSearch = false
        
        if query.count < 3 {
            self.initialSearch = true
            self.movies = nil
            self.update?()
            return
        }
        
        self.connector.cancel()
        self.connector.request(MovieConfigurator.search(query: self.query)) { (result) in
            switch result {
            case .success(let model):
                self.handleSuccess(model)
            case .failure:
                self.internetError = true
                DispatchQueue.main.async { [weak self] in
                    self?.update?()
                }
            }
        }
        
    }
    
    private func handleSuccess(_ movies: Movies) {
        guard movies.results.count > 0 else {
            self.noResult = true
            DispatchQueue.main.async { [weak self] in
                self?.update?()
            }
            return
        }
        
        let newMovies = movies.results
        if self.movies == nil || movies.currentPage == 1 {
            self.movies = movies
        } else {
            self.movies?.results.append(contentsOf: newMovies)
        }
        DispatchQueue.main.async { [weak self] in
            self?.update?()
        }
    }

    
    func numberOfSection() -> Int {
        return 1
    }
    
    func numberOfRow(in section: Int) -> Int {
        if self.internetError == true || self.noResult == true || self.initialSearch == true {
            return 1
        } else {
            return self.movies?.results.count ?? 0
        }
    }
    
    func cellConfigurator(at indexPath: IndexPath) -> CellConfigurator {
        
        if self.internetError {
            return TableCellConfigurator<SearchErrorTableViewCell, String>(item: "No hay internet")
        } else if self.noResult {
            return TableCellConfigurator<SearchErrorTableViewCell, String>(item: "No hay resultados")
        } else if self.initialSearch {
            return TableCellConfigurator<SearchErrorTableViewCell, String>(item: "Ingresar 3 caracteres")
        } else {
            let movie = self.movies!.results[indexPath.row]
            let viewModel = SearchMovieTableViewCellModel(id: movie.id,
                                                          title: movie.title,
                                                          overview: movie.overview,
                                                          posterPath: movie.posterPath)
            return TableCellConfigurator<SearchMovieTableViewCell, SearchMovieTableViewCellModel>(item: viewModel)
        }
    }
    
    func movie(at indexPath: IndexPath) -> BaseMovieProtocol {
        let movie = self.movies!.results[indexPath.row]
        let viewModel = SearchMovieTableViewCellModel(id: movie.id,
                                                      title: movie.title,
                                                      overview: movie.overview,
                                                      posterPath: movie.posterPath)
        return viewModel
    }
}
