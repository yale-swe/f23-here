//
//  RegisterTests.swift
//  newHereTests
//
//  Created by WD on 2023/12/1.
//

import XCTest

import ViewInspector
import SwiftUI

@testable import newHere

final class RegisterTests: XCTestCase {

    private var sut: RegistrationView!

    private var viewModel: AuthViewModel!

    private var registrationViewModel: RegistrationViewModel!

    override func setUpWithError() throws {
        
        viewModel = AuthViewModel()
        registrationViewModel = RegistrationViewModel()
        
        sut = RegistrationView(viewModel: viewModel, registrationViewModel: registrationViewModel)
    }

    override func tearDownWithError() throws {
        
        viewModel = nil
        registrationViewModel = nil
        sut = nil
    }

    func testInitialState() throws {
        
        XCTAssertFalse(viewModel.isAuthenticated)
        
        XCTAssertFalse(registrationViewModel.showingAlert)
    }

    func testExists() throws {
        
        let nameSection = try sut.inspect().find(text: "Name")
        XCTAssertNotNil(nameSection)
        
        let credentialsSection = try sut.inspect().find(text: "Credentials")
        XCTAssertNotNil(credentialsSection)
        
        let firstNameTextField = try sut.inspect().find(viewWithAccessibilityIdentifier: "First Name")
        XCTAssertNotNil(firstNameTextField)
        
        let lastNameTextField = try sut.inspect().find(viewWithAccessibilityIdentifier: "Last Name")
        XCTAssertNotNil(lastNameTextField)
        
        let userTextField = try sut.inspect().find(viewWithAccessibilityIdentifier: "Username")
        XCTAssertNotNil(userTextField)
        
        let emailTextField = try sut.inspect().find(viewWithAccessibilityIdentifier: "Email")
        XCTAssertNotNil(emailTextField)
        
        let pwdTextField = try sut.inspect().find(viewWithAccessibilityIdentifier: "Password")
        XCTAssertNotNil(pwdTextField)
        
        let pwdConfirmTextField = try sut.inspect().find(viewWithAccessibilityIdentifier: "Confirm Password")
        XCTAssertNotNil(pwdConfirmTextField)
        
        let registerButton = try sut.inspect().find(button: "Submit")
        XCTAssertNotNil(registerButton)
        
        let backSignInButton = try sut.inspect().find(button: "Already have an account? Login")
        XCTAssertNotNil(backSignInButton)
    }
    
    func testEnterText() throws {
        
        let userTextField = try sut.inspect().find(viewWithAccessibilityIdentifier: "Username").textField()
        try userTextField.setInput("Test02")
        let text = try userTextField.input()
        XCTAssertEqual(text, registrationViewModel.userName)
        
        let pwdTextField = try sut.inspect().find(viewWithAccessibilityIdentifier: "Password").secureField()
        try pwdTextField.setInput("123456")
        let pwd = try pwdTextField.input()
        XCTAssertEqual(pwd, registrationViewModel.password)
    }
    
    func testRegisterWithoutInput() throws {
        
        let userTextField = try sut.inspect().find(viewWithAccessibilityIdentifier: "Username").textField()
        try userTextField.setInput("Test02")
        let text = try userTextField.input()
        XCTAssertEqual(text, registrationViewModel.userName)
        
        let registerButton = try sut.inspect().find(button: "Submit")
        XCTAssertNotNil(registerButton)
        
        try registerButton.tap()

        let expectation = expectation(description: "Wait for register action")

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.1)
        
        XCTAssertFalse(viewModel.isRegistered)
    }
    
//    func testLoginFlow() throws {
//        
//        let userTextField = try sut.inspect().find(viewWithAccessibilityIdentifier: "User Name TextField").textField()
//        try userTextField.setInput("Test01")
//        let text = try userTextField.input()
//        XCTAssertEqual(text, viewModel.username)
//        
//        let pwdTextField = try sut.inspect().find(viewWithAccessibilityIdentifier: "Password TextField").secureField()
//        try pwdTextField.setInput("123456")
//        let pwd = try pwdTextField.input()
//        XCTAssertEqual(pwd, viewModel.password)
//        
//        let loginButton = try sut.inspect().find(button: "Login")
//        XCTAssertNotNil(loginButton)
//        
//        try loginButton.tap()
//
//        let expectation = expectation(description: "Wait for login button action")
//
//        debugPrint("start login...")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
//            
//            expectation.fulfill()
//            debugPrint("login finished.")
//        })
//        wait(for: [expectation], timeout: 5.1)
//        
//        debugPrint("login result: \(viewModel)")
//        debugPrint("login result: \(viewModel.isAuthenticated)")
//        XCTAssertTrue(viewModel.isAuthenticated)
//    }
}
