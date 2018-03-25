//
//  BreedService.swift
//  ReactiveCocoaPlayground
//
//  Created by Brian Chung on 25/3/2018.
//  Copyright © 2018 9GAG. All rights reserved.
//

import Foundation
import ReactiveSwift

final class BreedService {
	static func fetchAllBreeds() {
		let requestUrlString = "breeds/list/all"
		DogHTTPClient.shared.request(method: .get, URLString: requestUrlString)
			.startWithResult { result in
				switch result {
				case .success(let jsonData, _):
					guard let responseModel = try? JSONDecoder().decode(AllBreedsResponse.self, from: jsonData) else {
						return
					}

					var dogs: [Dog] = []
					responseModel.message.forEach({ (key: String, subBreeds: [String]) in
						let dogName = key.firstUppercased
						guard !subBreeds.isEmpty else {
							let dog = Dog(name: dogName)
							dogs.append(dog)
							return
						}
						subBreeds.forEach {
							let subBreed = $0.firstUppercased
							let dog = Dog(name: dogName, subBreed: subBreed, imageUrl: nil)
							dogs.append(dog)
						}
					})

					Logger.log(message: "Final result dogs:\(dogs)", event: .d)
				case .failure(_):
					break
				}
		}
	}
}

