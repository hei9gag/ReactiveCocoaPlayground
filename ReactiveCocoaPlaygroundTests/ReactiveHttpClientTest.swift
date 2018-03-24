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

	let timeoutInterval: TimeInterval = 10

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInvalidStatusCodeUrlRequest() {
		let request404Url = URL(string: "https://httpstat.us/404")!

		waitUntil(timeout: self.timeoutInterval, action: { done in
			ReactiveHTTPClient.shared.request(method: .get, url: request404Url).startWithResult { result in
				switch result {
				case .success(_, _):
					fail("Result should not fall into success case")
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

		let request500Url = URL(string: "https://httpstat.us/500")!
		waitUntil(timeout: self.timeoutInterval, action: { done in
			ReactiveHTTPClient.shared.request(method: .get, url: request500Url).startWithResult { result in
				switch result {
				case .success(_, _):
					fail("Result should not fall into success case")
				case .failure(let responseError):
					if case .invalidStatusCode(let code) = responseError.errorType {
						expect(code) == 500
					} else {
						fail("Response status code is not 500")
					}
				}
				done()
			}
		})
    }

	func testJsonUrlRequest() {
		let requestUrl = URL(string: "https://dog.ceo/api/breeds/list/all")!

		waitUntil(timeout: self.timeoutInterval, action: { done in
			ReactiveHTTPClient.shared.request(method: .get, url: requestUrl).startWithResult { result in
				switch result {
				case .success(let result, let headers):
					expect(result).notTo(beNil())
					expect(headers).notTo(beNil())
				case .failure(_):
					fail("Response should fall into success case")
				}
				done()
			}
		})
	}

	func testInvalidUrl() {
		let requestUrl = URL(string: "https://www.pk1234567.com")!

		waitUntil(timeout: self.timeoutInterval, action: { done in
			ReactiveHTTPClient.shared.request(method: .get, url: requestUrl).startWithResult { result in
				switch result {
				case .success(_, _):
					fail("Result should not fall into success case")
				case .failure(let responseError):
					if case .urlError(let urlError) = responseError.errorType {
						expect(urlError.errorCode) == -1200
					} else {
						fail("Expect UrlError returns code -1200")
					}
				}
				done()
			}
		})
	}
}
