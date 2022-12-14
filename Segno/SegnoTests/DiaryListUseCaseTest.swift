//
//  DiaryListUseCaseTest.swift
//  SegnoTests
//
//  Created by 이예준 on 2022/12/14.
//

import XCTest

final class DiaryListUseCaseTest: XCTestCase {
    private var sut: DiaryListUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = DiaryListUseCaseImpl(repository: DiaryRepositoryImpl())
    }

    override func tearDownWithError() throws {
        sut = nil
        
        try super.tearDownWithError()
    }

    func test_getDiaryList() throws {
        
    }
}
