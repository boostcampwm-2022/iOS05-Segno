//
//  SearchMusicUseCase.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/01.
//

import RxSwift

protocol SearchMusicUseCase {
    func startSearching() -> Single<MusicInfo>
    func stopSearching()
}

final class SearchMusicUseCaseImpl: SearchMusicUseCase {
    let musicRepository: MusicRepository
    
    init(musicRepository: MusicRepository = MusicRepositoryImpl()) {
        self.musicRepository = musicRepository
    }
    
    func startSearching() -> Single<MusicInfo> {
        // 음악을 검색해줄 것을 레포지토리에 요청
        
        return Single.create { _ in
            return Disposables.create()
        }
    }
    
    func stopSearching() {
        musicRepository.stopSearchingMusic()
    }
}
