//
//  LoginUseCse.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/17.
//

import RxSwift

protocol LoginUseCase {
    func sendLoginRequest(email: String) -> Single<String>
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

    func sendLoginRequest(email: String) -> Single<String> {
//        return Single.create { single in
//            self.repository.sendLoginRequest(email: email)
//                .subscribe(onSuccess: { token in
//                    print("서버에서 받아온 토큰 : ", token)
//                    single(.success(true))
//                    // TODO: UserInformation Entity를 생성하여
//
//                    // TODO: LocalUtilityRepository에 전달한다.
//                }, onFailure: { error in
//                    single(.failure(error))
//                })
//                .disposed(by: self.disposeBag)
//
//            return Disposables.create()
//        }
        
        return repository.sendLoginRequest(email: email)
            .map {
                let tokenString = $0.token ?? "음슴"
                print(tokenString)
                return tokenString
            }
    }
}
