//
//  MessagesTests.swift
//  newHereUITests
//
//  Created by TRACY LI on 2023/11/16.
//

import XCTest
import SwiftUI
@testable import newHere // Replace with your app's module name

class MessagesPopupTests: XCTestCase {
    
    var messagesPopup: MessagesPopup!

    override func setUpWithError() throws {
        super.setUp()
        // Initialize MessagesPopup with a binding
        var isPresented = false
        messagesPopup = MessagesPopup(isPresented: .constant(isPresented))
    }

    override func tearDownWithError() throws {
        messagesPopup = nil
        super.tearDown()
    }

    func testCloseButtonTogglesIsPresented() throws {
        XCTAssertFalse(messagesPopup.isPresented)
        // Simulate button tap
        messagesPopup.isPresented.toggle()
        XCTAssertTrue(messagesPopup.isPresented)
        // Simulate closing the popup
        messagesPopup.isPresented.toggle()
        XCTAssertFalse(messagesPopup.isPresented)
    }

    // Test the appearance and content of the message buttons
    func testMessageButtonsContent() throws {
        // Assert the number of message buttons
        let expectedMessageCount = 5
        let messageButtons = messagesPopup.body // Retrieve the body of the view
        // Here, you need to figure out a way to count the message buttons within the LazyVStack
        // This might require UI testing or a more complex unit testing setup

        // Add additional tests for checking the content of each message button
    }

    // Since ProfilePicture is a separate view, it should ideally have its own test case.
    // But you can also test its integration within the MessagesPopup here
    func testProfilePictureInView() throws {
        // Test that the ProfilePicture appears correctly within each message button
    }

    // Add more tests here if your actual views have more logic or different behaviors
}


