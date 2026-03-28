//
//  NetworkError.swift
//  ShipsNetworking
//
//  Created by Konstantine Tsirgvava on 28/03/2026.
//

import Foundation

public enum NetworkError: LocalizedError, Sendable {
    case invalidURL
    case invalidResponse
    case emptyResponse
    case transportError(String)
    case decodingFailed(String, data: Data)
    case serverError(statusCode: Int, data: Data?)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
            
        case .invalidResponse:
            return "Invalid response"
            
        case .emptyResponse:
            return "Empty response"
            
        case .transportError(let message):
            return "Network error: \(message)"
            
        case .decodingFailed(let message, let data):
            let body = String(data: data, encoding: .utf8) ?? ""
            return "Decoding failed: \(message)\nResponse: \(body)"
            
        case .serverError(let statusCode, let data):
            let body = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
            return "Server error (\(statusCode))\nResponse: \(body)"
        }
    }
}
