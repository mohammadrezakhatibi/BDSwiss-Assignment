//
//  RateResponse.swift
//  BDSwiss
//
//  Created by mohammadreza on 10/4/22.
//

import Foundation

struct RatesResponse: Codable {
    var rates: [Rate]
}

struct Rate: Codable {
    var symbol: String
    var price: Double
}
