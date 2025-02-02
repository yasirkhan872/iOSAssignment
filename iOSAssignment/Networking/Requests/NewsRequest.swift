//
//  NewsRequest.swift
//  iOS_assignment
//
//  Created by Yasir Khan on 02/02/2025.
//

import Foundation

struct NewsRequest : DataRequest {
 
    let baseUrl : String =
         "https://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/"
    
    let apiKey : String = "6ynxQYLWbjUxQp2S3uE2jSEqWvmoAWBZ"
    
    var url : String { return "\(baseUrl)\(days).json?api-key=\(apiKey)"}
    
    var method: HTTPMethod { return .get }
    
    var days : Int
    
    init(days: Int) {
        self.days = days
    }
    
    func decode(_ data: Data) throws -> NewsModel {
        let decoder = JSONDecoder()
        let response = try decoder.decode(NewsModel.self, from: data)
        return response
    }
}
