//
//  test_news_tableview_cell.swift
//  iOS_assignmentTests
//
//  Created by Yasir Khan on 02/02/2025.
//

import XCTest
@testable import iOSAssignment

class test_news_tableview_cell: XCTestCase {

    var cell: NewsTableViewCell!

    override func setUp() {
        super.setUp()
        cell = loadViewFromNib()
    }

    override func tearDown() {
        cell = nil
        super.tearDown()
    }

    func testUpdateNewsCell() {
        let news = NewsResult.loadDummyData()
        cell.updateNewsCell(news: news)
        
        XCTAssertEqual(cell.newsHeadLineLabel.text, "test")
        XCTAssertEqual(cell.newsReportedByLabel.text, "test")
        XCTAssertEqual(cell.newsSourceLabel.text, news.source.rawValue)
        XCTAssertEqual(cell.newsPublishDateLabel.text, "test")
    }
    
    func testSetSelected() {
        cell.setSelected(false, animated: true)
    }
}

extension XCTestCase {
    func loadViewFromNib<T: UIView>() -> T {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: String(describing: T.self), bundle: bundle)
        let views = nib.instantiate(withOwner: nil, options: nil)
        return views.first as! T
    }
}
