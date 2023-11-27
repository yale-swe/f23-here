//
//  friendsTest.swift
//  newHereTests_v2
//
//  Created by Liyang Wang on 11/10/23.
//

import XCTest
@testable import newHere

class FriendsTests: XCTestCase {
    private var isPresented: Bool!
    private var friendsView: Friends!
    private var mockNetworkHandler: MockNetworkHandler!

    override func setUpWithError() throws {
        isPresented = true
        mockNetworkHandler = MockNetworkHandler()
        friendsView = Friends(isPresented: .constant(isPresented))
        friendsView.networkHandler = mockNetworkHandler
    }
    override func tearDownWithError() throws {
        isPresented = nil
        friendsView = nil
        mockNetworkHandler = nil
    }

    func testInitialState() {
        XCTAssertTrue(friendsView.friendsList.isEmpty, "Friends list should be empty initially")
        XCTAssertNil(friendsView.errorMessage, "Error message should be nil initially")
    }
    func testFetchFriendsOnAppear() {
        mockNetworkHandler.mockGetAllUserFriendsSuccess(friends: ["Alice", "Bob"])
        friendsView.onAppear()
        XCTAssertEqual(friendsView.friendsList, ["Alice", "Bob"], "Friends list should be updated after fetching friends")
    }
    func testDeleteFriendSuccess() {
        let friendToDelete = "Alice"
        friendsView.friendsList = ["Alice", "Bob"]

        mockNetworkHandler.mockDeleteFriendSuccess()
        friendsView.deleteFriendByName(userId: "TestUserID", friendName: friendToDelete) { _ in }
        
        XCTAssertFalse(friendsView.friendsList.contains(friendToDelete), "Friend should be removed from the list upon successful deletion")
    }

    func testDeleteFriendFailure() {
        let friendToDelete = "Alice"
        let expectedError = "Network Error"
        friendsView.friendsList = ["Alice", "Bob"]

        mockNetworkHandler.mockDeleteFriendFailure(error: expectedError)
        friendsView.deleteFriendByName(userId: "TestUserID", friendName: friendToDelete) { result in
            if case .failure(let error) = result {
                XCTAssertEqual(friendsView.errorMessage, error.localizedDescription, "Error message should be updated upon deletion failure")
            } else {
                XCTFail("Deletion should fail and result in an error")
            }
        }
    }
    func testDeleteNonExistingFriend() {
        let nonExistingFriend = "Charlie"
        friendsView.friendsList = ["Alice", "Bob"]

        mockNetworkHandler.mockDeleteFriendSuccess()
        friendsView.deleteFriendByName(userId: "TestUserID", friendName: nonExistingFriend) { _ in }

        XCTAssertEqual(friendsView.friendsList, ["Alice", "Bob"], "Friends list should remain unchanged when attempting to delete a non-existing friend")
    }
    func testFetchFriendsFailure() {
        let expectedError = "Network Error"
        mockNetworkHandler.mockGetAllUserFriendsFailure(error: expectedError)
        friendsView.onAppear()
        XCTAssertEqual(friendsView.errorMessage, expectedError, "Error message should be updated after a failed fetch")
    }
    func testAddFriendSuccess() {
        let newFriend = "Charlie"
        mockNetworkHandler.mockAddFriendSuccess()
        friendsView.searchText = newFriend
        friendsView.addFriend()
        XCTAssertTrue(friendsView.friendsList.contains(newFriend), "New friend should be added to the friends list")
    }
    func testAddFriendFailure() {
        let expectedError = "Add Friend Failed"
        mockNetworkHandler.mockAddFriendFailure(error: expectedError)
        friendsView.addFriend()
        XCTAssertEqual(friendsView.errorMessage, expectedError, "Error message should be updated after a failed add friend attempt")
    }
    
}
