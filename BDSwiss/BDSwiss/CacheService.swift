//
//  CacheService.swift
//  BDSwiss
//
//  Created by mohammadreza on 10/4/22.
//

import Foundation

protocol CacheService {
    func saveData(items: [ItemViewModel])
    func loadData() -> [ItemViewModel]
}

class LocalCacheService: CacheService {
    
    func saveData(items: [ItemViewModel]) {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(items)
        
        UserDefaults.standard.set(data, forKey: "Rates")
    }
    
    func loadData() -> [ItemViewModel] {
        if let data = UserDefaults.standard.data(forKey: "Rates") {
            do {
                let decoder = JSONDecoder()

                let items = try decoder.decode([ItemViewModel].self, from: data)
                return items

            } catch {
                print("Unable to Decode Items (\(error))")
            }
        }
        return []
    }
}
