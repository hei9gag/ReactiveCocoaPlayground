//
//  Dog.swift
//  ReactiveCocoaPlayground
//
//  Created by Brian Chung on 25/3/2018.
//  Copyright © 2018 9GAG. All rights reserved.
//

import Foundation

struct Dog {
	let name: String
	var subBreed: String?
	var imageUrl: URL?

	init(name: String, subBreed: String? = nil, imageUrl: URL? = nil) {
		self.name = name
		self.subBreed = subBreed
		self.imageUrl = imageUrl
	}
}
