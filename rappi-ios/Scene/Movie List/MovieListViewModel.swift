//
//  MovieListViewModel.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 07/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

protocol MovieListViewModelInterface: Paginable {
    var moviesToShow: [MovieViewModel]  {get}
    var isFiltering: Bool {get}
    var isFromCache: Bool {set get}
    func updateMovies(_ newMovies: Movies) -> [Int]
    func hasMovies() -> Bool
    func filter(query: String)
}

final class MovieListViewModel: MovieListViewModelInterface, Paginable, Codable {
    
    private var movies: [MovieViewModel] = [] {
        didSet {
            self.moviesToShow = movies
        }
    }
    var moviesToShow: [MovieViewModel] = []
    
    var currentPage: Int = 0
    var totalPages: Int = 0
    
    var isFiltering = false
    var isFromCache = false
    
    func updateMovies(_ newMovies: Movies) -> [Int] {
        
        let moviesViewModel = newMovies.results.map { (movie) in
            return MovieViewModel(id: movie.id,
                                  title: movie.title,
                                  overview: movie.overview,
                                  posterPath: movie.posterPath)
        }
        
        if self.movies.count == 0 || newMovies.currentPage == 1 {
            self.movies = moviesViewModel
        } else {
            self.movies.append(contentsOf: moviesViewModel)
        }
        
        self.currentPage = newMovies.currentPage
        self.totalPages = newMovies.totalPages
        
        var indexes = [Int]()
        let startIndex = self.movies.count - moviesViewModel.count
        if startIndex > 0 {
            let endIndex = startIndex + moviesViewModel.count
            indexes = (startIndex..<endIndex).map { $0 }
        }
        
        return indexes
    }
    
    func hasMovies() -> Bool {
        return self.movies.count > 0
    }
    
    func filter(query: String) {
        self.isFiltering = query.count > 0
        
        if self.isFiltering {
            let query = query.lowercased()
            self.moviesToShow = self.movies.filter({ (movie) -> Bool in
                let filterInTitle = movie.title.lowercased().contains(query)
                let filterInOverview = movie.overview?.lowercased().contains(query) ?? false
                return filterInTitle || filterInOverview
            })
        } else {
            self.moviesToShow = self.movies
        }
    }

}
