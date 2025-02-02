//
//  test_networking.swift
//  iOS_assignmentTests
//
//  Created by Yasir Khan on 02/02/2025.
//

import Foundation
import XCTest
import Combine
@testable import iOSAssignment

class NetworkServiceTests: XCTestCase {

    var networkManager: NetworkManager!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        networkManager = NetworkManager()
        cancellables = []
    }

    override func tearDown() {
        networkManager = nil
        cancellables = nil
        super.tearDown()
    }

    // Test for the `postRequest` method failure
    func testPostRequestFailure() {
        let mockRequest = MockRequest()
        let expectation = XCTestExpectation(description: "Post request fails with invalid endpoint")
        
        networkManager.postRequest(mockRequest)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    // Assert that we get the invalidEndpoint error
                    XCTAssertEqual(error.message, .invalidEndpoint)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected to fail with invalid endpoint error")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }

    // Test for the `getRequest` method when URL is invalid
    func testGetRequestFailureInvalidURL() {
        let mockRequest = MockRequest(url: "")
        
        let expectation = XCTestExpectation(description: "Invalid URL error")
        
        networkManager.getRequest(mockRequest)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    // Assert that we get the invalidEndpoint error
                    XCTAssertEqual(error.message, .invalidEndpoint)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected to fail with invalid URL error")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }

    // Test for the `getRequest` method when data decoding is successful
    func testGetRequestSuccess() {
        let mockRequest = MockRequest(url: "https://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/")
        
        let expectation = XCTestExpectation(description: "Successful response with decoded data")
        networkManager.getRequest(mockRequest)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success, but received error: \(error)")
                }
            }, receiveValue: { response in
                // Assert that the response is correctly decoded
                XCTAssertEqual(response.results.count, 1)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10.0)
    }
}

// Mock request to simulate network requests
struct MockRequest: DataRequest {
    var url: String = ""
    var method: HTTPMethod = .get
    var headers: [String: String] = [:]
    var queryItems: [String: String] = [:]

    // Decode method to simulate a successful or failed response
    func decode(_ data: Data) throws -> MockResponse {
        return MockResponse(results: [NewsResult.loadDummyData()])
    }
}

// Mock response to simulate a real network response
struct MockResponse: Decodable {
    let results: [NewsResult]
}

