//
//  Mock.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.14.
//

import Foundation

public func model<T: Decodable>(_ fileName: String? = nil) -> T {
    let bundle = Bundle.main.url(forResource: fileName ?? String(describing: T.self), withExtension: "json")!
    let data = try! Data(contentsOf: bundle)
    return try! JSON.decode(data: data)
}
