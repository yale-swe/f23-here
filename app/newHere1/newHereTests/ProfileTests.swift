//
//  ProfileTests.swift
//  newHereTests
//
//  Created by Liyang Wang on 2023/11/10.
//

import XCTest
import ViewInspector
import SwiftUI

@testable import newHere

final class ProfileTests: XCTestCase {

    private var sut: ProfilePopup!

    var presented = Binding<Bool>(wrappedValue: false)

    
    override func setUpWithError() throws {
        
        sut = ProfilePopup(isPresented: presented)
    }

    override func tearDownWithError() throws {
        
        sut = nil
    }

    func testInitialState() throws {
        
        XCTAssertFalse(presented.wrappedValue)
        
        presented.wrappedValue = true
        
        XCTAssertTrue(sut.isPresented)
    }

    func testExists() throws {
        
        let closeButton = try sut.inspect().find(viewWithAccessibilityIdentifier: "Xmark Button")
        XCTAssertNotNil(closeButton)
        
        
        let scrollView = try sut.inspect().zStack().scrollView(0)
        XCTAssertNotNil(scrollView)
        
        //TODO
        let header = try sut.inspect().find(viewWithAccessibilityIdentifier: "ProfileHeader").view(ProfileHeader.self)
        
        let headerImage = try header.find(viewWithAccessibilityIdentifier: "profilePicture")
        let headerText = try header.find(text: "Bio or description")
        XCTAssertNotNil(headerImage)
        XCTAssertNotNil(headerText)
    }
    
    func testTapClose() throws {
        
        let closeButton = try sut.inspect().find(viewWithAccessibilityIdentifier: "Xmark Button").button()
        XCTAssertNotNil(closeButton)
        
        try closeButton.tap()

        XCTAssertTrue(presented.wrappedValue)
    }
    
    func testTapShowFriends() throws {
        
        let showFriendsButton = try sut.inspect().find(viewWithAccessibilityIdentifier: "Show Friends Button").button()

        XCTAssertNotNil(showFriendsButton)

        try showFriendsButton.tap()
    }
}
