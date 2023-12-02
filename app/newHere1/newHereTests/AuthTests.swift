//
//  AuthTests.swift
//  newHereTests
//
//  Created by WD on 2023/12/1.
//

import XCTest
import ViewInspector
import SwiftUI

@testable import newHere


final class AuthTests: XCTestCase {

    private var authViewModel: AuthViewModel!

    private var mainView: ContentView!

    private var homePage: HomePageView!
    private var loginView: LoginView!

    
    override func setUpWithError() throws {

        authViewModel = AuthViewModel()
        mainView = ContentView(authViewModel: authViewModel)
        homePage = HomePageView()
        loginView = LoginView(viewModel: authViewModel)
    }

    override func tearDownWithError() throws {

        authViewModel = nil
        mainView = nil
        homePage = nil
        loginView = nil
    }

    func testInitialState() throws {
        
        XCTAssertFalse(authViewModel.isAuthenticated)

        let loginView = try mainView.inspect().find(viewWithTag: "Login")
        XCTAssertNotNil(loginView)
    }
    
    func testAuthorized() throws {
        
        authViewModel.isAuthenticated = true
                
        XCTAssertTrue(loginView.viewModel.isAuthenticated)

        let home = try mainView.inspect().find(viewWithTag: "Home")
        XCTAssertNotNil(home)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
