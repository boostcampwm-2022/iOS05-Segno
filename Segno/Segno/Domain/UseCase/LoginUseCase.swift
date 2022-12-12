//
//  LoginUseCse.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/17.
//

import RxSwift

protocol LoginUseCase {
    func sendLoginRequest(withApple email: String) -> Single<Bool>
}

final class LoginUseCaseImpl: LoginUseCase {
    private enum Metric {
        static let userToken: String = "userToken"
        static let userId: String = "userId"
    }
    
    let repository: LoginRepository
    let localUtilityManager: LocalUtilityManager
    private let disposeBag = DisposeBag()

    init(repository: LoginRepository = LoginRepositoryImpl(),
         localUtilityManager: LocalUtilityManager = LocalUtilityManagerImpl()) {
        self.repository = repository
        self.localUtilityManager = localUtilityManager
    }

    func sendLoginRequest(withApple email: String) -> Single<Bool> {
        return repository.sendLoginRequest(withApple: email)
            .map {
                guard let token = $0.token,
                      let userId = $0.userId else { return false }
                
                _ = self.localUtilityManager.createToken(key: Metric.userToken, token: token)
                _ = self.localUtilityManager.createToken(key: Metric.userId, token: userId)
                return true
            }
    }
}
