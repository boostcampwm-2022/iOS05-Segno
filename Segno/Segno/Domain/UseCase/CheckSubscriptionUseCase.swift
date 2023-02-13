//
//  CheckSubscriptionUseCase.swift
//  Segno
//
//  Created by Gordon Choi on 2023/02/14.
//

import Foundation

import RxSwift

protocol CheckSubscriptionUseCase {
    func isSubscribedToAppleMusic() -> Single<Bool>
}

final class CheckSubscriptionUseCaseImpl: CheckSubscriptionUseCase {
    private let musicRepository: MusicRepository
    
    init(musicRepository: MusicRepository = MusicRepositoryImpl()) {
        self.musicRepository = musicRepository
    }
    
    func isSubscribedToAppleMusic() -> Single<Bool> {
        return Single.create { observer in
            observer(.success(true))
            return Disposables.create()
        }
    }
}
