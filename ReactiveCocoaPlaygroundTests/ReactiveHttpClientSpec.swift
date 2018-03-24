//
//  ReactiveHttpClientSpec.swift
//  ReactiveCocoaPlaygroundTests
//
//  Created by Brian Chung on 24/3/2018.
//  Copyright © 2018 9GAG. All rights reserved.
//

import Quick
import Nimble
import ReactiveSwift
import Result
@testable import ReactiveCocoaPlayground

class ReactiveHttpClientSpec: QuickSpec {

	override func spec() {
		describe("Test ReactiveHttpClient") {

			context("Test different url request") {
				// let requestUrl = URL(string: "https://dog.ceo/api/breeds/list/all")!
				it("Response should return status code 404") {
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
		}
	}
}
