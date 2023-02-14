//
//  CheckSubscriptionUseCase.swift
//  Segno
//
//  Created by Gordon Choi on 2023/02/14.
//

import Foundation

import RxSwift

protocol CheckSubscriptionUseCase {
    func isSubscribedToAppleMusic() -> Completable
}

final class CheckSubscriptionUseCaseImpl: CheckSubscriptionUseCase {
    private let musicRepository: MusicRepository
    
    init(musicRepository: MusicRepository = MusicRepositoryImpl()) {
        self.musicRepository = musicRepository
    }
    
    func isSubscribedToAppleMusic() -> Completable {
        return musicRepository.isSubscribedToAppleMusic()
    }
}
