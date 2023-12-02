//
//  MessagesTests.swift
//  newHereTests
//
//  Created by WD on 2023/12/1.
//

import XCTest
import ViewInspector
import SwiftUI

@testable import newHere

final class MessagesTests: XCTestCase {

    private var sut: MessagesPopup!

    var presented = Binding<Bool>(wrappedValue: false)

    override func setUpWithError() throws {
        
        sut = MessagesPopup(isPresented: presented)
    }

    override func tearDownWithError() throws {
        
        sut = nil
    }

    func testInitialState() throws {
        
        XCTAssertFalse(presented.wrappedValue)
        
        presented.wrappedValue = true
        
        XCTAssertTrue(presented.wrappedValue)
    }

    func testExists() throws {
        
        let closeButton = try sut.inspect().find(viewWithAccessibilityIdentifier: "Xmark Button")
        XCTAssertNotNil(closeButton)
        
        let messageTitles = try sut.inspect().findAll(where: { try $0.text().string() == "Message Title" })
        XCTAssertNotNil(messageTitles)
        XCTAssertEqual(messageTitles.count, 5)
        
        let scrollView = try sut.inspect().zStack().scrollView(0)
        XCTAssertNotNil(scrollView)
    }
    
    func testTapClose() throws {
        
        let closeButton = try sut.inspect().find(viewWithAccessibilityIdentifier: "Xmark Button").button()
        XCTAssertNotNil(closeButton)
        
        try closeButton.tap()

        XCTAssertTrue(presented.wrappedValue)
    }

    func testTapMessageButton() throws {
        
        let messageButton1 = try sut.inspect().find(viewWithId: 1).button()
        
        XCTAssertNotNil(messageButton1)
        
        try messageButton1.tap()
    }
}
