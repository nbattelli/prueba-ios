//
//  MovieListViewController.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 30/08/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

final class MovieListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.rowHeight = UITableView.automaticDimension
            let nibName = String(describing: MovieListTableViewCell.self)
            let nib = UINib(nibName: nibName, bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: nibName)
        }
    }
    
    var presenter: MovieListPresenterInterface!
    
    // MARK: - Initializers
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required public init(_ presenter: MovieListPresenterInterface? = MovieListPresenter()) {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
        self.presenter = presenter
        self.presenter.view = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "Peliculas"
        self.presenter.viewDidLoad()
    }
}

extension MovieListViewController: MovieListViewInterface {
    func update() {
        self.tableView.reloadData()
    }
    
    func showError(_ error: String) {
        print("show error \(error)")
    }
    
    func hideError() {
        print("hide error")
    }
    
    func showLoading(message: String) {
        print("show loading \(message)")
    }
    
    func hideLoading() {
        print("hide loading")
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter?.viewModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: MovieListTableViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MovieListTableViewCell
        cell.titleLabel.text = self.presenter?.viewModel?[indexPath.row].title ?? "default"
        return cell
    }
    
    
}
