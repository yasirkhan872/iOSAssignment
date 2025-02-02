//
//  ArticleListingViewController.swift
//  iOS_assignment
//
//  Created by Yasir Khan on 02/02/2025.
//

import UIKit
import Combine

class NewsListingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView()
    var activityIndicator: UIActivityIndicatorView!
    let viewModel = NewsViewModel(networkService: NetworkManager())
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTablView()
        setupActivityIndicator()
        bindViewModel()
        viewModel.fetchNewsData()
    }
    
    func setupNavigationBar() {
        title = "NY Times Most Popular"
        navigationController?.navigationBar.addShadow()
        
        let menuHandler: UIActionHandler = {[weak self] action in
            guard let self = self else { return }
            var day : Int {
                if action.title == "1 Day" {
                    return 1
                } else if action.title == "7 Days" {
                    return 7
                } else {
                    return 30
                }
            }
            self.viewModel.loadNewsFromAPI(for: day)
        }
        
        let barButtonMenu = UIMenu(title: "", children: [
            UIAction(title: NSLocalizedString("1 Day", comment: ""), image: nil, handler: menuHandler),
            UIAction(title: NSLocalizedString("7 Days", comment: ""), image: nil, handler: menuHandler),
            UIAction(title: NSLocalizedString("30 Days", comment: ""), image: nil, handler: menuHandler)
        ])
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .action, menu: barButtonMenu)
    }
    
    // Create and configure the activity indicator
    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = UIColor.blue
        let centerX = view.bounds.midX
        let centerY = view.bounds.midY
        activityIndicator.frame = CGRect(x: centerX - 20, y: centerY - 20, width: 40, height: 40)
        view.addSubview(activityIndicator)
    }
    
    
    func showAnimation() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        view.bringSubviewToFront(activityIndicator)
    }
    
    func hideAnimation() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    // Set up table view
    func setupTablView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
    }
    
    private func bindViewModel() {
           // Bind newsDataSource to reload table view
           viewModel.output.newsDataSource
               .receive(on: DispatchQueue.main) // Ensure UI updates on main thread
               .sink { [weak self] _ in
                   self?.tableView.reloadData()
               }
               .store(in: &cancellables)
           
           // Bind loading state to show/hide animation
           viewModel.output.loading
               .receive(on: DispatchQueue.main)
               .sink { [weak self] isLoading in
                   guard let self = self else { return }
                   isLoading ? self.showAnimation() : self.hideAnimation()
               }
               .store(in: &cancellables)
           
           // Bind error state to show an alert and fetch local storage if needed
           viewModel.output.error
               .receive(on: DispatchQueue.main)
               .sink { [weak self] error in
                   guard let self = self else { return }
                   if !error.message.description.isEmpty {
                       self.alert(message: error.message.description)
                       if error.message == .internet {
                           self.viewModel.fetchNewsFromLocalStorage()
                       } else {
                           print("error: \(error)")
                       }
                   }
               }
               .store(in: &cancellables)
       }
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        if let newsItem = viewModel.currentNewsItem(at: indexPath.row) {
            cell.updateNewsCell(news: newsItem)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
        detailVC.urlString = viewModel.currentNewsItem(at: indexPath.row)?.url
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

