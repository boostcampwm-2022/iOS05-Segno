//
//  SearchMusicUseCase.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/01.
//

import RxSwift

protocol SearchMusicUseCase {
    func startSearching()
    func stopSearching()
    func subscribeShazamResult() -> Observable<MusicInfo>
    func subscribeShazamError() -> Observable<ShazamError>
}

final class SearchMusicUseCaseImpl: SearchMusicUseCase {
    private let disposeBag = DisposeBag()
    
    let musicRepository: MusicRepository
    
    init(musicRepository: MusicRepository = MusicRepositoryImpl()) {
        self.musicRepository = musicRepository
    }
    
    func startSearching() {
        musicRepository.startSearchingMusic()
    }
    
    func stopSearching() {
        musicRepository.stopSearchingMusic()
    }
    
    func subscribeShazamResult() -> Observable<MusicInfo> {
        musicRepository.subscribeSearchresult()
            .map {
                return MusicInfo(shazamSong: $0)
            }
    }
    
    func subscribeShazamError() -> Observable<ShazamError> {
        musicRepository.subscribeSearchError()
    }
}
