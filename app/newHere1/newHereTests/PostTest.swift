//
//  postTest.swift
//  newHere
//
//  Created by Liyang Wang on 11/10/23.
//
import XCTest
@testable import newHere

class PostsPopupTests: XCTestCase {
    private var isPopupPresented: Bool!
    private var mockLocationDataManager: MockLocationDataManager!
    private var mockMessageState: MockMessageState!
    private var postsPopup: PostsPopup!

    override func setUpWithError() throws {
        isPopupPresented = true
        mockLocationDataManager = MockLocationDataManager()
        mockMessageState = MockMessageState()
        postsPopup = PostsPopup(isPresented: .constant(isPopupPresented),
                                messageState: mockMessageState,
                                locationDataManager: mockLocationDataManager)
    }

    override func tearDownWithError() throws {
        isPopupPresented = nil
        mockLocationDataManager = nil
        mockMessageState = nil
        postsPopup = nil
    }

    func testCloseButtonTogglesPopup() {
        postsPopup.isPresented.toggle()
        XCTAssertFalse(isPopupPresented, "PostsPopup should be closed after close button is tapped")
    }

    func testNoteMessageUpdate() {
        let newMessage = "Updated Message"
        postsPopup.noteMessage = newMessage
        XCTAssertEqual(postsPopup.noteMessage, newMessage, "noteMessage should be updated with new text")
    }

//    func testMessageStateUpdateAfterPosting() {
//        let expectedMessage = "New Message"
//        mockNetworkHandler.mockPostMessageSuccess(message: expectedMessage)
//        postsPopup.postMessage(user_id: "TestUserID", text: expectedMessage, visibility: "friends", locationDataManager: mockLocationDataManager) { _ in }
//        XCTAssertEqual(mockMessageState.currentMessage?.messageStr, expectedMessage, "messageState should be updated after a post")
//    }
//    
//    func testLocationDataManagerUsageInPostMessage() {
//        let expectedLocation = CLLocation(latitude: 0.0, longitude: 0.0)
//        mockLocationDataManager.mockCurrentLocation = expectedLocation
//        postsPopup.postMessage(user_id: "TestUserID", text: "Test", visibility: "friends", locationDataManager: mockLocationDataManager) { _ in }
//        XCTAssertEqual(mockLocationDataManager.lastUsedLocation, expectedLocation, "locationDataManager should use the correct location in postMessage")
//    }
//    
//    func testPostMessageErrorHandling() {
//        mockNetworkHandler.mockPostMessageFailure()
//        postsPopup.postMessage(user_id: "TestUserID", text: "Error Test", visibility: "friends", locationDataManager: mockLocationDataManager) { result in
//            if case .failure(let error) = result {
//                XCTAssertNotNil(error, "Error should not be nil")
//            } else {
//                XCTFail("Error scenario should result in failure")
//            }
//        }
//    }

}
