
import UIKit
import Alamofire
import AlamofireNetworkActivityIndicator
import ReactiveSwift
import Result

struct NetworkRequestTimeOut {
	public static let slow: TimeInterval = 60.0
	public static let normal: TimeInterval = 30.0
	public static let fast: TimeInterval = 20.0
}

class ReactiveHTTPClient {
	static let shared = ReactiveHTTPClient()

	private static var alamofireSessionManager: Alamofire.SessionManager = {
		let configuration = URLSessionConfiguration.default
		configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
		configuration.timeoutIntervalForRequest = NetworkRequestTimeOut.normal
		return Alamofire.SessionManager(configuration: configuration)
	}()

	// Make the class a true single-instance singleton
	private init() {
		NetworkActivityIndicatorManager.shared.isEnabled = true
		NetworkActivityIndicatorManager.shared.startDelay = 0.3
	}

	func request(method: HTTPMethod,
	             url: URL,
	             parameters: Parameters? = nil,
	             parameterEncoding: ParameterEncoding? = nil,
	             contentType: String? = nil,
	             headers: HTTPHeaders = [:])
		-> SignalProducer<(result: Any, headers: HTTPHeaders), ResponseError>
	{
		Logger.log(message: "url:\(url) request sent)", event: .d)
		return SignalProducer { observer, disposable in
			let request = ReactiveHTTPClient.alamofireSessionManager.request(
				url,
				method: method,
				parameters: parameters,
				encoding: parameterEncoding ?? (method == .get ? URLEncoding.queryString : JSONEncoding.default),
				headers: headers)
				.responseJSON(queue: DispatchQueue.global(qos: .background)) { response in
					self.handleDataResponse(response, with: observer)
				}
				.responseString { response in
					Logger.log(message: "\(method.rawValue) \(url.absoluteString): \(response)", event: .d)
				}
			disposable.observeEnded {
				Logger.log(message: "Cancelled (or finished) \(method.rawValue) \(url.absoluteString)", event: .d)				
				request.cancel()
			}
		}
	}

	private func handleDataResponse<Value, Result>(_ response: DataResponse<Value>,
												   with observer: Signal<Result, ResponseError>.Observer,
												   resultTansform: (Value, HTTPHeaders) -> Any = { ( $0, $1) }) {
		switch response.result {
		case .failure(let error):
			let responseError = ResponseError(error: error, url: response.request?.url)
			observer.send(error: responseError)			
		case .success(let result):
			let headers = response.response?.allHeaderFields as? [String: String] ?? [:]
			observer.send(value: resultTansform(result, headers) as! Result)
			observer.sendCompleted()
		}
	}
}
