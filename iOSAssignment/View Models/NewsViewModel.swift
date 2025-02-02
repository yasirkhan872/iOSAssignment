//
//  NewsViewModel.swift
//  iOS_assignment
//
//  Created by Yasir Khan on 02/02/2025.
//

import Foundation
import Combine

// MARK: - Input Protocol (Commands sent from View to ViewModel)
protocol NewsViewModelInput {
    func loadNewsFromAPI(for days: Int)
}

// MARK: - Output Protocol (Information provided to the View)
protocol NewsViewModelOutput {
    var loading: Published<Bool>.Publisher { get }
    var error: AnyPublisher<NetworkError, Never> { get }
    var newsDataSource: Published<[NewsResult]?>.Publisher { get }
    
    func numberOfRows() -> Int
    func currentNewsItem(at index: Int) -> NewsResult?
}

// MARK: - ViewModelType Protocol
protocol NewsViewModelType {
    var input: NewsViewModelInput { get }
    var output: NewsViewModelOutput { get }
}

final class NewsViewModel: NewsViewModelType, NewsViewModelInput, NewsViewModelOutput {
    
    // MARK: - Input & Output Conformance
    var input: NewsViewModelInput { self }
    var output: NewsViewModelOutput { self }

    // MARK: - Published Properties for Data Binding
    @Published private var newsData: [NewsResult]? = []
    @Published private var isLoading: Bool = false
    private let errorSubject = PassthroughSubject<NetworkError, Never>()

    // MARK: - Combine Subscriptions
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkService

    // MARK: - Initializer
    init(networkService: NetworkService) {
        self.networkService = networkService
        observeInternetConnectionRestored()
    }

    // MARK: - Output Properties
    var loading: Published<Bool>.Publisher { $isLoading }
    var error: AnyPublisher<NetworkError, Never> { errorSubject.eraseToAnyPublisher() }
    var newsDataSource: Published<[NewsResult]?>.Publisher { $newsData }

    // MARK: - Number of Rows
    func numberOfRows() -> Int {
        return newsData?.count ?? 0
    }

    // MARK: - Current News Item
    func currentNewsItem(at index: Int) -> NewsResult? {
        return newsData?[index]
    }

    // MARK: - Fetch News Data
    func fetchNewsData(for days: Int = 7) {
        loadNewsFromAPI(for: days)
    }

    // MARK: - Load News from API
    func loadNewsFromAPI(for days: Int = 7) {
        isLoading = true
        networkService.getRequest(NewsRequest(days: days))
            .receive(on: DispatchQueue.main) // Ensure UI updates happen on the main thread
            .sink(receiveCompletion: handleAPICompletion, receiveValue: handleAPISuccess)
            .store(in: &cancellables)
    }

    private func handleAPICompletion(_ completion: Subscribers.Completion<NetworkError>) {
        isLoading = false
        if case .failure(let error) = completion {
            errorSubject.send(error)
        }
    }

    private func handleAPISuccess(data: NewsModel) {
        newsData = data.results
        saveNewsToLocalStorage(data.results)
    }

    private func saveNewsToLocalStorage(_ results: [NewsResult]) {
        LocalStorageManager.shared.saveNewsResults(results)
    }

    // MARK: - Fetch News from Local Storage
    func fetchNewsFromLocalStorage() {
        if let localData = LocalStorageManager.shared.loadNewsResults() {
            self.newsData = localData
        } else {
            errorSubject.send(.init(message: .invalidData))
        }
    }

    // MARK: - Internet Connection Observer
    private func observeInternetConnectionRestored() {
        NotificationCenter.default.publisher(for: .internetConnectionRestored)
            .sink { [weak self] _ in
                self?.loadNewsFromAPI(for: 7)
            }
            .store(in: &cancellables)
    }
}
