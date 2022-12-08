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
        static let serverToken = "serverToken"
    }

    let repository: LoginRepository
    let localUtilityRepository: LocalUtilityRepository
    private let disposeBag = DisposeBag()

    init(repository: LoginRepository = LoginRepositoryImpl(),
         localUtilityRepository: LocalUtilityRepository = LocalUtilityRepositoryImpl()) {
        self.repository = repository
        self.localUtilityRepository = localUtilityRepository
    }

    func sendLoginRequest(withApple email: String) -> Single<Bool> {
        return repository.sendLoginRequest(withApple: email)
            .map {
                guard let tokenString = $0.token else {
                    return false
                }
                return true
            }
    }
}
