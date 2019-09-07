//
//  SearchMovieTableViewController.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 07/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

class SearchMovieTableViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            self.searchBar.tintColor = UIColor.secondaryColor
            self.searchBar.barTintColor = UIColor.primaryColor
            self.searchBar.returnKeyType = .done
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    let router: SearchMovieRouter
    let viewModel = SearchMovieViewModel()
    
    var timer: Timer?
    
    required init(router: SearchMovieRouter) {
        self.router = router
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.setupTableView()
    }
    
    func bindViewModel() {
        self.viewModel.update = {
            self.tableView.reloadData()
        }
    }
    
    func setupTableView() {
        self.tableView.backgroundColor = UIColor.primaryDarkColor
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 136
        self.tableView.separatorStyle = .none
        
        let registerCells = [SearchMovieTableViewCell.self, SearchErrorTableViewCell.self]
        
        registerCells.forEach {
            let nibName = String(describing: $0)
            let nib = UINib(nibName: nibName, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: nibName)
        }
    }
}

extension SearchMovieTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRow(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let configurator = self.viewModel.cellConfigurator(at: indexPath)
        let identifier = configurator.reuseId
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        configurator.configure(cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CellTransitionViewProtocol else {return}
        let model = self.viewModel.movie(at: indexPath)
        self.router.movieCellWasTapped(cell, model: model)
    }
}

extension SearchMovieTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
            self.viewModel.searchMovies()
        })
        
        self.viewModel.query = searchText
    }
}
