//
//  APIManager.swift
//  BDSwiss
//
//  Created by mohammadreza on 9/29/22.
//

import Foundation
import UIKit

public class APIManager {
    private init() {}
    
    public static var shared = APIManager()
}

public extension APIManager {
    
    func request<T: Codable>(
        method: HTTPMethod,
        path: Path) async throws -> T {
        
        guard let url = URL(string: AppConfiguration.baseURL)?.appendingPathComponent(path.rawValue) else { throw NetworkError.badURL }
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        do {
            let (data, _) = try await session.data(for: request)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.somethingHappened
        }
        
    }
}


public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public enum Path: String {
    case rates = "rates"
}

public struct AppConfiguration {
    static var baseURL = "https://mt4-api.bdswiss-staging.com/"
}

public enum NetworkError: Error {
    case badURL
    case somethingHappened
}
