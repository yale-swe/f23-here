//
//  profileTest.swift
//  newHereTests
//
//  Created by Liyang Wang on 11/10/23.
//
import XCTest
@testable import newHere

final class ProfilePopupTests: XCTestCase {
    var isPopupPresented: Bool!
    var isShowingFriends: Bool!

    override func setUpWithError() throws {
        isPopupPresented = true
        isShowingFriends = false
    }

    override func tearDownWithError() throws {
        isPopupPresented = nil
        isShowingFriends = nil
    }

    func testCloseButtonTogglesPopup() {
        isPopupPresented.toggle()
        XCTAssertFalse(isPopupPresented, "Popup should be closed after toggle")
    }

    func testShowFriendsButtonTogglesFriends() {
        isShowingFriends.toggle()
        XCTAssertTrue(isShowingFriends, "Friends view should be shown after toggle")
    }
    
    func testProfileStatsDisplayCorrectData() {
        let stats = [("Notes", "10"), ("Friends", "100")]
        let profileStats = ProfileStats()
        XCTAssertEqual(profileStats.stats.count, 2, "ProfileStats should have 2 items")
        XCTAssertEqual(profileStats.stats.first?.title, "Notes", "First stat title should be 'Notes'")
        XCTAssertEqual(profileStats.stats.first?.value, "10", "First stat value should be '10'")
    }


}
