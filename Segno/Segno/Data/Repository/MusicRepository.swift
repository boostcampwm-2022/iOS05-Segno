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
    func isSubscribedToAppleMusic() -> Completable
    func setupMusic(_ song: MusicInfo?)
    func toggleMusicPlayer()
    func stopPlayingMusic()
    func subscribeSearchresult() -> Observable<ShazamSongDTO>
    func subscribeSearchError() -> Observable<ShazamError>
    func subscribePlayingStatus() -> Observable<Bool>
    func subscribeDownloadStatus() -> Observable<Bool>
    func subscribePlayerError() -> Observable<MusicError>
}

final class MusicRepositoryImpl: MusicRepository {
    private let shazamSession: ShazamSession
    private let checkSubscriptionSession: CheckSubscriptionSession
    private let musicSession: MusicSession
    private var disposeBag = DisposeBag()
    
    init(shazamSession: ShazamSession = ShazamSession(),
         checkSubscriptionSession: CheckSubscriptionSession = CheckSubscriptionSession(),
         musicSession: MusicSession = MusicSession()) {
        self.shazamSession = shazamSession
        self.checkSubscriptionSession = checkSubscriptionSession
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
    
    func isSubscribedToAppleMusic() -> Completable {
        return checkSubscriptionSession.isSubscribedToAppleMusic()
    }
    
    func toggleMusicPlayer() {
        musicSession.togglePlayer()
    }
    
    func stopPlayingMusic() {
        musicSession.stopMusic()
    }
    
    func subscribeSearchresult() -> Observable<ShazamSongDTO> {
        return shazamSession.resultObservable
    }
    
    func subscribeSearchError() -> Observable<ShazamError> {
        return shazamSession.errorObservable
    }
    
    func subscribePlayingStatus() -> Observable<Bool> {
        return musicSession.playingStatusObservable
    }
    
    func subscribeDownloadStatus() -> Observable<Bool> {
        return musicSession.downloadStatusObservable
    }
    
    func subscribePlayerError() -> Observable<MusicError> {
        return musicSession.errorStatusObservable
    }
}
