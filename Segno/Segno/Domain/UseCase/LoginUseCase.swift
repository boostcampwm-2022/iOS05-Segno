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
                
                _ = self.localUtilityRepository.createToken(token: tokenString)
                // TODO: 추후 아래 updateToken 삭제하기!
                _ = self.localUtilityRepository.updateToken(token: "D62WywExHJYoNkLIEsKs+neMK3Fad27IcKtQKfrE3MI=")
                return true
            }
    }
}
