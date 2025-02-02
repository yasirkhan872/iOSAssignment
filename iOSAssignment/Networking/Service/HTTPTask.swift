//
//  HTTPTask.swift
//  iOS_assignment
//
//  Created by Yasir Khan on 02/02/2025.
//

import Foundation

public typealias HTTPHeaders = [String : String]

public enum HTTPTask {
    case request
    case requestParameters(bodyParameters : Parameters?, urlParameters : Parameters?)
    case requestParametsAndHeaders(bodyParameters : Parameters?, urlParameters : Parameters?, additionslHeaders : HTTPHeaders?)
}
