//
//  SearchMusicUseCase.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/01.
//

import RxSwift

typealias MusicInfoResult = Result<MusicInfo, ShazamError>

protocol SearchMusicUseCase {
    func startSearching()
    func stopSearching()
    func subscribeShazamResult() -> Observable<MusicInfoResult>
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
    
    func subscribeShazamResult() -> Observable<MusicInfoResult> {
        musicRepository.subscribeSearchresult()
            .map {
                switch $0 {
                case .success(let shazamSongDTO):
                    let musicInfo = MusicInfo(shazamSong: shazamSongDTO)
                    return .success(musicInfo)
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
