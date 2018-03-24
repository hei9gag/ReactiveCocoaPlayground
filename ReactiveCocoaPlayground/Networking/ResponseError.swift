
import Foundation
import Alamofire

struct ResponseError: Error {

	enum ResponseErrorType {
		case noNetworkConnection(NSError)
		case connectionTimeout(NSError)
		case httpError(statusCode:Int)
		case notJSON(rawResponse:HTTPURLResponse?)
		case parseJSONError(decodingError: DecodingError)
		case unexpectedError(message:String?, error:Error?)
	}

	let errorType: ResponseErrorType
	let url: URL?

	init(errorType: ResponseErrorType, url: URL?) {
		self.errorType = errorType
		self.url = url
	}

	init(error: Error, url: URL?) {
		self = ResponseError.from(generalError: error, url: url)
	}

    /// Map gerenic error to API ResponseError which return by Alamorefire failure response
    static func from(generalError: Error, url: URL?) -> ResponseError {
        
        if case AFError.responseSerializationFailed = generalError {
            return ResponseError(errorType: .notJSON(rawResponse: nil), url: url)
        }

        let nsError = generalError as NSError

        guard nsError.domain == "NSURLErrorDomain" else {
            return ResponseError(errorType: .unexpectedError(message: nil, error: nsError), url: url)
        }

        /// Convert nsError to ResponseError format
        switch nsError.code {
        case NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost:
            return ResponseError(errorType: .noNetworkConnection(nsError), url: url)
        case NSURLErrorTimedOut:
            return ResponseError(errorType: .connectionTimeout(nsError), url: url)
        default:
            return ResponseError(errorType: .unexpectedError(message: nil, error: nsError), url: url)
        }
    }

    private static let mapping:[Int:String] = [
        500: "Internal Server Error",
        404: "Page not found"
    ]

    var description: String {
        switch self.errorType {
        case .noNetworkConnection:
            return "ResponseError: No network connection"
        case .httpError(let statusCode):
            return "ResponseError: HTTP error: \(ResponseError.mapping[statusCode] ?? "Other"), Status code: \(statusCode)"
        case .unexpectedError(let message, let error):
            return "ResponseError: UnexpectedError message: \(message ?? ""), error \(error.debugDescription)"
        case .parseJSONError(let decodingError):
            return "ResponseError: JSON Decode error: \(decodingError)"
        case .connectionTimeout(let error):
            return "ResponseError: Connection timeout \(error.debugDescription)"
        default:
            return String(describing: self)
        }
    }
}
