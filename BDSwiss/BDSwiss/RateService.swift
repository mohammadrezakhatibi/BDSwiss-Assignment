//
//  RateService.swift
//  BDSwiss
//
//  Created by mohammadreza on 10/4/22.
//

import Foundation
import APIManager
import OSLog
import Core

protocol RateService {
    func loadRates(completion: @escaping (Result<RatesResponse, Error>) -> Void)
}

class RateAPIService: RateService {
    
    var api = APIManager.shared
    
    func loadRates(completion: @escaping (Result<RatesResponse, Error>) -> Void) {
        Task { @MainActor in
            do {
                let response: RatesResponse = try await api.request(method: .get, path: .rates)
                completion(.success(response))
            } catch {
                completion(.failure(error))
                os_log("Error on loading items on RateAPIService with error: %{public}@", log: OSLog.network, type: .error, "\(error)")
            }
        }
    }
}
