//
//  ReactiveHttpClientTest.swift
//  ReactiveCocoaPlaygroundTests
//
//  Created by Brian Chung on 24/3/2018.
//  Copyright © 2018 9GAG. All rights reserved.
//

import XCTest
import Nimble
import ReactiveSwift
import Result
@testable import ReactiveCocoaPlayground

class ReactiveHttpClientTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReactiveHttpClient() {
		let requestUrl = URL(string: "https://httpstat.us/404")!

		waitUntil(timeout: 5, action: { done in
			ReactiveHTTPClient.shared.request(method: .get, url: requestUrl).startWithResult { result in
				switch result {
				case .success(_, _):
					fail("Result should not fall into success case")
					/*
					expect(result).notTo(beNil())
					expect(headers).notTo(beNil())*/
				case .failure(let responseError):
					if case .invalidStatusCode(let code) = responseError.errorType {
						expect(code) == 404
					} else {
						fail("Response status code is not 404")
					}
				}
				done()
			}
		})
    }
}
