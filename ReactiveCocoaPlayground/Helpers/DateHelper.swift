//
//  DateHelper.swift
//  9Gag
//
//  Created by Brian Chung on 31/1/2018.
//  Copyright © 2018 9GAG. All rights reserved.
//

import Foundation

final class DateHelper {

	static let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone.current
		formatter.locale = Locale(identifier: "en_US")
		formatter.dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
		return formatter
	}()

	static func dateToString(date: Date) -> String {
		return dateFormatter.string(from: date)
	}

}
