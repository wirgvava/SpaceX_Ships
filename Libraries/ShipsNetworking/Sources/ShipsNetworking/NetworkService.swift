//
//  NetworkService.swift
//  ShipsNetworking
//
//  Created by Konstantine Tsirgvava on 28/03/2026.
//

import Foundation

public protocol NetworkServiceProtocol: Sendable {
    func execute<T: Decodable>(endpoint: Endpoint) async throws -> T
}

public final class NetworkService: NetworkServiceProtocol {
    
    public init() {}
    
    public func execute<T: Decodable>(endpoint: Endpoint) async throws -> T {
        let request = try endpoint.asURLRequest()
        let (data, response): (Data, URLResponse)
        
        log("🌐 Request: \(request)")
        
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw NetworkError.transportError(error.localizedDescription)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(
                statusCode: httpResponse.statusCode,
                data: data
            )
        }
        
        log("\n🌐 Response: \(String(data: data, encoding: .utf8) ?? "")")
        
        if data.isEmpty {
            throw NetworkError.emptyResponse
        }
          
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error.localizedDescription, data: data)
        }
    }
    
    private func log(_ message: String) {
        #if DEBUG
        print(message)
        #endif
    }
}
