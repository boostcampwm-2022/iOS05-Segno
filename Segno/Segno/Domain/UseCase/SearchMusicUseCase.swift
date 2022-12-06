//
//  SearchMusicUseCase.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/01.
//

import RxSwift

typealias MusicInfoResult = Result<MusicInfo, Error>

protocol SearchMusicUseCase {
    var musicInfoResult: PublishSubject<MusicInfoResult> { get set }
    
    func startSearching()
    func stopSearching()
}

final class SearchMusicUseCaseImpl: SearchMusicUseCase {
    private let disposeBag = DisposeBag()
    
    let musicRepository: MusicRepository
    var musicInfoResult = PublishSubject<MusicInfoResult>()
    
    init(musicRepository: MusicRepository = MusicRepositoryImpl()) {
        self.musicRepository = musicRepository
        
        subscribeShazamResult()
    }
    
    func startSearching() {
        musicRepository.startSearchingMusic()
    }
    
    func stopSearching() {
        musicRepository.stopSearchingMusic()
    }
}

extension SearchMusicUseCaseImpl {
    private func subscribeShazamResult() {
        musicRepository.shazamSearchResult
            .subscribe(onNext: {
                switch $0 {
                case .success(let shazamSong):
                    let musicInfo = MusicInfo(shazamSong: shazamSong)
                    self.musicInfoResult.onNext(.success(musicInfo))
                case .failure(let error):
                    self.musicInfoResult.onNext(.failure(error))
                }
            })
            .disposed(by: disposeBag)
    }
}
