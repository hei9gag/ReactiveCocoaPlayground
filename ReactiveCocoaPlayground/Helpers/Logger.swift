//
//  Logger.swift
//  SwiftLogger
//
//
//  Reference from Sauvik Dolui on 03/05/2017.
//
import Foundation

// Enum for showing the type of Log Types
enum LogEvent: String {
	case e = "[‼️]" // error
	case i = "[ℹ️]" // info
	case d = "[💬]" // debug
	case v = "[🔬]" // verbose
	case w = "[⚠️]" // warning
	case s = "[🔥]" // severe
}

final class Logger {

	static func log(message: String,
				   event: LogEvent,
				   fileName: String = #file,
				   line: Int = #line,
				   column: Int = #column,
				   funcName: String = #function) {

		#if DEBUG
			print("\(Date().toString()) \(event.rawValue)[\(sourceFileName(filePath: fileName))]:\(line) \(column) \(funcName) -> \(message)")
		#endif
	}

	private static func sourceFileName(filePath: String) -> String {
		let components = filePath.components(separatedBy: "/")
		return components.isEmpty ? "" : components.last!
	}
}

internal extension Date {
	func toString() -> String {
		return DateHelper.dateToString(date: self)
	}
}
