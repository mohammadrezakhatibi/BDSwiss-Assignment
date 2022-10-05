//
//  File.swift
//  
//
//  Created by mohammadreza on 10/5/22.
//

import OSLog

public extension OSLog {
    
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let decoding = OSLog(subsystem: subsystem, category: "decoding")
    static let network = OSLog(subsystem: subsystem, category: "network")
}
