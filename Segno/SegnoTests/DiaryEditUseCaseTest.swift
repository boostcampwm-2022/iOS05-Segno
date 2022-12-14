//
//  DiaryEditUseCaseTest.swift
//  SegnoTests
//
//  Created by 이예준 on 2022/12/14.
//

import XCTest

final class DiaryEditUseCaseTest: XCTestCase {
    private var sut: DiaryEditUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = DiaryEditUseCaseImpl(localUtilityManager: LocalUtilityManagerImpl(),
                                   diaryRepository: DiaryRepositoryImpl(),
                                   imageRepository: ImageRepositoryImpl())
    }

    override func tearDownWithError() throws {
        sut = nil
        
        try super.tearDownWithError()
    }

    func test_postDiary() throws {
        
    }
    
    func test_updateDiary() throws {
        
    }
}
