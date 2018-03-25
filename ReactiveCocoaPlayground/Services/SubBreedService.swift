//
//  SubBreedService.swift
//  ReactiveCocoaPlayground
//
//  Created by Brian Chung on 25/3/2018.
//  Copyright © 2018 9GAG. All rights reserved.
//

import Foundation
import ReactiveSwift

final class SubBreedService {
	static func fetchRandomImage(breedName: String, subBreedName: String) {		
		let requestUrlString = "breed/\(breedName)/\(subBreedName)/images/random"
		DogHTTPClient.shared.request(method: .get, URLString: requestUrlString)
			.startWithResult { result in
				switch result {
				case .success(let jsonData, _):
					guard let responseModel = try? JSONDecoder().decode(DogRandomImageResponse.self, from: jsonData) else {
						return
					}
					Logger.log(message: "responseModel:\(responseModel)", event: .d)
				case .failure(_):
					break
				}
		}
	}
}
