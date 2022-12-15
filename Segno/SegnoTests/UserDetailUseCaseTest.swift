//
//  UserDetailUseCaseTest.swift
//  SegnoTests
//
//  Created by YOONJONG on 2022/12/15.
//

import XCTest
import CoreLocation

import RxSwift
import RxTest

@testable import Segno

final class UserDetailUseCaseTest: XCTestCase {
    
    final class StubRepository: MyPageRepository {
        func getUserDetail() -> Single<UserDetailDTO> {
            return Single.create { single in
                let userDetailDTO = UserDetailDTO(
                    nickname: "SegnoUser1",
                    email: "segno@segno.net",
                    oauthType: "Apple",
                    diaryCount: 20220718
                )
                single(.success(userDetailDTO))
                return Disposables.create()
            }
        }
    }
    
    var scheduler: TestScheduler!
    var useCase: UserDetailUseCase!
    var repository: MyPageRepository!
    var userItem: TestableObserver<UserDetailItem>!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        scheduler = TestScheduler(initialClock: 0)
        repository = StubRepository()
        useCase = UserDetailUseCaseImpl(repository: repository)
        userItem = scheduler.createObserver(UserDetailItem.self)
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        scheduler = nil
        repository = nil
        useCase = nil
        disposeBag = nil
    }
    
    func test_getUserDetail() throws {
        // given
        let userDetailItem = UserDetailItem(
            nickname: "SegnoUser1",
            email: "segno@segno.net",
            oauthType: "Apple",
            diaryCount: 20220718
        )
        let correctItem = Recorded.events(
            .next(0, userDetailItem),
            .completed(0)
        )
        
        // when
        useCase.getUserDetail()
            .asObservable()
            .bind(to: userItem)
            .disposed(by: disposeBag)
        
        // then
        XCTAssertEqual(userItem.events, correctItem)
    }
}
