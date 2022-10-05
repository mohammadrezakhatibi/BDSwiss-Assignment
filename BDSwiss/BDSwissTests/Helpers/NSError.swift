//
//  NSError.swift
//  BDSwissTests
//
//  Created by mohammadreza on 10/5/22.
//

import Foundation

func anError() -> Error {
    NSError(localizedDescription: "any error message")
}

extension NSError {
     convenience init(localizedDescription: String) {
         self.init(domain: "Test", code: 0, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
     }
}
