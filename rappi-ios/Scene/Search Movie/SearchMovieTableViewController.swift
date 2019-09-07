//
//  SearchMovieTableViewController.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 07/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

class SearchMovieTableViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let viewModel = SearchMovieViewModel()
    
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
}

extension SearchMovieTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.query = searchText
        self.viewModel.searchMovies()
    }
}
