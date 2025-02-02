//
//  test_news_listing_vc.swift
//  iOS_assignmentTests
//
//  Created by Yasir Khan on 02/02/2025.
//

import XCTest
@testable import iOSAssignment

class test_news_listing_vc: XCTestCase {

    var sut: NewsListingViewController!

    override func setUp() {
        super.setUp()
        sut = NewsListingViewController()
        sut.loadViewIfNeeded() // Load the view hierarchy
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testSetupNavigationBar() {
        sut.setupNavigationBar()
        // Assert navigation item title
        XCTAssertEqual(sut.navigationItem.title, "NY Times Most Popular")
        // Assert right bar button item exists
        XCTAssertNotNil(sut.navigationItem.rightBarButtonItem)
    }

    func testSetupActivityIndicator() {
        sut.setupActivityIndicator()
        // Assert activity indicator is not nil
        XCTAssertNotNil(sut.activityIndicator)
        // Assert activity indicator style
        XCTAssertEqual(sut.activityIndicator.style, .large)
    }

    func testShowAnimation() {
        sut.setupActivityIndicator()
        sut.showAnimation()
        // Assert activity indicator is animating
        XCTAssertTrue(sut.activityIndicator.isAnimating)
        // Assert activity indicator is not hidden
        XCTAssertFalse(sut.activityIndicator.isHidden)
    }

    func testHideAnimation() {
        sut.setupActivityIndicator()
        sut.hideAnimation()
        // Assert activity indicator is not animating
        XCTAssertFalse(sut.activityIndicator.isAnimating)
        // Assert activity indicator is hidden
        XCTAssertTrue(sut.activityIndicator.isHidden)
    }

    func testSetupTableView() {
        sut.setupTablView()
        // Assert table view data source and delegate are set
        XCTAssertNotNil(sut.tableView.dataSource)
        XCTAssertNotNil(sut.tableView.delegate)
        // Assert table view row height configuration
        XCTAssertEqual(sut.tableView.rowHeight, UITableView.automaticDimension)
        XCTAssertEqual(sut.tableView.estimatedRowHeight, UITableView.automaticDimension)
        // Assert table view separator style
        XCTAssertEqual(sut.tableView.separatorStyle, .none)
    }
}
