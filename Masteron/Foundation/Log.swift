//
//  Log.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.18.
//

import OSLog

struct Log {
    private static let subsystem = Bundle.main.bundleIdentifier!
    static let app = Logger(subsystem: subsystem, category: "App")
}
