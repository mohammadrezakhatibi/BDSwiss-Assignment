//
//  APIManager.swift
//  BDSwiss
//
//  Created by mohammadreza on 9/29/22.
//

import Foundation
import UIKit

class APIManager {
    private init() {}
    
    static var shared = APIManager()
}

extension APIManager {
    
    func request<T: Codable>(
        method: HTTPMethod,
        path: Path) async throws -> T {
        
        guard let url = URL(string: AppConfiguration.baseURL)?.appendingPathComponent(path.rawValue) else { throw NetworkError.badURL }
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        let (data, _) = try await session.data(for: request)
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}


enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum Path: String {
    case rates = "rates"
}

struct AppConfiguration {
    static var baseURL = "https://mt4-api.bdswiss-staging.com/"
}

enum NetworkError: Error {
    case badURL
}
