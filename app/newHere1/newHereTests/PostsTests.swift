//
//  PostsTests.swift
//  newHereTests
//
//  Created by Liyang Wang on 2023/11/10.
//

import XCTest
import ViewInspector

@testable import newHere
import CoreLocation

final class PostsTests: XCTestCase {

    private var postViewModel: PostViewModel!

    private var sut: PostsPopup!

    
    override func setUpWithError() throws {
        
        postViewModel = PostViewModel(isPresented: false, messageState: MessageState(), locationDataManager: LocationDataManager())

        sut = PostsPopup(viewModel: postViewModel)
    }

    override func tearDownWithError() throws {

        postViewModel = nil
        sut = nil
    }

    func testExists() throws {
        
        let defaultPlaceholder = try sut.inspect().find(text: "Leave a message here")
        XCTAssertNotNil(defaultPlaceholder)
        
        let editor = try sut.inspect().find(viewWithAccessibilityIdentifier: "MessageEditor")
        XCTAssertNotNil(editor)
        
        let shareButton = try sut.inspect().find(viewWithAccessibilityIdentifier: "Share Post")
        XCTAssertNotNil(shareButton)
        
        let postButton = try sut.inspect().find(viewWithAccessibilityIdentifier: "Submit Post")
        XCTAssertNotNil(postButton)
    }
    
    func testEnterText() throws {
        
        let editor = try sut.inspect().find(viewWithAccessibilityIdentifier: "MessageEditor").textEditor()
        try editor.setInput("New Message")
        let text = try editor.input()
        XCTAssertEqual(text, postViewModel.noteMessage)
    }

    func testTapPost() throws {
        
        let editor = try sut.inspect().find(viewWithAccessibilityIdentifier: "MessageEditor").textEditor()
        try editor.setInput("New Message")
        let text = try editor.input()
        XCTAssertEqual(text, postViewModel.noteMessage)
        
        postViewModel.userId = "65685aa4e6e0bb9c468a1c3e"
        postViewModel.timeoutInterval = 5.0
        postViewModel.locationDataManager.location = CLLocation(latitude: 0.0, longitude: 0.0)

        let postButton = try sut.inspect().find(viewWithAccessibilityIdentifier: "Submit Post").button()
        XCTAssertNotNil(postButton)
        
        try postButton.tap()

        let expectation = expectation(description: "Wait for post message http request")

        DispatchQueue.main.asyncAfter(deadline: .now() + postViewModel.timeoutInterval, execute: {
            
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: postViewModel.timeoutInterval + 1.0)
        
        XCTAssertNotNil(postViewModel.messageState.currentMessage)
    }

}
