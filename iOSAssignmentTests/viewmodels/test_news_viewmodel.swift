//
//  test_news_viewmodel.swift
//  iOS_assignmentTests
//
//  Created by Yasir Khan on 02/02/2025.
//

import XCTest
import Combine
@testable import iOSAssignment

class test_news_viewmodel: XCTestCase {
    
     var viewModel: NewsViewModel!
     var mockNetworkService: MockNetworkService!
     var cancellables: Set<AnyCancellable>!

     override func setUp() {
         super.setUp()
         mockNetworkService = MockNetworkService()
         viewModel = NewsViewModel(networkService: mockNetworkService)
         cancellables = []
     }
     
     override func tearDown() {
         viewModel = nil
         mockNetworkService = nil
         cancellables = nil
         super.tearDown()
     }
     
     func testFetchNewsFromLocalStorage() {
         let expectation = XCTestExpectation(description: "Fetch news from local storage")
         
         viewModel.output.newsDataSource
             .dropFirst()
             .sink { newsData in
                 XCTAssertNotNil(newsData)
                 expectation.fulfill()
             }
             .store(in: &cancellables)
         
         viewModel.fetchNewsFromLocalStorage()
         wait(for: [expectation], timeout: 1.0)
     }
     
    func testLoadNewsFromAPISuccess() {
        let expectation = XCTestExpectation(description: "News data loaded successfully")
        
        let mockNews = [NewsResult.loadDummyData()]
        mockNetworkService.mockResult = .success(NewsModel(status: "", copyright: "", numResults: 10, results: mockNews))
        
        viewModel.newsDataSource
            .dropFirst()
            .sink { data in
                XCTAssertEqual(data?.count, 1)
                XCTAssertEqual(data?.first?.title, mockNews.first?.title)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.loadNewsFromAPI()
        
        wait(for: [expectation], timeout: 2.0)
    }

    func testLoadNewsFromAPIFailure() {
        let expectation = XCTestExpectation(description: "Error received on API failure")
        
        mockNetworkService.mockResult = .failure(NetworkError(message: .apiError))
        
        viewModel.error
            .sink { error in
                XCTAssertEqual(error.message, NetworkError(message: .apiError).message)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.loadNewsFromAPI()
        
        wait(for: [expectation], timeout: 1.0)
    }

     
     func testLoadingState() {
         let expectation = XCTestExpectation(description: "Verify loading state")
         
         var loadingStates: [Bool] = []
         viewModel.output.loading
             .sink { loading in
                 loadingStates.append(loading)
                 if loadingStates.count == 2 {
                     XCTAssertEqual(loadingStates, [false, true])
                     expectation.fulfill()
                 }
             }
             .store(in: &cancellables)
         
         viewModel.loadNewsFromAPI()
         wait(for: [expectation], timeout: 1.0)
     }
 }

 // MARK: - Mock NetworkService
class MockNetworkService: NetworkService {
    var mockResult: Result<NewsModel, NetworkError>?

    func getRequest<Request>(_ request: Request) -> AnyPublisher<Request.Response, NetworkError> where Request: DataRequest {
        return Future { promise in
            if let result = self.mockResult {
                switch result {
                case .success(let data):
                    promise(.success(data as! Request.Response))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
