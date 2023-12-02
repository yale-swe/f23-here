//
//  APITests.swift
//  newHereTests
//
//  Created by Liyang Wang on 2023/11/20.
//

import XCTest
import ViewInspector
import SwiftUI

@testable import newHere

final class APITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPostMessageAPI() throws {
        
        let userId = "65685aa4e6e0bb9c468a1c3e"
        let message = "New Message"
        
        postMessage(user_id: userId, text: message, visibility: "friends", locationDataManager: LocationDataManager()) { result in
            
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
