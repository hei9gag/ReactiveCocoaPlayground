//
//  ReactiveHttpClientSpec.swift
//  ReactiveCocoaPlaygroundTests
//
//  Created by Brian Chung on 24/3/2018.
//  Copyright © 2018 9GAG. All rights reserved.
//

import Quick
import Nimble
import UIKit
@testable import ReactiveCocoaPlayground

class ReactiveHttpClientSpec: QuickSpec {

	override func spec() {

		describe("A Vehicle") {

			let requestUrl = URL(string: "https://dog.ceo/api/breeds/list/all")!

			context("After being properly initialized as a Car") {
				it("should response success and return data in JSON") {
					waitUntil(timeout: 5, action: { done in
						ReactiveHTTPClient.shared.request(method: .get, url: requestUrl).startWithResult { result in
							switch result {
							case .success(let result, let headers):
								expect(result).notTo(beNil())
								expect(headers).notTo(beNil())
								done()
							case .failure(let responseError):								
								fail("Request fail error description:\(responseError.description)")
							}
						}
					})
				}
			}
		}
	}
}
