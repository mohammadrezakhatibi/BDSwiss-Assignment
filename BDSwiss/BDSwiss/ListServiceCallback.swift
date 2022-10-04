//
//  ListServiceCallback.swift
//  BDSwiss
//
//  Created by mohammadreza on 10/4/22.
//

import Foundation

struct ListServiceWithCallback: ListService {
    
    let primary: ListService
    let callback: ListService
    
    func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        primary.loadItems { result in
            switch result {
            case .success:
                completion(result)
                callback.loadItems(completion: completion)
            case .failure:
                completion(result)
            }
        }
    }
}

extension ListService {
    func callback(_ callback: ListService) -> ListService {
        ListServiceWithCallback(primary: self, callback: callback)
    }
}
