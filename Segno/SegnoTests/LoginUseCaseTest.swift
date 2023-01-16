//
//  LoginUseCaseTest.swift
//  SegnoTests
//
//  Created by 이예준 on 2022/12/14.
//

import XCTest

import RxSwift
import RxTest

@testable import Segno

final class LoginUseCaseTest: XCTestCase {
    
    final class StubRepository: LoginRepository {
        func sendLoginRequest(withApple email: String) -> Single<UserLoginDTO> {
            return Single.create { single in
                single(.success(UserLoginDTO(token: "token", userId: "userId")))
                return Disposables.create()
            }
        }
        
        func sendLogoutRequest() {
            
        }
        
        func sendResignRequest(token: String) -> Completable {
            return Completable.create { completable in
                return Disposables.create()
            }
        }
    }
    
    var scheduler: TestScheduler!
    var useCase: LoginUseCase!
    var repository: LoginRepository!
    var manager: LocalUtilityManager!
    var info: TestableObserver<Bool>!
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        scheduler = TestScheduler(initialClock: 0)
        repository = StubRepository()
        manager = LocalUtilityManagerImpl()
        useCase = LoginUseCaseImpl(repository: repository,
                                   localUtilityManager: manager)
        info = scheduler.createObserver(Bool.self)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        scheduler = nil
        useCase = nil
        repository = nil
        manager = nil
        disposeBag = nil
    }

    // MARK: 테스트를 할 때도 실제 keyChain을 바꿔버리네요..
    // MARK: 아무리 테스트였지만.. 실행하고 나면 keyChain이 바뀌는...ㅠㅠㅠㅠ
    // MARK: 그래서 일단 전체 주석처리 하여 실행되지 않도록 하였습니다
    func test_sendLoginRequest() throws {
//        // given
//        let bool = true
//        // 사실 이 값으로 테스트를 어떻게 하는게 맞지 않을까요..?
////        let userDefaultsToken = manager.getToken(key: "userToken")
////        let userDefaultsUserId = manager.getToken(key: "userId")
//
//        // when
//        useCase.sendLoginRequest(withApple: "someToken")
//            .asObservable()
//            .bind(to: info)
//            .disposed(by: disposeBag)
//
//        // then
//        XCTAssertEqual(info.events, [.next(0, bool),
//                                     .completed(0)])
    }
}
