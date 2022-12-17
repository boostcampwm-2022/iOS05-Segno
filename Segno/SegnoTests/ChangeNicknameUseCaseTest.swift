//
//  ChangeNicknameUseCaseTest.swift
//  SegnoTests
//
//  Created by YOONJONG on 2022/12/17.
//

import XCTest

import RxSwift
import RxTest

@testable import Segno

final class ChangeNicknameUseCaseTest: XCTestCase {
    
    final class StubRepository: SettingsRepository {
        func changeNickname(to nickname: String) -> Single<Bool> {
            return Single.create { single in
                single(.success(true))
                
                return Disposables.create()
            }
        }
    }
    
    var scheduler: TestScheduler!
    var useCase: ChangeNicknameUseCase!
    var repository: SettingsRepository!
    var result: TestableObserver<Bool>!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        scheduler = TestScheduler(initialClock: 0)
        repository = StubRepository()
        useCase = ChangeNicknameUseCaseImpl(repository: repository)
        result = scheduler.createObserver(Bool.self)
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        scheduler = nil
        repository = nil
        useCase = nil
        disposeBag = nil
    }
    
    func test_change_nickname() throws {
        // given when
        useCase.requestChangeNickname(to: "ABC")
            .asObservable()
            .bind(to: result)
            .disposed(by: disposeBag)
        
        // then
        XCTAssertEqual(result.events, [.next(0, true), .completed(0)])
    }
}
