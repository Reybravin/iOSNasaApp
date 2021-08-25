//
//  NasaDataRepository.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 25.08.2021.
//

import Foundation

protocol NasaDataRepositoryInterface {}

final class NasaDataRepository : NasaDataRepositoryInterface {
    
    //private let dataTransferService: DataTransferService
    //private let secureStorage: SecureStorageInterface
    //private let defaults : DefaultsServiceInterface
    //private var authTask: Cancellable?
    
//    init(dataTransferService: DataTransferService,
//         secureStorage: SecureStorageInterface,
//         defaults: DefaultsServiceInterface) {
//        debugPrint("AuthRepository init")
//        self.dataTransferService = dataTransferService
//        self.secureStorage = secureStorage
//        self.defaults = defaults
//    }

    private var baseURL : String {
        return "https://api.nasa.gov"
    }
    
    private let scheme = "https"
    private let host = "api.nasa.gov"
    private let epic = "/EPIC/api/natural/images"
    private let apiKey : String = "KK2KcxX66KsS1jjiVH7gQDdJWcBHSxyE1S93QMOL"
    
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    private var epicImagesDataTask: URLSessionDataTask?

    private var errorMessage : String = ""
    private var tracks = ""
}

extension NasaDataRepository {
    
    func fetchApod(completion : @escaping (Result<Apod, Error>) -> ()) {
        // 1
        dataTask?.cancel()
            
        // 2
        guard var urlComponents = URLComponents(string: "\(baseURL + "/planetary/apod")") else {
            return
        }

        let queryParameters : [String : String] = [
            "api_key" : apiKey,
            "thumbs" : "\(true)"
        ]
        
        let queryItems = queryParameters.map({ URLQueryItem(name: $0.key, value: $0.value) })
        urlComponents.queryItems = queryItems
        
        // 3
        guard let url = urlComponents.url else {
            return
        }
        // 4
        dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in

            guard let strongSelf = self else { return }
            
            defer {
                strongSelf.dataTask = nil
            }

            // 5
            if let error = error {
                completion(.failure(error))
            } else if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    if let data = data {
                        do {
                            let result = try JSONDecoder().decode(Apod.self, from: data)
                            // 6
                            DispatchQueue.main.async {
                                completion(.success(result))
                            }
                        } catch (let error) {
                            completion(.failure(error))
                        }
                    }
                default:
                    let error = NetworkError.serverResponse(response.statusCode)
                    completion(.failure(error))
                }
            } else {
                let error = NetworkError.notHTTPResponse
                completion(.failure(error))
            }
        }
        // 7
        dataTask?.resume()
    }
    
    func fetchEpicImages(completion : @escaping (Result<[EpicImage], Error>) -> ()){
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = epic
        urlComponents.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        // 3
        guard let url = urlComponents.url else {
            return
        }
        // 4
        epicImagesDataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in

            guard let strongSelf = self else { return }
            
            defer {
                strongSelf.epicImagesDataTask = nil
            }

            // 5
            if let error = error {
                completion(.failure(error))
            } else if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    if let data = data {
                        do {
                            let result = try JSONDecoder().decode([EpicImage].self, from: data)
                            // 6
                            DispatchQueue.main.async {
                                completion(.success(result))
                            }
                        } catch (let error) {
                            completion(.failure(error))
                        }
                    }
                default:
                    let error = NetworkError.serverResponse(response.statusCode)
                    completion(.failure(error))
                }
            } else {
                let error = NetworkError.notHTTPResponse
                completion(.failure(error))
            }
        }
        // 7
        epicImagesDataTask?.resume()
    }
    
}

enum NetworkError : Error {
    case notHTTPResponse
    case serverResponse(Int)
}
