//
//  DiaryDetailUseCaseTest.swift
//  SegnoTests
//
//  Created by 이예준 on 2022/12/14.
//

import XCTest

final class DiaryDetailUseCaseTest: XCTestCase {
    private var sut: DiaryDetailUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = DiaryDetailUseCaseImpl(repository: DiaryRepositoryImpl())
    }

    override func tearDownWithError() throws {
        sut = nil
        
        try super.tearDownWithError()
    }

    func test_getDiary() throws {
        
    }
    
    func test_deleteDiary() throws {
        
    }
}
