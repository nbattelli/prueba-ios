//
//  MovieListViewController.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 30/08/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTabs

final class MovieListViewController: UIViewController {
    
    @IBOutlet weak var tabBar: UIView! {
        didSet {
            let tabBar = MDCTabBar.buildCustomTabBar(frame: self.tabBar.bounds, delegate: self)
            tabBar.items = [
                UITabBarItem(title: "Top", image: nil, tag: 0),
                UITabBarItem(title: "Popular", image: nil, tag: 1),
                UITabBarItem(title: "Nuevo", image: nil, tag: 2)
            ]
            self.tabBar.addSubview(tabBar)
        }
    }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

extension MovieListViewController: MDCTabBarDelegate {
    func tabBar(_ tabBar: MDCTabBar, willSelect item: UITabBarItem) {
        let index = tabBar.items.firstIndex(of: item) ?? 0
        let category = MoviesCategory(rawValue: index) ?? defaultMoviesCategory
        self.presenter.categoryDidChange(category)
    }
}