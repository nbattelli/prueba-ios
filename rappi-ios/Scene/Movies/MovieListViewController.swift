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
            self.tabBar.addSubview(tabBar)
            tabBar.items = [
                UITabBarItem(title: "Top", image: nil, tag: 0),
                UITabBarItem(title: "Popular", image: nil, tag: 1),
                UITabBarItem(title: "Nuevo", image: nil, tag: 2)
            ]
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.backgroundColor = UIColor.primaryLightColor
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.estimatedRowHeight = UITableView.automaticDimension
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.contentInset = UIEdgeInsets(top: 8,
                                                       left: 0,
                                                       bottom: 0,
                                                       right: 0)
            
            let registerCells = [MovieListTableViewCell.self, LoadingTableViewCell.self]
            
            registerCells.forEach {
                let nibName = String(describing: $0)
                let nib = UINib(nibName: nibName, bundle: nil)
                self.tableView.register(nib, forCellReuseIdentifier: nibName)
            }
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
    
    func updateMoviesSection(at indexPats:[IndexPath]) {
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: indexPats, with: .left)
        self.tableView.endUpdates()
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.presenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.numberOfCell(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let configurator = self.presenter.cellConfigurator(at: indexPath)
        let identifier = configurator.reuseId
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        configurator.configure(cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.cellWasTapped(at: indexPath)
    }
}

extension MovieListViewController: MDCTabBarDelegate {
    func tabBar(_ tabBar: MDCTabBar, willSelect item: UITabBarItem) {
        let index = tabBar.items.firstIndex(of: item) ?? 0
        let category = MoviesCategory(rawValue: index) ?? defaultMoviesCategory
        self.presenter.categoryDidChange(category)
    }
}
