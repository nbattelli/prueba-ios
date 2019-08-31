//
//  MovieListPresenter.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 31/08/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import Foundation

final class MovieListPresenter {
    weak var view: MovieListViewInterface!
    var interactor: MovieListInteractorInterface!
    var viewModel: [Movie]?
    
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
        self.interactor.fetchMovie(category: category, page: 1)
    }
    
    func movieFetchedSuccess(_ movie: [Movie]) {
        self.viewModel = movie
        self.view.update()
    }
    
    func movieFetchedFail(_ error: String) {
        
    }
}
