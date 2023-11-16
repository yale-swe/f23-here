//
//  HomeViewTests.swift
//  newHereUITests
//
//  Created by TRACY LI on 2023/11/16.
//
import XCTest
import SwiftUI
@testable import newHere // Replace with your app's module name

class HomePageViewTests: XCTestCase {
    
    var homePageView: HomePageView!
    
    override func setUpWithError() throws {
        super.setUp()
        homePageView = HomePageView()
        // Mocking the environment object
        //        let locationDataManager = LocationDataManager()
        //        homePageView.locationDataManager = locationDataManager
    }
    
    override func tearDownWithError() throws {
        homePageView = nil
        super.tearDown()
    }
    
    func testInitialState() throws {
        XCTAssertFalse(homePageView.isShowingProfile)
        XCTAssertFalse(homePageView.isShowingMessages)
        XCTAssertFalse(homePageView.isShowingPosts)
        XCTAssertEqual(homePageView.userId, "6546a496b72c080d30e20493")
        // Add more assertions to validate the initial state of your view
    }
    
    func testProfileButtonToggle() throws {
        XCTAssertFalse(homePageView.isShowingProfile)
        // Simulate button tap
        homePageView.isShowingProfile.toggle()
        XCTAssertTrue(homePageView.isShowingProfile)
    }
    
    func testMessagesButtonToggle() throws {
        XCTAssertFalse(homePageView.isShowingMessages)
        // Simulate button tap
        homePageView.isShowingMessages.toggle()
        XCTAssertTrue(homePageView.isShowingMessages)
    }
    
    func testPostsButtonToggle() throws {
        XCTAssertFalse(homePageView.isShowingPosts)
        // Simulate button tap
        homePageView.isShowingPosts.toggle()
        XCTAssertTrue(homePageView.isShowingPosts)
    }
    
    // Add similar tests for other buttons and their actions.
    
    // Test for the CustomARViewRepresentable, MessageState
    
}
