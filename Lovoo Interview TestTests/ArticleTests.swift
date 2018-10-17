//
//  ArticleTests.swift
//  Lovoo Interview TestTests
//
//  Created by Adrián Silva on 12/10/2018.
//  Copyright © 2018 Adrián Silva. All rights reserved.
//

import XCTest

@testable import Lovoo_Interview_Test

class ArticleTests: XCTestCase {

    var article: Article!

    override func setUp() {
        article = Article(source: [:])
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testArticleExistence() {
        XCTAssertNotNil(article)
    }

}
