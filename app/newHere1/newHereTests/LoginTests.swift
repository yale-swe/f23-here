//
//  LoginTests.swift
//  newHereTests
//
//  Created by WD on 2023/12/1.
//

import XCTest
import ViewInspector
import SwiftUI

@testable import newHere

final class LoginTests: XCTestCase {

    private var sut: LoginView!

    private var viewModel: AuthViewModel!


    override func setUpWithError() throws {
        
        viewModel = AuthViewModel()
        sut = LoginView(viewModel: viewModel)
    }

    override func tearDownWithError() throws {
        
        viewModel = nil
        sut = nil
    }

    func testInitialState() throws {
        
        XCTAssertFalse(viewModel.isAuthenticated)
        
        viewModel.isAuthenticated = true
        
        XCTAssertTrue(viewModel.isAuthenticated)
    }

    func testExists() throws {
        
        let title = try sut.inspect().find(text: "Login")
        XCTAssertNotNil(title)
        
        let userTextField = try sut.inspect().find(viewWithAccessibilityIdentifier: "User Name TextField")
        XCTAssertNotNil(userTextField)
        
        let pwdTextField = try sut.inspect().find(viewWithAccessibilityIdentifier: "Password TextField")
        XCTAssertNotNil(pwdTextField)
        
        let loginButton = try sut.inspect().find(button: "Login")
        XCTAssertNotNil(loginButton)
        
        let registerLink = try sut.inspect().find(navigationLink: "Don't have an account? Signup")
        XCTAssertNotNil(registerLink)
    }
    
    func testNavigationLink() throws {
        
        let registerLink = try sut.inspect().find(navigationLink: "Don't have an account? Signup")
        XCTAssertNotNil(registerLink)
        
        let registerView = try registerLink.view(RegistrationView.self).actualView()
        XCTAssertEqual(registerView.viewModel.isRegistered, false)
    }
    
    func testEnterText() throws {
        
        let userTextField = try sut.inspect().find(viewWithAccessibilityIdentifier: "User Name TextField").textField()
        try userTextField.setInput("Test01")
        let text = try userTextField.input()
        XCTAssertEqual(text, viewModel.username)
        
        let pwdTextField = try sut.inspect().find(viewWithAccessibilityIdentifier: "Password TextField").secureField()
        try pwdTextField.setInput("123456")
        let pwd = try pwdTextField.input()
        XCTAssertEqual(pwd, viewModel.password)
    }
    
    func testLoginWithoutInput() throws {
        
        let userTextField = try sut.inspect().find(viewWithAccessibilityIdentifier: "User Name TextField").textField()
        try userTextField.setInput("Test01")
        let text = try userTextField.input()
        XCTAssertEqual(text, viewModel.username)
        
        let loginButton = try sut.inspect().find(button: "Login")
        XCTAssertNotNil(loginButton)
        
        try loginButton.tap()

        let expectation = expectation(description: "Wait for login button action")

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.1)
        
        XCTAssertFalse(viewModel.isAuthenticated)
    }
    
    func testLoginFlow() throws {
        
        let userTextField = try sut.inspect().find(viewWithAccessibilityIdentifier: "User Name TextField").textField()
        try userTextField.setInput("Test01")
        let text = try userTextField.input()
        XCTAssertEqual(text, viewModel.username)
        
        let pwdTextField = try sut.inspect().find(viewWithAccessibilityIdentifier: "Password TextField").secureField()
        try pwdTextField.setInput("123456")
        let pwd = try pwdTextField.input()
        XCTAssertEqual(pwd, viewModel.password)
        
        let loginButton = try sut.inspect().find(button: "Login")
        XCTAssertNotNil(loginButton)
        
        try loginButton.tap()

        let expectation = expectation(description: "Wait for login button action")

        debugPrint("start login...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            
            expectation.fulfill()
            debugPrint("login finished.")
        })
        wait(for: [expectation], timeout: 5.1)
        
        debugPrint("login result: \(viewModel)")
        debugPrint("login result: \(viewModel.isAuthenticated)")
        XCTAssertTrue(viewModel.isAuthenticated)
    }
}
