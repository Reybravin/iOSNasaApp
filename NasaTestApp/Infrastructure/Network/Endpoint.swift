//
//  Endpoint.swift
//  ExampleMVVM
//
//  Created by Oleh Kudinov on 01.10.18.
//

import UIKit

public enum HTTPMethodType: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
    case patch   = "PATCH"
}

public enum BodyEncoding {
    case jsonSerializationData
    case stringEncodingAscii
    case imageFile(String)
}

public class Endpoint<R>: ResponseRequestable {
        
    public typealias Response = R
    
    public var path: String
    public var isFullPath: Bool
    public var method: HTTPMethodType
    public var queryParameters: [String: Any]
    public var headerParamaters: [String: String]
    public var bodyParamaters: [String: Any]
    public var bodyEncoding: BodyEncoding
    public var responseDecoder: ResponseDecoder
    
    init(path: String,
         isFullPath: Bool = false,
         method: HTTPMethodType = .get,
         queryParameters: [String: Any] = [:],
         headerParamaters: [String: String] = [:],
         bodyParamaters: [String: Any] = [:],
         bodyEncoding: BodyEncoding = .jsonSerializationData,
         responseDecoder: ResponseDecoder = JSONResponseDecoder()) {
        self.path = path
        self.isFullPath = isFullPath
        self.method = method
        self.queryParameters = queryParameters
        self.headerParamaters = headerParamaters
        self.bodyParamaters = bodyParamaters
        self.bodyEncoding = bodyEncoding
        self.responseDecoder = responseDecoder
    }
}

public protocol Requestable {
    var path: String { get }
    var isFullPath: Bool { get }
    var method: HTTPMethodType { get }
    var queryParameters: [String: Any] { get }
    var headerParamaters: [String: String] { get }
    var bodyParamaters: [String: Any] { get }
    var bodyEncoding: BodyEncoding { get }
    
    func urlRequest(with networkConfig: NetworkConfigurable) throws -> URLRequest
}

public protocol ResponseRequestable: Requestable {
    associatedtype Response
    
    var responseDecoder: ResponseDecoder { get }
}

enum RequestGenerationError: Error {
    case components
}

extension Requestable {
     
    func url(with config: NetworkConfigurable) throws -> URL {

        let baseURL = config.baseURL.absoluteString.last != "/" ? config.baseURL.absoluteString + "/" : config.baseURL.absoluteString
        let endpoint = isFullPath ? path : baseURL.appending(path)
        
        guard var urlComponents = URLComponents(string: endpoint) else { throw RequestGenerationError.components }
        var urlQueryItems = [URLQueryItem]()
        
        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
//        config.queryParameters.forEach {
//            urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
//        }
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = urlComponents.url else { throw RequestGenerationError.components }
        return url
    }
    
    public func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {
        
        let url = try self.url(with: config)
        var urlRequest = URLRequest(url: url)
        var allHeaders: [String: String] = config.headers
        headerParamaters.forEach { allHeaders.updateValue($1, forKey: $0) }
        
        if !bodyParamaters.isEmpty {
            urlRequest.httpBody = encodeBody(bodyParamaters: bodyParamaters, bodyEncoding: bodyEncoding)
        }
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = allHeaders
        return urlRequest
    }
    
    fileprivate func encodeBody(bodyParamaters: [String: Any], bodyEncoding: BodyEncoding) -> Data? {
        switch bodyEncoding {
        case .jsonSerializationData:
            return try? JSONSerialization.data(withJSONObject: bodyParamaters)
        case .stringEncodingAscii:
            return bodyParamaters.queryString.data(using: String.Encoding.ascii, allowLossyConversion: true)
        case .imageFile(let boundary):
            return bodyParamaters.createTransferSlipBody(boundary: boundary)
        }
    }

}

fileprivate extension Dictionary {
    var queryString: String {
        
        return self.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
    }
}

//MARK: - UPLOAD IMAGE

fileprivate extension Dictionary {
    
    func createTransferSlipBody(boundary: String) -> Data? {
        
        guard let dict = self as? [String: Any] else {
            return nil
        }
        
        guard let image = dict["file"] as? UIImage else {
            return nil
        }
        
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            return nil
        }
        
        var body = Data()
                
        let lineBreak = "\r\n"
        let fileName = "deposit_slip_image.jpg"
        let mimeType = "image/jpg"
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\(lineBreak)")
        body.append("Content-Type: \(mimeType + lineBreak + lineBreak)")
        body.append(imageData)
        body.append(lineBreak)
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    
    }
}

fileprivate extension Data {
    mutating func append(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
