//
//  newHereTests_v2.swift
//  newHereTests_v2
//
//  Created by Liyang Wang on 11/10/23.
//
import XCTest
import SwiftUI
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
        var isPopupPresented = false
        let binding = Binding(
            get: { isPopupPresented },
            set: { isPopupPresented = $0 }
        )
        let popup = MessagesPopup(isPresented: binding)

        isPopupPresented.toggle()

        XCTAssertFalse(isPopupPresented, "The popup should be dismissed (isPopupPresented should be false) after close button tap")
    }



}

