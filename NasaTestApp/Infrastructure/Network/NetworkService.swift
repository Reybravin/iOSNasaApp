//
//  NetworkService.swift
//  ExampleMVVM
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation

public protocol NetworkCancellable {
    func cancel()
}

extension URLSessionTask: NetworkCancellable { }

public protocol NetworkService {
    typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void
    
    func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancellable?
    func urlString(endPoint: Requestable) -> String
}

public protocol NetworkSessionManager {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> NetworkCancellable
}

// MARK: - Implementation

public final class DefaultNetworkService {
    
    private let config: NetworkConfigurable
    private let sessionManager: NetworkSessionManager
    private let logger: NetworkErrorLogger
    
    public init(config: NetworkConfigurable,
                sessionManager: NetworkSessionManager = DefaultNetworkSessionManager(),
                logger: NetworkErrorLogger = DefaultNetworkErrorLogger()) {
        self.sessionManager = sessionManager
        self.config = config
        self.logger = logger
    }
    
    private func request(request: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable {
        
        let sessionDataTask = sessionManager.request(request) { data, response, requestError in
            
            //1. Handle requestError
            if let requestError = requestError {
                var error: NetworkError
                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, data: data)
                } else {
                    error = self.resolve(error: requestError)
                }
                
                self.logger.log(error: error)
                completion(.failure(error))
            } else {
                //2. Handle response error
                if let httpResponse = response as? HTTPURLResponse {
                    if (200...299).contains(httpResponse.statusCode) {
                        self.logger.log(responseData: data, response: response)
                        completion(.success(data))
                    } else {
                        if let data = data, let dataString = String(data: data, encoding: .utf8) {
                            print(dataString)
                        }
                        var error: NetworkError
                        error = .error(statusCode: httpResponse.statusCode, data: data)
                        self.logger.log(error: error)
                        completion(.failure(error))
                    }
                }
//                self.logger.log(responseData: data, response: response)
//                completion(.success(data))
            }
        }
    
        logger.log(request: request)

        return sessionDataTask
    }
    
    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConnected(error)
        case .cancelled: return .cancelled(error)
        default: return .generic(error)
        }
    }
}

extension DefaultNetworkService: NetworkService {
    
    public func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancellable? {
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            return request(request: urlRequest, completion: completion)
        } catch (let error){
            completion(.failure(.urlGeneration(error)))
            return nil
        }
    }
    
    public func urlString(endPoint: Requestable) -> String {
        do {
            let url = try endPoint.url(with: config)
            return url.absoluteString
        } catch {
            print(error)
            fatalError("There has to be the url for this endpoint")
        }
    }
}

// MARK: - Default Network Session Manager
// Note: If authorization is needed NetworkSessionManager can be implemented by using,
// for example, Alamofire SessionManager with its RequestAdapter and RequestRetrier.
// And it can be incjected into NetworkService instead of default one.

public class DefaultNetworkSessionManager: NetworkSessionManager {
    public init() {}
    public func request(_ request: URLRequest,
                        completion: @escaping CompletionHandler) -> NetworkCancellable {
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
        return task
    }
}

// MARK: - Logger

public final class DefaultNetworkErrorLogger: NetworkErrorLogger {
    public init() { }
    
    public func log(request: URLRequest) {
        #if DEBUG
        print("-------------")
        print("request: \(request.url!)")
        print("headers: \(request.allHTTPHeaderFields!)")
        print("method: \(request.httpMethod!)")
        if let httpBody = request.httpBody, let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
            print("body: \(String(describing: result))")
        }
        if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
            print("body: \(String(describing: resultString))")
        }
        #endif
    }
    
    public func log(responseData data: Data?, response: URLResponse?) {
        #if DEBUG
        guard let data = data else { return }
        if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            print("responseData: \(String(describing: dataDict))")
        }
        #endif
    }
    
    public func log(error: Error) {
        #if DEBUG
        print("\(error)")
        #endif
    }
}

// MARK: - NetworkError extension

extension NetworkError {
    
    public var isNotFoundError: Bool { return hasStatusCode(404) }
    
    public func hasStatusCode(_ codeError: Int) -> Bool {
        switch self {
        case let .error(code, _):
            return code == codeError
        default: return false
        }
    }
}
