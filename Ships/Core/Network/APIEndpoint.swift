//
//  APIEndpoint.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 28/03/2026.
//

import Foundation
import ShipsNetworking

enum APIEndpoint: Endpoint {
    case ships(filter: String, limit: Int, offset: Int)
    
    var baseURL: String {
        "https://api.spacexdata.com/v3"
    }
    
    var path: String {
        switch self {
        case .ships:
            return "/ships"
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .ships(let filter, let limit, let offset):
            [
                "filter" : filter,
                "limit" : String(limit),
                "offset" : String(offset)
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .ships:
            return .get
        }
    }
}
