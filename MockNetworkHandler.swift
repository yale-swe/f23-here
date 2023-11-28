//
//  mockNetworkHandler.swift
//  newHereTests_v2
//
//  Created by Liyang Wang on 11/27/23.
//

import Foundation

class MockNetworkHandler {
    var friendsList: [String] = []
    var addFriendResult: Result<Void, Error>?
    var deleteFriendResult: Result<Void, Error>?
    var getAllFriendsResult: Result<[String], Error>?
    var postMessageResult: Result<String, Error>?
    var expectedMessage: String?
    
    func mockPostMessageSuccess(message: String) {
        expectedMessage = message
        postMessageResult = .success(message)
    }
    
    func postMessage(user_id: String, text: String, location: CLLocation, completion: @escaping (Result<String, Error>) -> Void) {
        if let result = postMessageResult {
            completion(result)
        } else {
            completion(.success(text))
        }
    }

    init() {
        //
    }

    func mockAddFriendSuccess() {
        addFriendResult = .success(())
    }

    func mockAddFriendFailure(error: String) {
        addFriendResult = .failure(MockError(errorDescription: error))
    }

    func mockDeleteFriendSuccess() {
        deleteFriendResult = .success(())
    }

    func mockDeleteFriendFailure(error: String) {
        deleteFriendResult = .failure(MockError(errorDescription: error))
    }

    func mockGetAllUserFriendsSuccess(friends: [String]) {
        getAllFriendsResult = .success(friends)
    }

    func mockGetAllUserFriendsFailure(error: String) {
        getAllFriendsResult = .failure(MockError(errorDescription: error))
    }

    func addFriendByName(userId: String, friendName: String, completion: (Result<Void, Error>) -> Void) {
        if let result = addFriendResult {
            completion(result)
        }
    }
    func deleteFriendByName(userId: String, friendName: String, completion: (Result<Void, Error>) -> Void) {
        if let result = deleteFriendResult {
            completion(result)
        }
    }
    func getAllUserFriends(userId: String, completion: (Result<[String], Error>) -> Void) {
        if let result = getAllFriendsResult {
            completion(result)
        }
    }

    struct MockError: Error {
        var errorDescription: String?
    }
}

