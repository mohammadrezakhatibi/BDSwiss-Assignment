//
//  RateRepeatingServiceAdapter.swift
//  BDSwiss
//
//  Created by mohammadreza on 10/4/22.
//

import Foundation
import Combine

class RateRepeatingServiceAdapter: RateListServiceAdapter {
    
    var every: TimeInterval = 10
    private var cancelable: Set<AnyCancellable> = []
    
    override func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        Timer.publish(every: every, on: .current, in: .common)
            .autoconnect()
            .sink() { _ in
                super.loadItems(completion: completion)
            }
            .store(in: &self.cancelable)
    }
    
}
