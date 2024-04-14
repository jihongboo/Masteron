//
//  AttributedString.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.16.
//

import Foundation

extension AttributedString {
    init(html: StringLiteralType?) {
        if let data = html?.data(using: .utf16),
           let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil),
           let result = try? AttributedString(attributedString, including: \.swiftUI) {
            self = result
        } else {
            self = "Error."
        }
    }
}
