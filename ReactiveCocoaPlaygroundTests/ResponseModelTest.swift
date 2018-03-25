//
//  ResponseModelTest.swift
//  ReactiveCocoaPlaygroundTests
//
//  Created by Brian Chung on 25/3/2018.
//  Copyright © 2018 9GAG. All rights reserved.
//

import XCTest
import Nimble
@testable import ReactiveCocoaPlayground

class ResponseModelTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSubBreedRandomImageResponse() {
		guard let filePath = Bundle(for: type(of: self)).path(forResource: "sub-breed-random-image", ofType: "json") else {
			fail("Json file not found")
			return
		}

		guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: filePath), options: .alwaysMapped) else {
			fail("Unable to read JSON data")
			return
		}

		guard let responseModel = try? JSONDecoder().decode(DogRandomImageResponse.self, from: jsonData) else {
			fail("Unable to parse JSON")
			return
		}
		expect(responseModel).notTo(beNil())
    }

	func testSubBreedRandomImagesResponse() {
		guard let filePath = Bundle(for: type(of: self)).path(forResource: "sub-breed-random-images", ofType: "json") else {
			fail("Json file not found")
			return
		}

		guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: filePath), options: .alwaysMapped) else {
			fail("Unable to read JSON data")
			return
		}

		guard let responseModel = try? JSONDecoder().decode(DogRandomImagesResponse.self, from: jsonData) else {
			fail("Unable to parse JSON")
			return
		}
		expect(responseModel).notTo(beNil())
	}

	func testAllBreedsResponse() {
		guard let filePath = Bundle(for: type(of: self)).path(forResource: "all-breeds", ofType: "json") else {
			fail("Json file not found")
			return
		}

		guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: filePath), options: .alwaysMapped) else {
			fail("Unable to read JSON data")
			return
		}

		guard let responseModel = try? JSONDecoder().decode(AllBreedsResponse.self, from: jsonData) else {
			fail("Unable to parse JSON")
			return
		}
		expect(responseModel).notTo(beNil())
	}
}
