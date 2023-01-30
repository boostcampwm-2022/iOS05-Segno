//
//  ResignUseCase.swift
//  Segno
//
//  Created by Gordon Choi on 2023/01/16.
//

import RxSwift

protocol ResignUseCase {
    func sendResignRequest() -> Completable
}

final class ResignUseCaseImpl: ResignUseCase {
    private enum Literal {
        static let userToken = "userToken"
    }
    
    private let repository: LoginRepository
    private let localUtilityManager: LocalUtilityManager
    
    init(repository: LoginRepository = LoginRepositoryImpl(),
         localUtilityManager: LocalUtilityManager = LocalUtilityManagerImpl()) {
        self.repository = repository
        self.localUtilityManager = localUtilityManager
    }
    
    func sendResignRequest() -> Completable {
        let token = localUtilityManager.getToken(key: Literal.userToken)
        return repository.sendResignRequest(token: token)
    }
}
