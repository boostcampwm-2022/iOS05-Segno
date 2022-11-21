//
//  LoginUseCse.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/17.
//

import RxSwift

protocol LoginUseCase {
    func sendLoginRequest(withApple email: String) -> Single<String>
    func sendLoginRequest(withGoogle email: String) -> Single<String>
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

    func sendLoginRequest(withApple email: String) -> Single<String> {
        return repository.sendLoginRequest(withApple: email)
            .map {
                let tokenString = $0.token ?? "음슴"
                print(tokenString)
                return tokenString
            }
    }
    
    func sendLoginRequest(withGoogle email: String) -> Single<String> {
        return repository.sendLoginRequest(withGoogle: email)
            .map {
                let tokenString = $0.token ?? "음슴"
                print(tokenString)
                return tokenString
            }
    }
}
