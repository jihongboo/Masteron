//
//  MasteronTests.swift
//  MasteronTests
//
//  Created by 纪洪波 on 2024.04.14.
//

import XCTest
@testable import Masteron

final class MasteronTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let timeline: [Post] = model()
        print(timeline)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
