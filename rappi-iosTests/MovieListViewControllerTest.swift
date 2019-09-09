//
//  MovieListViewController.swift
//  rappi-iosTests
//
//  Created by Nicolas Battelli on 07/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import XCTest
@testable import rappi_ios

final class MovieListViewControllerTest: XCTestCase {
    
    private var viewModel: MovieListViewModelInterface {
        let movieList : [Movie] = [Movie(id: 1,
                                          title: "test1",
                                          overview: "test1 overview"),
                                    Movie(id: 2,
                                          title: "test2",
                                          overview: "test overview2")]
        let movies = Movies(movies: movieList)
        
        let viewModel = MovieListViewModel()
        _ = viewModel.updateMovies(movies)
        return viewModel
    }
    
    func testInitWithParams() {
        let presenter = MovieListPresenter(MovieListRouter(), interactor: MovieListInteractor())
        let vc = MovieListViewController(presenter)
        
        XCTAssert(vc.presenter === presenter)
    }
    
    func testShouldShowThreeCategories() {
        let presenter = MovieListPresenter(MovieListRouter(), interactor: MovieListInteractor())
        let vc = MovieListViewController(presenter)
        vc.loadViewIfNeeded()
        
        let tabBar = vc.tabBar.subviews.first as! TabBar
        XCTAssert(tabBar.items.count == 3)
    }
    
    func testShouldShowLoadingSection() {
        var topRatedMovies = self.viewModel
        topRatedMovies.currentPage = 1
        topRatedMovies.totalPages = 2
        
        let viewModel = [MoviesCategory.topRated: topRatedMovies];
        
        let interactorMock = MovieListInteractorMock(viewModel: viewModel)
        let presenter = MovieListPresenter(MovieListRouter(), interactor: interactorMock)
        
        let vc = MovieListViewController(presenter)
        vc.loadViewIfNeeded()
        XCTAssert(vc.numberOfSections(in: vc.tableViews[MoviesCategory.topRated]!) == 2)
        XCTAssert(vc.tableView(vc.tableViews[MoviesCategory.topRated]!, numberOfRowsInSection: 1) == 1)
    }
    
    func testShouldNowShowLoadingSection_NoMorePages() {
        var topRatedMovies = self.viewModel
        topRatedMovies.currentPage = 1
        topRatedMovies.totalPages = 1
        
        let viewModel = [MoviesCategory.topRated: topRatedMovies];
        
        let interactorMock = MovieListInteractorMock(viewModel: viewModel)
        let presenter = MovieListPresenter(MovieListRouter(), interactor: interactorMock)
        
        let vc = MovieListViewController(presenter)
        vc.loadViewIfNeeded()
        XCTAssert(vc.numberOfSections(in: vc.tableViews[MoviesCategory.topRated]!) == 1)
    }
    
    func testShouldNowShowLoadingSection_CachedMovies() {
        var topRatedMovies = self.viewModel
        topRatedMovies.currentPage = 1
        topRatedMovies.totalPages = 2
        topRatedMovies.isFromCache = true
        
        let viewModel = [MoviesCategory.topRated: topRatedMovies];
        
        let interactorMock = MovieListInteractorMock(viewModel: viewModel)
        let presenter = MovieListPresenter(MovieListRouter(), interactor: interactorMock)
        
        let vc = MovieListViewController(presenter)
        vc.loadViewIfNeeded()
        XCTAssert(vc.numberOfSections(in: vc.tableViews[MoviesCategory.topRated]!) == 1)
    }
    
    func testShouldNowShowLoadingSection_Filtering() {
        var topRatedMovies = self.viewModel
        topRatedMovies.currentPage = 1
        topRatedMovies.totalPages = 2
        
        let viewModel = [MoviesCategory.topRated: topRatedMovies];
        
        let interactorMock = MovieListInteractorMock(viewModel: viewModel)
        let presenter = MovieListPresenter(MovieListRouter(), interactor: interactorMock)
        
        let vc = MovieListViewController(presenter)
        vc.loadViewIfNeeded()
        vc.searchBar(UISearchBar(), textDidChange: "test")
        XCTAssert(vc.numberOfSections(in: vc.tableViews[MoviesCategory.topRated]!) == 1)
    }
}

final class MovieListInteractorMock: MovieListInteractorInterface {
    
    var viewModel: [MoviesCategory : MovieListViewModelInterface]
    var presenterDelegate: MovieListPresenterInterface!
    
    var fetchMovieThunk: (()->Void)?
    
    init(viewModel: [MoviesCategory : MovieListViewModelInterface]) {
        self.viewModel = viewModel
    }
    
    func fetchMovie(category: MoviesCategory, page: Int) {
        self.fetchMovieThunk?()
    }
}
