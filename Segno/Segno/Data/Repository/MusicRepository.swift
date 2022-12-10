//
//  MusicRepository.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/01.
//

import RxSwift

protocol MusicRepository {
    func startSearchingMusic()
    func stopSearchingMusic()
    func setupMusic(_ song: MusicInfo?)
    func toggleMusicPlayer()
    func stopPlayingMusic()
    func subscribeSearchresult() -> Observable<ShazamSearchResult>
    func subscribePlayingStatus() -> Observable<Bool>
    func subscribePlayerError() -> Observable<MusicError>
}

final class MusicRepositoryImpl: MusicRepository {
    private let shazamSession: ShazamSession
    private let musicSession: MusicSession
    private let disposeBag = DisposeBag()
    
    init(shazamSession: ShazamSession = ShazamSession(),
         musicSession: MusicSession = MusicSession()) {
        self.shazamSession = shazamSession
        self.musicSession = musicSession
    }
    
    func setupMusic(_ song: MusicInfo?) {
        musicSession.fetchMusic(term: song)
    }
    
    func startSearchingMusic() {
        shazamSession.start()
    }
    
    func stopSearchingMusic() {
        shazamSession.stop()
    }
    
    func toggleMusicPlayer() {
        musicSession.togglePlayer()
    }
    
    func stopPlayingMusic() {
        musicSession.stopMusic()
    }
    
    func subscribeSearchresult() -> Observable<ShazamSearchResult> {
        return shazamSession.resultObservable
    }
    
    func subscribePlayingStatus() -> Observable<Bool> {
        return musicSession.playingStatusObservable
    }
    
    func subscribePlayerError() -> Observable<MusicError> {
        return musicSession.errorStatusObservable
    }
}
