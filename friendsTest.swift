//
//  friendsTest.swift
//  newHereTests_v2
//
//  Created by Liyang Wang on 11/27/23.
//

import XCTest

final class friendsTest: XCTestCase {

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

        func testAddFriendSuccessUpdatesFriendsList() {
            let newFriend = "C"
            mockNetworkHandler.mockAddFriendSuccess()
            mockNetworkHandler.friendsList = ["A", "B"]

            friendsView.searchText = newFriend
            friendsView.addFriend()

            XCTAssertTrue(friendsView.friendsList.contains(newFriend), "New friend should be added to the friends list after successful addition")
        }

        func testAddFriendFailureDoesNotUpdateFriendsList() {
            let newFriend = "C"
            mockNetworkHandler.mockAddFriendFailure(error: "Network Error")
            mockNetworkHandler.friendsList = ["A", "B"]

            friendsView.searchText = newFriend
            friendsView.addFriend() 

            XCTAssertFalse(friendsView.friendsList.contains(newFriend), "Friends list should not be updated after failed addition")
        }

        // Test adding a friend failure sets the error message
        func testAddFriendFailureSetsErrorMessage() {
            let expectedError = "Network Error"
            mockNetworkHandler.mockAddFriendFailure(error: expectedError)
            friendsView.searchText = "C"

            friendsView.addFriend()

            XCTAssertEqual(friendsView.errorMessage, expectedError, "Error message should be set after a failed add friend attempt")
        }

        func testAddFriendWithEmptySearchText() {
            friendsView.searchText = ""

            friendsView.addFriend() 
            XCTAssertNil(mockNetworkHandler.addFriendResult, "Add friend should not be attempted with empty search text")
        }

        func testDeleteFriendSuccess() {
            let friendToDelete = "A"
            friendsView.friendsList = ["A", "B"]

            mockNetworkHandler.mockDeleteFriendSuccess()
            friendsView.deleteFriendByName(userId: "TestUserID", friendName: friendToDelete) { _ in }
            
            XCTAssertFalse(friendsView.friendsList.contains(friendToDelete), "Friend should be removed from the list upon successful deletion")
        }
        func testDeleteFriendFailure() {
            let friendToDelete = "A"
            let expectedError = "Network Error"
            friendsView.friendsList = ["A", "B"]

            mockNetworkHandler.mockDeleteFriendFailure(error: expectedError)
            friendsView.deleteFriendByName(userId: "TestUserID", friendName: friendToDelete) { result in
                if case .failure(let error) = result {
                    // Verify that the error message is updated in the view
                    XCTAssertEqual(friendsView.errorMessage, error.localizedDescription, "Error message should be updated upon deletion failure")
                } else {
                    XCTFail("Deletion should fail and result in an error")
                }
            }
        }
        func testDeleteNonExistingFriend() {
            let nonExistingFriend = "C"
            friendsView.friendsList = ["A", "B"]

            mockNetworkHandler.mockDeleteFriendSuccess()
            friendsView.deleteFriendByName(userId: "TestUserID", friendName: nonExistingFriend) { _ in }

            XCTAssertEqual(friendsView.friendsList, ["A", "B"], "Friends list should remain unchanged when attempting to delete a non-existing friend")
        }

        func testFetchFriendsOnAppear() {
            mockNetworkHandler.mockGetAllUserFriendsSuccess(friends: ["A", "B"])
            friendsView.onAppear()
            XCTAssertEqual(friendsView.friendsList, ["A", "B"], "Friends list should be updated after fetching friends")
        }

        func testFetchFriendsFailure() {
            let expectedError = "Network Error"
            mockNetworkHandler.mockGetAllUserFriendsFailure(error: expectedError)
            friendsView.onAppear()
            XCTAssertEqual(friendsView.errorMessage, expectedError, "Error message should be updated after a failed fetch")
        }

        func testAddFriendSuccess() {
            let newFriend = "C"
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

}
