//
//  newHereTests_v2.swift
//  newHereTests_v2
//
//  Created by Liyang Wang on 11/10/23.
//
import XCTest
@testable import newHere

final class MessagesTests: XCTestCase {
    var sut: MessagesPopup!
    var isPopupPresented: Bool!

    override func setUpWithError() throws {
        super.setUp()
        sut = MessagesPopup(isPresented: .constant(true))
        isPopupPresented = true
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
        isPopupPresented = nil
    }

    func testMessagesPopup_InitialState() throws {
        XCTAssertTrue(sut.isPresented, "Popup should initially be presented")
    }

    func testCloseButton_TogglesIsPresented() throws {
        sut.$isPresented.wrappedValue.toggle()
        XCTAssertFalse(sut.isPresented, "isPresented should be false after close button tap")
    }
    
    func testCloseButtonAction() {
        let popup = MessagesPopup(isPresented: Binding(
            get: { self.isPopupPresented },
            set: { self.isPopupPresented = $0 }
        ))

        popup.isPresented.wrappedValue.toggle()
        XCTAssertFalse(isPopupPresented, "The popup should be dismissed (isPresented should be false) after close button tap")
    }
    
    func testMessageButtonAction() {
        let viewModel = MockViewModel()
        viewModel.selectMessage(id: 1)
        XCTAssertTrue(viewModel.isMessageSelected, "Message should be selected after button tap")
    }

    func testProfilePictureView() {
        let profilePicture = ProfilePicture()
        XCTAssertEqual(profilePicture.body.debugDescription.contains("Image(\"profilePicture\")"), true, "ProfilePicture should contain an image named 'profilePicture'")
    }

}

