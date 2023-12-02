//
//  newHereUITests.swift
//  newHereUITests
//
//  Created by Eric  Wang on 10/28/23.
//

import XCTest

final class newHereUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments = ["testing"]
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoginFlow() throws {

        let userField = app.textFields["User Name TextField"]

        let pwdField = app.textFields["Password TextField"]

        let loginButton = app.buttons["Login Button"]
        
        XCTAssertTrue(userField.exists)
        XCTAssertTrue(pwdField.exists)
        XCTAssertTrue(loginButton.exists)

        
        userField.tap()
        userField.typeText("Test01")
        
        pwdField.tap()
        pwdField.typeText("123456")
        
        loginButton.tap()
        
//        AddPostButton
    }
    
//    func testPostFlow() throws {
//
//        let postEditor = app.textFields["MessageEditor"]
//        postEditor.tap()
//        postEditor.typeText("New Post Message")
//    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
