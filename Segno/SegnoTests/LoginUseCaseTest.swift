//
//  LoginUseCaseTest.swift
//  SegnoTests
//
//  Created by 이예준 on 2022/12/14.
//

import XCTest

final class LoginUseCaseTest: XCTestCase {
    private var sut: LoginUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = LoginUseCaseImpl(repository: LoginRepositoryImpl(),
                               localUtilityManager: LocalUtilityManagerImpl())
    }

    override func tearDownWithError() throws {
        sut = nil
        
        try super.tearDownWithError()
    }

    func test_sendLoginRequest() throws {
        
    }
}
