//
//  NetworkManager.swift
//  iOS_assignment
//
//  Created by Yasir Khan on 02/02/2025.
//

import Foundation
import Combine

enum ErrorResponse : String {
    case invalidData
    case apiError
    case invalidEndpoint
    case internet
    case none
    public var description : String {
        switch self {
        case .invalidData: return "Invalid data response"
        case .apiError: return "Api error"
        case .invalidEndpoint: return "Invalid API end point"
        case .internet: return "No internet connection"
        default: return ""
        }
    }
}

struct NetworkError : Error, Equatable {
    let message : ErrorResponse
}

protocol NetworkService {
    func getRequest<Request: DataRequest>(_ request: Request) -> AnyPublisher<Request.Response, NetworkError>
    func postRequest<Request: DataRequest>(_ request: Request) -> AnyPublisher<Request.Response, NetworkError>
}

extension NetworkService {
    func postRequest<Request: DataRequest>(_ request: Request) -> AnyPublisher<Request.Response, NetworkError> {
        return Fail(error: NetworkError(message: .invalidEndpoint))
            .eraseToAnyPublisher()
    }
}

final class NetworkManager: NetworkService {
    
    func getRequest<Request: DataRequest>(_ request: Request) -> AnyPublisher<Request.Response, NetworkError> {
        
        guard InternetConnectionManager.isConnectedToNetwork() else {
            return Fail(error: NetworkError(message: .internet))
                .eraseToAnyPublisher()
        }
        
        if request.url.isEmpty {
               return Fail(error: NetworkError(message: .invalidEndpoint))
                   .eraseToAnyPublisher()
        }
        
        guard var urlComponent = URLComponents(string: request.url) else {
            return Fail(error: NetworkError(message: .invalidEndpoint))
                .eraseToAnyPublisher()
        }
        
        if !request.queryItems.isEmpty {
            urlComponent.queryItems = request.queryItems.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        guard let url = urlComponent.url else {
            return Fail(error: NetworkError(message: .invalidEndpoint))
                .eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError { _ in NetworkError(message: .invalidData) }
            .flatMap { data, response -> AnyPublisher<Request.Response, NetworkError> in
                do {
                    let decodedResponse = try request.decode(data)
                    return Just(decodedResponse)
                        .setFailureType(to: NetworkError.self)
                        .eraseToAnyPublisher()
                } catch {
                    return Fail(error: NetworkError(message: .invalidData))
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
