import Foundation
import Alamofire

struct ResponseError: Error {

	enum ResponseErrorType {
		case invalidUrl(AFError)
		case responseValidationFailed(AFError)
		case parameterEncodingFailed(AFError)
		case multipartEncodingFailed(AFError)
		case responseSerializationFailed(AFError)
		case invalidStatusCode(Int)
		case urlError(URLError)
		case unknownError(NSError)
	}

	let errorType: ResponseErrorType

	init(error: Error, url: URL?) {
		self = ResponseError.handleAfErrorResponse(error: error, url: url)
	}

	private init(errorType: ResponseErrorType) {
		self.errorType = errorType
	}

    private static let mapping:[Int:String] = [
        500: "Internal Server Error",
        404: "Page not found"
    ]

    var description: String {
        switch self.errorType {
        case .invalidUrl:
            return "ResponseError: Invalid Url"
        case .responseValidationFailed(let afError):
			return "ResponseError: ResponseValidationFailed error: \(afError.localizedDescription)"
        case .parameterEncodingFailed(let afError):
			return "ResponseError: ParameterEncodingFailed error: \(afError.localizedDescription)"
		case .multipartEncodingFailed(let afError):
			return "ResponseError: MultipartEncodingFailed error: \(afError.localizedDescription)"
		case .responseSerializationFailed(let afError):
			return "ResponseError: ResponseSerializationFailed error: \(afError.localizedDescription)"
        case .invalidStatusCode(let statusCode):
            return "ResponseError: Invalid StatusCode error: \(ResponseError.mapping[statusCode] ?? "Other")"
        case .urlError(let urlError):
            return "ResponseError: URL error: \(urlError.localizedDescription)"
		case .unknownError(let error):
            return "ResponseError: Unknown error: \(error.localizedDescription)"
        }
    }
}

extension ResponseError.ResponseErrorType: Equatable{
	public static func ==(lhs: ResponseError.ResponseErrorType, rhs: ResponseError.ResponseErrorType) -> Bool {
		switch (lhs, rhs) {
		case (.invalidUrl(let lhsAfError), .invalidUrl(let rhsAfError)):
			return lhsAfError.isInvalidURLError == rhsAfError.isInvalidURLError
		case (.responseValidationFailed(let lhsAfError), .responseValidationFailed(let rhsAfError)):
			return lhsAfError.isResponseValidationError == rhsAfError.isResponseValidationError
		case (.parameterEncodingFailed(let lhsAfError), .parameterEncodingFailed(let rhsAfError)):
			return lhsAfError.isParameterEncodingError == rhsAfError.isParameterEncodingError
		case (.multipartEncodingFailed(let lhsAfError), .multipartEncodingFailed(let rhsAfError)):
			return lhsAfError.isMultipartEncodingError == rhsAfError.isMultipartEncodingError
		case (.responseSerializationFailed(let lhsAfError), .responseSerializationFailed(let rhsAfError)):
			return lhsAfError.isResponseSerializationError == rhsAfError.isResponseSerializationError
		case (.invalidStatusCode(let lhsStatusCode), .invalidStatusCode(let rhsStatusCode)):
			return lhsStatusCode == rhsStatusCode
		case (.urlError(let lhsUrlError), .urlError(let rhsUrlError)):
			return lhsUrlError.code == rhsUrlError.code
		case (.unknownError(let lhsError), .unknownError(let rhsError)):
			return lhsError.code == rhsError.code
		default:
			return false
		}
	}
}


private extension ResponseError {
	static func handleAfErrorResponse(error: Error, url: URL?) -> ResponseError {

		if let error = error as? AFError {
			switch error {
			case .invalidURL(_):
				return ResponseError(errorType: .invalidUrl(error))
			case .responseValidationFailed(let reason):
				Logger.log(message: "Response Validation Failed for URL:\(url?.absoluteString ?? "") reason:\(reason)", event: .e)
				switch reason {
				case .unacceptableStatusCode(let code):
					return ResponseError(errorType: .invalidStatusCode(code))
				default:
					break
				}
				return ResponseError(errorType: .responseValidationFailed(error))
			case .parameterEncodingFailed(let reason):
				Logger.log(message: "parameterEncodingFailed for URL:\(url?.absoluteString ?? "") reason:\(reason)", event: .e)
				return ResponseError(errorType: .parameterEncodingFailed(error))
			case .multipartEncodingFailed(let reason):
				Logger.log(message: "multipartEncodingFailed for URL:\(url?.absoluteString ?? "") reason:\(reason)", event: .e)
				return ResponseError(errorType: .multipartEncodingFailed(error))
			case .responseSerializationFailed(let reason):
				Logger.log(message: "responseSerializationFailed for URL:\(url?.absoluteString ?? "") reason:\(reason)", event: .e)
				return ResponseError(errorType: .responseSerializationFailed(error))
			}
		} else if let error = error as? URLError {
			return ResponseError(errorType: .urlError(error))
		} else {
			// unknown error
			let nsError = error as NSError
			return ResponseError(errorType: .unknownError(nsError))
		}
	}
}
