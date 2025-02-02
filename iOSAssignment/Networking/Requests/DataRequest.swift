//
//  DataRequest.swift
//  iOS_assignment
//
//  Created by Yasir Khan on 02/02/2025.
//

import Foundation

protocol DataRequest {
    associatedtype Response
    
    var url : String { get }
    var method : HTTPMethod { get }
    var headers : HTTPHeaders { get }
    var queryItems : Parameters { get }
    var parameters : Parameters { get }
    func decode(_ data : Data)  throws ->  Response
}

extension DataRequest where Response : Decodable {
    func decode(_ data : Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}

extension DataRequest {
    
    var headers : HTTPHeaders {
        [:]
    }
    var queryItems : Parameters {
        [:]
    }
    var parameters : Parameters {
        [:]
    }
}
