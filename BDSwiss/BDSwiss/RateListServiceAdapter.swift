//
//  ListServiceAdapter.swift
//  BDSwiss
//
//  Created by mohammadreza on 10/4/22.
//

import Foundation
import OSLog
import Core

class RateListServiceAdapter: ListService {
    
    var api: RateService
    var cache: CacheService
    
    init(api: RateService,
         cache: CacheService) {
        self.api = api
        self.cache = cache
    }
    
    func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        api.loadRates { result in
            switch result {
            case let .success(response):
                let items = self.makeRatesFromAPIResult(
                    with: response.rates.map { item in
                        ItemViewModel(title: item.symbol.addRatePairSeparator(),
                                      subtitle: item.price.limitDecimal(to: 4),
                                      color: .gray)
                    }
                )
                self.cache.saveData(items: items)
                completion(.success(items))
            case let .failure(error):
                completion(.failure(error))
                os_log("Error on loading items from api: %{public}@", log: OSLog.network, type: .error, "\(error)")
            }
        }
    }
    
    
    func makeRatesFromAPIResult(with result: [ItemViewModel]) -> [ItemViewModel] {
        let items = rateStatusCalculation(
            previous: cache.loadData(),
            latest: result)
        return items
    }
    
    /// Calculation of the state of each rate.
    ///
    /// This method compare cached datas (provided by CacheService) and result of api call for
    /// assigning rate color for ItemViewModel
    ///
    ///  - parameter previous: the cached items
    ///  - parameter latest: result form API call
    /// - Returns: [ItemViewModel]
    /// - Complexity: O(n) on average, over `for` loop
    private func rateStatusCalculation(
        previous: [ItemViewModel],
        latest: [ItemViewModel]) -> [ItemViewModel] {
            
            var result = latest
            guard previous.count > 0 else {
                return latest
            }
            
            for (index, item) in previous.enumerated() {
                
                let isGreater = Double(latest[index].subtitle) ?? 0 >= Double(item.subtitle) ?? 0
                switch isGreater {
                case true:
                    result[index].color = .green
                case false:
                    result[index].color = .red
                }
            }
            
            return result
        
    }
    
}
extension Double {
    /// Format doubles to the specific number.
    ///
    /// - Parameters:
    ///   - fractionDigits: Number of fraction Digits.
    ///
    /// - Returns: String
    func limitDecimal(to fractionDigits: Int) -> String {
        String(format: "%.\(fractionDigits)f", self)
    }
}

extension String {
    /// Add slash(/) separator for rate pair.
    ///
    /// - Returns: Rate pair separated with / {(EUR/USD)}
    func addRatePairSeparator() -> String {
        var newStr = self
        newStr.insert("/", at: self.index(startIndex, offsetBy: 3))
        return newStr
    }
}
