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
