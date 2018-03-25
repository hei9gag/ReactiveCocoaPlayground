//
//  String+Helper.swift
//  ReactiveCocoaPlayground
//
//  Created by Brian Chung on 25/3/2018.
//  Copyright © 2018 9GAG. All rights reserved.
//

import Foundation

extension String {
	var firstUppercased: String {
		guard let first = first else { return "" }
		return String(first).uppercased() + dropFirst()
	}
}
