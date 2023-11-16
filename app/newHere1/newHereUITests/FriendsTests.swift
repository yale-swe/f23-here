//
//  FriendsTests.swift
//  newHereUITests
//
//  Created by TRACY LI on 2023/11/15.
//
import XCTest
@testable import newHere
class FriendsViewUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    func testCloseButton() {
        let closeButton = app.buttons["CloseButtonIdentifier"] // Replace with actual identifier
        closeButton.tap()
        XCTAssertFalse(closeButton.isHittable, "The close button should not be hittable after tapping.")
    }
    func testSearchBarInput() {
        let searchBar = app.searchFields["SearchBarIdentifier"] // Replace with actual identifier
        searchBar.tap()
        searchBar.typeText("John Doe")
        XCTAssertEqual(searchBar.value as? String, "John Doe", "Search bar should contain 'John Doe'.")
    }
    func testAddFriendButton() {
        let searchBar = app.searchFields["SearchBarIdentifier"] // Replace with actual identifier
        let addFriendButton = app.buttons["AddFriendButtonIdentifier"] // Replace with actual identifier
        searchBar.tap()
        searchBar.typeText("John Doe")
        addFriendButton.tap()
        let newFriend = app.staticTexts["John Doe"] // Replace with identifier for new friend entry
        XCTAssertTrue(newFriend.exists, "New friend 'John Doe' should be visible in the list.")
    }
    func testErrorMessage() {
        let searchBar = app.searchFields["SearchBarIdentifier"] // Replace with actual identifier
        let addFriendButton = app.buttons["AddFriendButtonIdentifier"] // Replace with actual identifier
        searchBar.tap()
        searchBar.typeText("") // Simulate error condition
        addFriendButton.tap()
        let errorMessage = app.staticTexts["ErrorMessageIdentifier"] // Replace with actual identifier
        XCTAssertTrue(errorMessage.exists, "Error message should be displayed when trying to add an empty name.")
    }
    func testFriendList() {
        let friendList = app.tables["FriendListIdentifier"] // Replace with actual identifier
        let firstFriend = friendList.cells.element(boundBy: 0)
        XCTAssertTrue(firstFriend.exists, "First friend should exist in the friend list.")
    }
    // Add more tests as needed
}














