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
    
    var originalFrame:CGRect!
    var image: UIImage!
    var materialTabBar: TabBar!
    
    @IBOutlet weak var tabBar: UIView! {
        didSet {
            self.materialTabBar = TabBar(frame: self.tabBar.bounds, delegate: self)
            self.tabBar.addSubview(materialTabBar)
            let allCategories = MoviesCategory.allCases.sorted { $0.rawValue < $1.rawValue }
            materialTabBar.items = allCategories.enumerated().map {
                UITabBarItem(title: $1.description, image: nil, tag: $0)
            }
        }
    }
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    @IBOutlet weak var containerTableView: UIStackView!
    
    var tableViews: [MoviesCategory: UITableView]
    var refreshControls: [MoviesCategory: UIRefreshControl] = [:]
    
    var presenter: MovieListPresenterInterface!
    
    // MARK: - Initializers
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required public init(_ presenter: MovieListPresenterInterface) {
        self.tableViews = Dictionary(uniqueKeysWithValues: MoviesCategory.allCases.map {($0,UITableView())})
        self.presenter = presenter
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
        
        self.presenter.viewDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Peliculas"
        self.view.backgroundColor = UIColor.primaryColor
        self.configureTableView()
        self.presenter.viewDidLoad()
    }
    
    private func configureTableView() {
        let tableViews = self.tableViews.sorted {$0.key.rawValue < $1.key.rawValue}.map{$1}
        tableViews.enumerated().forEach { (index, tableView) in
            self.setupTableView(tableView)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            self.containerTableView.addArrangedSubview(tableView)
            tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
            tableView.heightAnchor.constraint(equalTo: self.containerTableView.heightAnchor).isActive = true
        }
    }
    
    private func setupTableView(_ tableView: UITableView) {
        tableView.backgroundColor = UIColor.primaryDarkColor
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 136
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        
        let registerCells = [MovieListTableViewCell.self, LoadingTableViewCell.self]
        
        registerCells.forEach {
            let nibName = String(describing: $0)
            let nib = UINib(nibName: nibName, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: nibName)
        }
        
        let header = SearchBarHeaderView.buildView()
        header.searchBar.delegate = self
        tableView.tableHeaderView = header

        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(sender:)), for: .valueChanged)
        let category = self.getCategory(for: tableView)!
        self.refreshControls[category] = refreshControl

    }
    
    @objc private func refreshData(sender: UIRefreshControl) {
        self.presenter.reloadCurrentCategory()
    }
    
    private func getCategory(for tableView: UITableView) -> MoviesCategory? {
        return self.tableViews.first(where: { (key, value) in
            return value == tableView
        })?.key
    }
}

extension MovieListViewController: MovieListViewInterface {
    func update(category: MoviesCategory) {
        self.tableViews[category]?.reloadData()
        self.refreshControls[category]?.endRefreshing()
    }
    
    func updateMoviesSection(at indexPaths:[IndexPath], category: MoviesCategory) {
        let tableView = self.tableViews[category]!
        tableView.beginUpdates()
        tableView.insertRows(at: indexPaths, with: .fade)
        tableView.endUpdates()
    }
    
    func updateMoviesSection(at indexPaths: [IndexPath], removeSection: Int, category: MoviesCategory) {
        let tableView = self.tableViews[category]!
        tableView.beginUpdates()
        tableView.deleteSections([removeSection], with: .automatic)
        tableView.insertRows(at: indexPaths, with: .automatic)
        tableView.endUpdates()
    }
    
    func showError(_ error: String) {
        print("show error \(error)")
    }
    
    func hideError() {
        print("hide error")
    }
    
    func showLoading() {
        self.tableViews[self.presenter.currentCategory]?.showAsLoading()
    }
    
    func hideLoading() {
        self.tableViews[self.presenter.currentCategory]?.stopLoading()
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.presenter.numberOfSections(category: self.getCategory(for: tableView)!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.numberOfCell(in: section, category: self.getCategory(for: tableView)!)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let configurator = self.presenter.cellConfigurator(at: indexPath,
                                                           category: self.getCategory(for: tableView)!)
        let identifier = configurator.reuseId
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        configurator.configure(cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CellTransitionViewProtocol else {return}
        self.presenter.cellWasTapped(cell, at: indexPath, category: self.getCategory(for: tableView)!)
    }
}

extension MovieListViewController: MDCTabBarDelegate {
    func tabBar(_ tabBar: MDCTabBar, willSelect item: UITabBarItem) {
        let index = tabBar.items.firstIndex(of: item) ?? 0
        
        let screenWidth = self.view.frame.size.width
        let rectToScroll = CGRect(x: screenWidth * CGFloat(index), y: 0, width: screenWidth, height: 1)
        self.scrollView.scrollRectToVisible(rectToScroll, animated: true)
    }
}

extension MovieListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.presenter.filterMovies(searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        self.presenter.filterMovies("")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        self.presenter.filterMovies("")
    }
}

extension MovieListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else {return}
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        
        let index = Int(pageNumber)
        let item = self.materialTabBar.items[index]
        self.materialTabBar.setSelectedItem(item, animated: true)
        
        let category = MoviesCategory(rawValue: index) ?? MoviesCategory.defaultMoviesCategory
        self.presenter.categoryDidChange(category)
    }
    
}
