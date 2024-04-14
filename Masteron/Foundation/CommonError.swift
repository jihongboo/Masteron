//
//  CommonError.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.20.
//

import Foundation

enum CommonError: LocalizedError {
    case message(String)
    
    var errorDescription: String? {
        switch self {
        case .message(let string):
            NSLocalizedString(string, comment: "")
        }
    }
}
